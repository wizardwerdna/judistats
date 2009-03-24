require File.expand_path(File.dirname(__FILE__) + "/hand_constants")
require File.expand_path(File.dirname(__FILE__) + "/pokerstars_hand_history_parser")
class HandHistory
  attr_accessor :lines, :source, :position, :stats
  def initialize lines, source, position
    @lines = lines
    @source = source
    @position = position
    @parsed = false
    @stats = HandStatistics.new
  end
  
  def parsed?
    @parsed
  end
  
  def parse
    @parser = PokerstarsHandHistoryParser.new(@stats)
    @lines.each do |each_line| 
      begin
        @parser.parse(each_line)
      rescue => e
        raise "#{@source}:#{position}: #{e.message}"
      end
    end
    @parsed = true
  end
  
  def reports
    parse unless parsed?
    @stats.reports
  end
end