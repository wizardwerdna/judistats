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
    @parsed = true
  end
end