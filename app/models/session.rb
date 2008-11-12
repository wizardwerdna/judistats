require File.expand_path(File.dirname(__FILE__) + "../../../lib/checker/PSFile.rb")

class Session < ActiveRecord::Base
  has_many  :stats
  has_many  :players, :through => :stats
  has_many  :hands
  
  named_scope :last5, :order => 'mtime desc', :limit => 5
  named_scope :unparsed, :conditions => ['parsed_at IS NULL OR mtime >= parsed_at'], :order => 'mtime DESC'
  named_scope :parsed, :conditions => ['parsed_at IS NOT NULL AND mtime < parsed_at'], :order => 'mtime DESC'
  
  def last_hand_players
    hands.last.players
  end

  def self.update_from_filesystem(glob="/Users/#{`whoami`.chomp}/Library/Application Support/PokerStars/HandHistory/**/*")
    puts("update_from_filesystem(#{glob})")
    logger.info "judistats/update_from_filesystem: #{Time.now}: #{glob}"
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
          logger.info "judistats/update_from_filesystem: #{Time.now}: updating session mtime for '#{record.file}'" if record.changed?
          record.save
        else
          record = create(:prefix => prefix, :player => player, :file => file, :mtime => mtime)
          logger.info "judistats/update_from_filesystem: #{Time.now}: creating session record for '#{record.file}'"
        end
      end
    end
  end
  
  def content_at(starting_at = 0)
    PSFile.open(path).first(starting_at)
  end
  
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
  
  def self.update_stats_for_unparsed_sessions_from_filesystem
    begun_at = Time.now
    logger.info "judistats/update_stats_for_unparsed_sessions_from_filesystem: begun_at: #{Time.now}"
    self.unparsed.each_with_index do |each, index|
      logger.info "judistats/update_stats_from_filesystem: parsed_at #{Time.now}: session: #{each.file}"
      each.update_stats_from_filesystem
    end
    completed_at = Time.now
    logger.info "judistats/update_all_stats_from_filesystem: completed_at: #{completed_at}; elapsed: #{completed_at - begun_at}"
  end

  def update_stats_from_filesystem
    self.parsed_at = Time.now
    PSFile.open(path).collect{|handrecord| handrecord.stats}.flatten.collect do |each|
      result = stats.find_or_create_by_player_id_and_hand_id(each[:player], each[:hand])
      result.update_attributes(each)
      result.save
    end
    self.save
  end
end
