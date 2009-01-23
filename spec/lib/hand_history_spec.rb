require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/checker/hand_history'
require File.dirname(__FILE__) + '/../../lib/checker/hand_statistics'

describe HandHistory, "when created" do
  before :each do
    @lines = ["line 1", "line 2", "line 3"]
    @source = "foo/bar"
    @position = 12345
    @hh = HandHistory.new @lines, @source, @position
  end
  
  it "should have lines" do
    @hh.lines.should == @lines
  end

  it "should have the path to the hand history source" do
    @hh.source.should == @source
  end
  
  it "should have the offset from that path to the hand history represented" do
    @hh.position.should == @position
  end
  
  it "should have hand statistics" do
    @hh.stats.should be_kind_of(HandStatistics)
  end
  
  it "should not have been parsed" do
    @hh.should_not be_parsed
  end
end

describe HandHistory, "after valid parsing" do
  before :each do
    @hh = HandHistory.new [], "here", 0
  end
  
  it "should know it has been parsed" do
    @hh.should_not be_parsed
    @hh.parse
    @hh.should be_parsed
  end
end