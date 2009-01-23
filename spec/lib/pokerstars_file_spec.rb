require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/checker/hand_history')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/checker/pokerstars_file')

describe PokerstarsFile, "when opened on an empty file" do
  it "should complain" do
    lambda{@psfile = PokerstarsFile.open(File.dirname(__FILE__) + '/file_empty.txt')}.should raise_error
  end
end

describe PokerstarsFile, "when opened on a single-hand file" do
  ONE_HAND_NUMBER_OF_ENTRIES = 1
    
  ONE_HAND_ENTRY_NUMBER_OF_LINES = 47
  ONE_HAND_ENTRY_FIRST_LINE = "PokerStars Game #21650146783:  Hold'em No Limit ($0.25/$0.50) - 2008/10/31 17:14:44 ET"
  ONE_HAND_ENTRY_LAST_LINE = "Seat 9: ATTACCA folded before Flop (didn't bet)"

  before do
    @psfile = PokerstarsFile.open(File.dirname(__FILE__) + '/file_one_hand.txt')
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
    @psfile.entries.size.should == ONE_HAND_NUMBER_OF_ENTRIES
  end
  
  it "should have an entry, answering to first, having the correct lines" do
    @entry = @psfile.first
    @entry.lines.size.should == ONE_HAND_ENTRY_NUMBER_OF_LINES
    @entry.lines[0].should == ONE_HAND_ENTRY_FIRST_LINE
    @entry.lines[46].should == ONE_HAND_ENTRY_LAST_LINE
    @psfile.should be_closed
  end
  
  it "should have an entry, answering to entries, having the correct lines" do
    @entry = @psfile.entries.first
    @entry.lines.size.should == ONE_HAND_ENTRY_NUMBER_OF_LINES
    @entry.lines.first.should == ONE_HAND_ENTRY_FIRST_LINE
    @entry.lines.last.should == ONE_HAND_ENTRY_LAST_LINE
  end

  it "should be at the end of file after reading the entry" do
    @psfile.first
    @psfile.should be_eof
  end
end

describe PokerstarsFile, "when opened on a multi-hand file" do
  NUMBER_OF_ENTRIES = 12
  
  FIRST_ENTRY_NUMBER_OF_LINES = 47
  FIRST_ENTRY_FIRST_LINE = "PokerStars Game #21650146783:  Hold'em No Limit ($0.25/$0.50) - 2008/10/31 17:14:44 ET"
  FIRST_ENTRY_LAST_LINE = "Seat 9: ATTACCA folded before Flop (didn't bet)"

  LAST_ENTRY_NUMBER_OF_LINES = 48
  LAST_ENTRY_FIRST_LINE = "PokerStars Game #21650401569:  Hold'em No Limit ($0.25/$0.50) - 2008/10/31 17:24:58 ET"
  LAST_ENTRY_LAST_LINE = "Seat 9: ATTACCA folded before Flop (didn't bet)"
  
  TABLE_OF_STARTING_INDICES = [0, 1526, 2997, 4594, 5939, 7650, 9174, 10740, 12137, 13446, 14589, 15823]

  before do
    @psfile = PokerstarsFile.open(File.dirname(__FILE__) + '/file_many_hands.txt')
    @expanded_path = File.expand_path(File.dirname(__FILE__) + '/file_many_hands.txt')
  end
  
  it "should be open" do
    @psfile.should_not be_closed
  end
  
  it "should not be eof" do
    @psfile.should_not be_eof
  end
  
  it "should read all the hands in the test file" do
    @psfile.entries.size.should == NUMBER_OF_ENTRIES
  end
  
  it "should collect entries with all the proper information" do
    list = TABLE_OF_STARTING_INDICES.clone
    @psfile.entries.each do |handrecord|
      handrecord.source.should == @expanded_path
      handrecord.position.should == list.shift
    end
  end
  
  it "should be able to access records through valid positions" do
    TABLE_OF_STARTING_INDICES.each do |index|
      @entry = @psfile.first(index)
    end
  end
  
  it "should complain when attempting to reach records through invalid positions" do
    TABLE_OF_STARTING_INDICES.each do |index|
      lambda {@psfile.pos=each+1}.should raise_error
    end
  end
  
  it "should have a first entry having the correct lines, addressable through #first" do
    @psfile.entries #run through the file to see if it resets properly
    @entry = @psfile.first(TABLE_OF_STARTING_INDICES.first)
    @entry.lines.size.should == FIRST_ENTRY_NUMBER_OF_LINES
    @entry.lines.first.should == FIRST_ENTRY_FIRST_LINE
    @entry.lines.last.should == FIRST_ENTRY_LAST_LINE
    @psfile.should be_closed
  end
  
  it "should have a first entry having the correct lines, addresable through #entries" do
    @entries = @psfile.entries
    @entries.first.lines.size.should == FIRST_ENTRY_NUMBER_OF_LINES
    @entries.first.lines.first.should == FIRST_ENTRY_FIRST_LINE
    @entries.first.lines.last.should == FIRST_ENTRY_LAST_LINE
  end
  
  it "should have a last entry having the correct lines, addressable through #first" do
    @entry = @psfile.first(TABLE_OF_STARTING_INDICES.last)
    @entry.lines.size.should == LAST_ENTRY_NUMBER_OF_LINES
    @entry.lines.first.should == LAST_ENTRY_FIRST_LINE
    @entry.lines.last.should == LAST_ENTRY_LAST_LINE
  end

  it "should have a last entry having the correct lines, addressable through #entries" do
    @entries = @psfile.entries
    @entries.last.lines.size.should == LAST_ENTRY_NUMBER_OF_LINES
    @entries.last.lines.first.should == LAST_ENTRY_FIRST_LINE
    @entries.last.lines.last.should == LAST_ENTRY_LAST_LINE
  end
  
  it "should be at the end of file after reading all the entries" do
    @psfile.entries
    @psfile.should be_eof
  end
end