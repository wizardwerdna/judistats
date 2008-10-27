class Ftfile < ActiveRecord::Base
  has_many :summaries

  def Ftfile.update_glob(glob)
    Dir[glob].each do |fd|
      folder = File.dirname(fd)
      file = File.basename(fd)
      unless (fd =~ /Summary.txt$/) || File.directory?(fd)
        record = find(:first, :conditions => ['folder = ? AND file = ?', folder, file]) || new(:folder => folder, :file => file)
        record.update_timestamp
puts "record #{record.inspect}" if record.changed?
        record.save
      end
    end
  end
  
  named_scope :last5, :order => 'mtime desc', :limit => 5
  
  def Ftfile.create_or_update(folder, file)
    result = new_record? create | update
  end

  # file descriptor for this ftfile
  def path
    File.expand_path(File.join(folder, file))
  end
  
  def update_timestamp
    self.mtime = filesystem_mtime
  end
  
  # last modification time on file system at present
  def filesystem_mtime
    File.mtime(path)
  end
  
  # content for our system
  def content
    current_content
  end

  # content on the file system at present
  def current_content
    begin
      File.readlines(path).collect{|each| each.chomp!}
    rescue
      raise "could not open/read %s" % path
    end
  end
end