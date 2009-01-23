require File.expand_path(File.dirname(__FILE__) + '/hand_statistics')

CASH = "[0-9$,.]+"

class PokerstarsHandHistoryParser
  def self.parse_lines(lines, stats=nil)
    parser = self.new(stats)
    lines.each {|line| parser.parse(line)}
  end
  
  def initialize stats=nil
    @stats = stats || HandStatistics.new
  end
  
  def parse(line)
    @stats.register_action("me", "foo") if line == "foo"
    case line
    when /PokerStars Game #([0-9]+): Tournament #([0-9]+), (\$[0-9+$]+) ([^\-]*) - Level ([IVXL]+) \((#{CASH})\/(#{CASH})\) - (.*)$/
      @stats.update_hand :name => "PS#{$1}", :description=> "#{$2}, #{$3} #{$4}", :tournament=> $2, :sb=> $6.to_d, :bb=> $7.to_d, :played_at=> Time.parse($8)
    when /PokerStars Game #([0-9]+): +([^(]*) \((#{CASH})\/(#{CASH})\) - (.*)$/
      @stats.update_hand :name => "PS#{$1}", :description=> "#{$2} (#{$3}/#{$4})", :tournament=> nil, :sb=> cash_to_d($3), :bb=> cash_to_d($4), :played_at=> Time.parse($5)
    when /\*\*\* HOLE CARDS \*\*\*/
      @stats.update_hand :street => :prelude
    when /\*\*\* FLOP \*\*\* \[(.*)\]/
      @stats.update_hand :street => :flop
    when /\*\*\* TURN \*\*\* \[([^\]]*)\] \[([^\]]*)\]/
      @stats.update_hand :street => :turn
    when /\*\*\* RIVER \*\*\* \[([^\]]*)\] \[([^\]]*)\]/
      @stats.update_hand :street => :river
    when /\*\*\* SHOW DOWN \*\*\*/
      @stats.update_hand :street => :showdown
    when /\*\*\* SUMMARY \*\*\*/
      @stats.update_hand :street => :summary
    when /PokerStars Game #([0-9]+):/
      raise "invalid hand record: #{line}"
    else
      raise "invalid line for parse: #{line}"
    end
  end
  
  private
  
  def cash_to_d(string)
    string.gsub!(/[$, ]/,"")
    string.to_d
  end
end