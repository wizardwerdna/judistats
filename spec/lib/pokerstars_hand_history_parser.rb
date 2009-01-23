require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/checker/hand_history'
require File.dirname(__FILE__) + '/../../lib/checker/hand_statistics'
require File.dirname(__FILE__) + '/../../lib/checker/pokerstars_hand_history_parser'

describe PokerstarsHandHistoryParser, "when parsing structural matter" do
  before :each do
    @stats = HandStatistics.new
    @parser = PokerstarsHandHistoryParser.new(@stats)
  end
   
  it "should parse a tournament header" do
    @stats.should_receive(:update_hand).with(
      :name => "PS21650436825",
      :description => "117620218, $10+$1 Hold'em No Limit",
      :sb => "10".to_d,
      :bb => "20".to_d,
      :played_at => Time.parse("2008/10/31 17:25:42 ET"),
      :tournament => "117620218"
    )
    @parser.parse("PokerStars Game #21650436825: Tournament #117620218, $10+$1 Hold'em No Limit - Level I (10/20) - 2008/10/31 17:25:42 ET")
  end
  
  it "should parse a cash game header" do
    @stats.should_receive(:update_hand).with(
      :name => 'PS21650146783',
      :description => "Hold'em No Limit ($0.25/$0.50)",
      :sb => "0.25".to_d, 
      :bb => "0.50".to_d,
      :played_at => Time.parse("2008/10/31 17:14:44 ET"),
      :tournament => nil
    )
    @parser.parse("PokerStars Game #21650146783:  Hold'em No Limit ($0.25/$0.50) - 2008/10/31 17:14:44 ET")
  end
  
  it "should parse a hole card header" do
    @stats.should_receive(:update_hand).with(:street => :prelude)
    @parser.parse("*** HOLE CARDS ***")
  end
  
  it "should parse a flop header" do
    @stats.should_receive(:update_hand).with(:street => :flop)
    @parser.parse("*** FLOP *** [5c 2d Jh]")
  end
  
  it "should parse a turn header" do
    @stats.should_receive(:update_hand).with(:street => :turn)
    @parser.parse("*** TURN *** [5c 2d Jh] [4c]")
  end
  
  it "should parse a river header" do
    @stats.should_receive(:update_hand).with(:street => :river)
    @parser.parse("*** RIVER *** [5c 2d Jh 4c] [5h]")
  end
  
  it "should parse a showdown header" do
    @stats.should_receive(:update_hand).with(:street => :showdown)
    @parser.parse("*** SHOW DOWN *** [5c 2d Jh 4c] [5h]")
  end
  
  it "should parse a summary header" do
    @stats.should_receive(:update_hand).with(:street => :summary)
    @parser.parse("*** SUMMARY *** [5c 2d Jh 4c] [5h]")
  end
  
  it "should parse a 'dealt to' header" do
        @stats.register_action player[:screen_name], 'shows', hash.merge(:result => :cards, :data => data)
    @stats.should_receive(:register_action).with('wizardwerdna', 'dealt', :result => :cards, :data => data)
    @parser.parse("Dealt to wizardwerdna [2s Th]")
  end
  
  it "should parse a 'Total pot' card header" do
    @stats.should_receive(:update_hand).with()
    @parser.parse("Total pot $10.75 | Rake $0.50")
  end
  
  it "should parse a board header" do
    @stats.should_receive(:update_hand).with()
    @parser.parse("Board [5c 2d Jh 4c 5h]")
  end
end


describe PokerstarsHandHistoryParser, "when parsing prelude matter" do
  before :each do
    @stats = HandStatistics.new
    @parser = PokerstarsHandHistoryParser.new(@stats)
  end

  it "should parse a button line" do
    @stats.should_receive(:register_button).with()
    @parser.parse("Table '117620218 1' 9-max Seat #1 is the button")
  end

  it "should parse a player line" do
    @stats.should_receive(:register_player).with()
    @parser.parse("Seat 3: BadBeat_Brat (1500 in chips)")
  end

  it "should parse a small blind header and register the corresponding action" do
    @stats.should_receive(:register_action).with()
    @parser.parse("Hoggsnake: posts small blind 10")
  end

  it "should parse a big blind header and register the corresponding action" do
    @stats.should_receive(:register_action).with()
    @parser.parse("BadBeat_Brat: posts big blind 20")
  end

  it "should parse a posting header and register the corresponding action" do
    @stats.should_receive(:register_action).with()
    @parser.parse("")
  end

  it "should parse an ante header and register the corresponding action" do
    @stats.should_receive(:register_action).with()
    @parser.parse("")
  end
end