require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_constants')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_statistics')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_history')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/pokerstars_file')


class CompliesWith
  def initialize(expected)
    @expected = expected
    @state = nil
  end

  def matches?(actual)
    @actual = actual
    # Satisfy expectation here. Return false or raise an error if it's not met.
    @expected.keys.each do |player_key|
      @player_key = player_key
      @state = :comparing_player_keys
      return false unless @actual.has_key?(player_key)
      @expected[player_key].keys.each do |stat_key|
        @stat_key = stat_key
        @state = :comparing_stat_keys
        return false unless @actual[player_key].has_key?(stat_key)
        @state = :comparing_stat_values
        return false unless @actual[player_key][stat_key] == @expected[player_key][stat_key]
      end
    end
    true
  end

  def failure_message
    case @state
    when :comparing_player_keys
      "there is no report for player #{@player_key.inspect}"
    when :comparing_stat_keys
      "there is no statistic #{@stat_key.inspect} for player #{@player_key.inspect}"
    when :comparing_stat_values
      "statistic #{@stat_key.inspect} for player #{@player_key.inspect} was supposed to be #{@expected[@player_key][@stat_key].inspect}, but was actually (#{@actual[@player_key][@stat_key].inspect})"
    else
      "there has been an internal error"
    end
  end

  def negative_failure_message
      "two hashes were not supposed to comply, but did"
  end
end

def comply_with(expected)
  CompliesWith.new(expected)
end

RESULT = {
  "wizardwerdna" =>
  {
    :posted => 0,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => "Qc 4d",
  },
    "Gw\"unni" =>
  {
    :posted => 0,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => nil
  },
  "bimbi76" =>
  {
    :posted => 0,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => nil
  },
  "MartinBOF84" =>
  {
    :posted => 0,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => nil
  },
  "Spidar" =>
  {
    :posted => 10,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => nil
  },
  "EEYORE_Q6" =>
  {
    :posted => 0,
    :paid => 160,
    :won => 175,
    :preflop_aggressive => 0,
    :preflop_passive => 1,
    :postflop_passive => 1,
    :postflop_aggressive => 2,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => "2s Ah"
  },
  "izibi" => 
  {
    :posted => 0,
    :paid => 160,
    :won => 175,
    :preflop_aggressive => 0,
    :preflop_passive => 1,
    :postflop_passive => 1,
    :postflop_aggressive => 1,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => "Ad 6d"
  },
  "Little Dee" =>
  {
    :posted => 20,
    :paid => 0,
    :won => 0,
    :preflop_aggressive => 0,
    :preflop_passive => 0,
    :postflop_passive => 0,
    :postflop_aggressive => 0,
    :is_blind_attack_opportunity => false,
    :is_blind_attack_opportunity_taken => false,
    :is_blind_defense_opportunity => false,
    :is_blind_defense_opportunity_taken => false,
    :is_pfr_opportunity => true,
    :is_pfr_opportunity_taken => false,
    :is_cbet_opportunity => false,
    :is_cbet_opportunity_taken => false,
    :cards => nil
  },
}

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
    @lines = PokerstarsFile.open(File.dirname(__FILE__) + '/file_one_hand.txt').first.lines
    @goodhh = HandHistory.new @lines, "here", 0
    @badhh = HandHistory.new ["BAD FIRST LINE"] + @lines, "here", 0
  end
  
  it "should complain when parsing an invalid hand record" do
    lambda{@badhh.parse}.should raise_error
  end
  
  it "should raise an error beginning with source and position information when parsing an invalid hand record" do
    lambda{@badhh.parse}.should raise_error(/^here:0: invalid line for parse/)
  end
  
  it "should not complain when parsing a valid hand record" do
    lambda{@goodhh.parse}.should_not raise_error
  end
  
  it "should return accurate statistics after parsing a valid hand record" do
    puts @goodhh.reports.inspect
    puts RESULT.inspect
    @goodhh.reports.should comply_with(RESULT)
  end
  
  it "should know it has been parsed" do
    @goodhh.should_not be_parsed
    @goodhh.parse
    @goodhh.should be_parsed
  end
end