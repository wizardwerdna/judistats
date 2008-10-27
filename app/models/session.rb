require File.expand_path(File.dirname(__FILE__) + "../../../lib/checker/FTFile.rb")

class Session < ActiveRecord::Base
  has_many  :stats
  has_many  :players, :through => :stats
  has_many  :hands, :through => :stats do
    def last
      sort{|a, b| b.name <=> a.name}.first
    end
  end
  
  def last_hand_players
    hands.last.players
  end

  def self.update_from_filesystem(glob="/Users/#{`whoami`.chomp}/Documents/HandHistory/**/*")
    puts glob
    Dir[glob].each do |fd|
      prefix = File.dirname(File.dirname(fd))
      player = File.basename(File.dirname(fd))
      file = File.basename(fd)
      unless (fd =~ /Summary.txt$/) || File.directory?(fd)
        record = find(:first, :conditions => ['prefix = ? AND player = ? AND file = ?', prefix, player, file]) || 
                    new(:prefix => prefix, :player => player, :file => file)
        record.update_timestamp
  puts "record #{record.inspect}" if record.changed?
        record.save
      end
    end
  end
  
  def self.update_from_filesystem2(glob="/Users/#{`whoami`.chomp}/Documents/HandHistory/**/*")
    puts glob
    table = {}
    find(:all).collect{|each| table[each.path] = each}
    Dir[glob].each do |fd|
      prefix = File.dirname(File.dirname(fd))
      player = File.basename(File.dirname(fd))
      file = File.basename(fd)
      mtime = File.mtime(fd)
      unless (fd =~ /Summary.txt$/) || File.directory?(fd)
        if record = table[fd]
          record.update_timestamp
          puts "record #{record.inspect}" if record.changed?
          record.save
        else
          create(:prefix => prefix, :player => player, :file => file, :mtime => mtime)
        end
      end
    end
  end
  
  named_scope :last5, :order => 'mtime desc', :limit => 5
  named_scope :unparsed, :conditions => ['parsed_at IS NULL OR mtime >= parsed_at'], :order => 'mtime DESC'
  named_scope :parsed, :conditions => ['parsed_at IS NOT NULL AND mtime < parsed_at'], :order => 'mtime DESC'
  
  # file descriptor for this ftfile
  def path
    File.expand_path(File.join(prefix, player, file))
  end

  def update_timestamp
    self.mtime = filesystem_mtime
  end

  # last modification time on file system at present
  def filesystem_mtime
    File.mtime(path)
  end

  def ftfile
    FTFile.open(path)
  end

  # content for our system
  def content
    content_from_filesystem
  end

  # content on the file system at present
  def content_from_filesystem
    begin
      File.readlines(path).collect{|each| each.chomp!}
    rescue
      raise "could not open/read %s" % path
    end
  end
  
  def self.parse_unparsed_sessions
    self.unparsed.each do |each|
      each.stats_from_filesystem
    end
  end
  
  def stats_from_filesystem
    self.parsed_at = Time.now
    FTFile.open(path).collect{|handrecord| handrecord.stats}.flatten.collect do |each|
      result = stats.find_or_create_by_player_id_and_hand_id(each[:player], each[:hand])
      result.update_attributes(each)
      result.save
    end
    self.save
  end
end
