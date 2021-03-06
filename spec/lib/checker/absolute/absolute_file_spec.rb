require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../../lib/checker/hand_history')
require File.expand_path(File.dirname(__FILE__) + '/../../../../lib/checker/absolute_file')

describe AbsoluteFile, "when opened on an empty file" do
  it "should complain" do
    lambda{@psfile = AbsoluteFile.open(File.dirname(__FILE__) + '/file_empty.txt')}.should raise_error
  end
end

describe AbsoluteFile, "when opened on a single-hand file" do
  ABS_ONE_HAND_NUMBER_OF_ENTRIES = 1
    
  ABS_ONE_HAND_ENTRY_NUMBER_OF_LINES = 45
  ABS_ONE_HAND_ENTRY_FIRST_LINE = "Stage #1323644698: Holdem  No Limit $0.50 - 2009-03-20 11:18:48 (ET)"
  ABS_ONE_HAND_ENTRY_LAST_LINE = "Seat 9: POKR_WIZ collected Total ($1.20) HI:($1.20)  [Does not show] "
  

  before do
    @psfile = AbsoluteFile.open(File.dirname(__FILE__) + '/abs_file_one_hand.txt')
  end
  
  it "should be open" do
    @psfile.should_not be_closed
  end
  
  it "should not be eof" do
    @psfile.should_not be_eof
  end
  
  it "should be at position zero" do
    @psfile.pos.should be_zero
  end
  
  it "should read all the hands in the test file" do
    @psfile.should have(ABS_ONE_HAND_NUMBER_OF_ENTRIES).entries
  end
  
  it "should have an entry, answering to first, having the correct lines" do
    @entry = @psfile.first
    @entry.should have(ABS_ONE_HAND_ENTRY_NUMBER_OF_LINES).lines
    @entry.lines[0].should == ABS_ONE_HAND_ENTRY_FIRST_LINE
    @entry.lines[ABS_ONE_HAND_ENTRY_NUMBER_OF_LINES-1].should == ABS_ONE_HAND_ENTRY_LAST_LINE
    @psfile.should be_closed
  end
  
  it "should have an entry, answering to entries, having the correct lines" do
    @entry = @psfile.entries.first
    @entry.should have(ABS_ONE_HAND_ENTRY_NUMBER_OF_LINES).lines
    @entry.lines.first.should == ABS_ONE_HAND_ENTRY_FIRST_LINE
    @entry.lines.last.should == ABS_ONE_HAND_ENTRY_LAST_LINE
  end

  it "should be at the end of file after reading the entry" do
    @psfile.first
    @psfile.should be_eof
  end
end

# describe AbsoluteFile, "when opened on a file encoded in Latin-1, should transliterate properly to ASCII" do
#   LATIN1_LINE_INDEX = 8
#   LATIN1_LINE_TRANSLITERATED = "Seat 8: Gw\"unni (3000 in chips) "
#   
#   before do
#     @psfile = AbsoluteFile.open(File.dirname(__FILE__) + '/abs_file_one_hand.txt')
#     @entry = @psfile.entries.first
#   end
#   
#   it "should properly transliterate the selected line" do
#     @entry.lines[LATIN1_LINE_INDEX].should == LATIN1_LINE_TRANSLITERATED
#   end
# end
# 

describe AbsoluteFile, "when opened on a multi-hand file" do
  ABS_NUMBER_OF_ENTRIES = 10
  
  ABS_FIRST_ENTRY_NUMBER_OF_LINES = 45
  ABS_FIRST_ENTRY_FIRST_LINE = "Stage #1323644698: Holdem  No Limit $0.50 - 2009-03-20 11:18:48 (ET)"
  ABS_FIRST_ENTRY_LAST_LINE = "Seat 9: POKR_WIZ collected Total ($1.20) HI:($1.20)  [Does not show] "

  ABS_LAST_ENTRY_NUMBER_OF_LINES = 44
  ABS_LAST_ENTRY_FIRST_LINE = "Stage #1323655130: Holdem  No Limit $0.50 - 2009-03-20 11:26:54 (ET)"
  ABS_LAST_ENTRY_LAST_LINE = "Seat 9: POKR_WIZ collected Total ($4.05) HI:($4.05)  [Does not show] "
  
  ABS_TABLE_OF_STARTING_INDICES = [0, 1464, 3184, 4706, 6151, 7525, 8770, 10467, 12030, 13672]
  
  before do
    @psfile = AbsoluteFile.open(File.dirname(__FILE__) + '/abs_file_many_hands.txt')
    @expanded_path = File.expand_path(File.dirname(__FILE__) + '/abs_file_many_hands.txt')
  end
  
  it "should be open" do
    @psfile.should_not be_closed
  end
  
  it "should not be eof" do
    @psfile.should_not be_eof
  end
  
  it "should read all the hands in the test file" do
    @psfile.should have(ABS_NUMBER_OF_ENTRIES).entries
  end
  
  it "should collect entries with all the proper information" do
    list = ABS_TABLE_OF_STARTING_INDICES.clone
    @psfile.entries.each do |handrecord|
      handrecord.source.should == @expanded_path
      handrecord.position.should == list.shift
    end
  end
  
  it "should be able to access records through valid positions" do
    ABS_TABLE_OF_STARTING_INDICES.each do |index|
      @entry = @psfile.first(index)
    end
  end
  
  it "should complain when attempting to reach records through invalid positions" do
    ABS_TABLE_OF_STARTING_INDICES.each do |index|
      lambda {@psfile.pos=each+1}.should raise_error
    end
  end
  
  it "should have a first entry having the correct lines, addressable through #first" do
    @psfile.entries #run through the file to see if it resets properly
    @entry = @psfile.first(ABS_TABLE_OF_STARTING_INDICES.first)
    @entry.should have(ABS_FIRST_ENTRY_NUMBER_OF_LINES).lines
    @entry.lines.first.should == ABS_FIRST_ENTRY_FIRST_LINE
    @entry.lines.last.should == ABS_FIRST_ENTRY_LAST_LINE
    @psfile.should be_closed
  end
  
  it "should have a first entry having the correct lines, addresable through #entries" do
    @entries = @psfile.entries.first
    @entries.should have(ABS_FIRST_ENTRY_NUMBER_OF_LINES).lines
    @entries.lines.first.should == ABS_FIRST_ENTRY_FIRST_LINE
    @entries.lines.last.should == ABS_FIRST_ENTRY_LAST_LINE
  end
  
  it "should have a last entry having the correct lines, addressable through #first" do
    @entry = @psfile.first(ABS_TABLE_OF_STARTING_INDICES.last)
    @entry.should have(ABS_LAST_ENTRY_NUMBER_OF_LINES).lines
    @entry.lines.first.should == ABS_LAST_ENTRY_FIRST_LINE
    @entry.lines.last.should == ABS_LAST_ENTRY_LAST_LINE
  end

  it "should have a last entry having the correct lines, addressable through #entries" do
    @entries = @psfile.entries.last
    @entries.should have(ABS_LAST_ENTRY_NUMBER_OF_LINES).lines
    @entries.lines.first.should == ABS_LAST_ENTRY_FIRST_LINE
    @entries.lines.last.should == ABS_LAST_ENTRY_LAST_LINE
  end
  
  it "should be at the end of file after reading all the entries" do
    @psfile.entries
    @psfile.should be_eof
  end
end