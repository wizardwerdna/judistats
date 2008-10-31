class FileMonitor
  MONITOR_COMMAND = "/usr/bin/god"
  MONITOR_CONFIG_FILE = File.expand_path(File.dirname(__FILE__) + "../../../config/file_monitors.god")  
  MONITOR_STATUS_COMMAND = "#{MONITOR_COMMAND} status"
  MONITOR_CHECK_COMMAND = ""
  MONITOR_START_COMMAND = "#{MONITOR_COMMAND} -c #{MONITOR_CONFIG_FILE}"
  MONITOR_STOP_COMMAND = "#{MONITOR_COMMAND} terminate"

  def self.status_string
    begin
      `#{MONITOR_STATUS_COMMAND}`
    rescue StandardError
      "monitor:down"
    end
  end
  
  def self.find(*parms)
    status_string.split("\n").collect do |each|
      if (/[ \t]*(.*):[ \t]*(.+)/ =~ each).nil?
        nil
      else
        new($1,$2)
      end
    end.reject{|each| each.nil?}
  end
  
  def self.status
    Hash[*status_array]
  end
  
  def self.check
    `{MONITOR_CHECK_COMMAND}`
  end
  
  def self.start
    `#{MONITOR_START_COMMAND}`
  end

  def self.stop
    `#{MONITOR_STOP_COMMAND}`
  end
  
  def initialize(name, status)
    @name = name
    @status = status
  end
  
  def name
    @name
  end
  
  def status
    @status
  end
  
end