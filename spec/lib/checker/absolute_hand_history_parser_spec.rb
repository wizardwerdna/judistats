require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_history')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_statistics')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/pokerstars_file')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/absolute_hand_history_parser')

include HandConstants

describe AbsoluteHandHistoryParser, "when parsing structural matter" do
  before :each do
    @stats = HandStatistics.new
    @parser = AbsoluteHandHistoryParser.new(@stats)
  end
   
  it "should parse a tournament header" do
    @stats.should_receive(:update_hand).with(
      :name => "AB1546002988",
      :description => "Holdem  No Limit 30",
      :sb => "30".to_d,
      :bb => "60".to_d,
      :played_at => Time.parse("2009-03-22 17:24:34 (ET)"),
      :tournament => true,
      :street => :prelude
    )
    @parser.parse("Stage #1546002988: Holdem  No Limit 30 - 2009-03-22 17:24:34 (ET)")
  end
  
  it "should parse a cash game header" do
    @stats.should_receive(:update_hand).with(
      :name => 'AB1323644698',
      :description => "Holdem  No Limit $0.50",
      :sb => "0.50".to_d, 
      :bb => "1.00".to_d,
      :played_at => Time.parse("2009-03-20 11:18:48 (ET)"),
      :tournament => nil,
      :street => :prelude
    )
    @parser.parse("Stage #1323644698: Holdem  No Limit $0.50 - 2009-03-20 11:18:48 (ET)")
  end
  
  it "should parse a hole card header" do
    @stats.should_receive(:update_hand).with(:street => :preflop)
    @parser.parse("*** POCKET CARDS ***")
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
    @stats.should_receive(:register_action).with('wizardwerdna', 'dealt', :result => :cards, :data => "2s Th")
    @parser.parse("Dealt to wizardwerdna [2s Th]")
  end
  
  it "should parse a 'Total pot' card header" do
    @stats.should_receive(:update_hand).with(:total_pot => "10.75".to_d, :rake => "0.50".to_d)
    @parser.parse("Total pot ($10.75) | Rake ($0.50)")
  end
  
  it "should parse a board header" do
    @stats.should_receive(:update_hand).with(:board => "5c 2d Jh 4c 5h")
    @parser.parse("Board [5c 2d Jh 4c 5h]")
  end
end


describe AbsoluteHandHistoryParser, "when parsing prelude matter" do
  before :each do
    @stats = HandStatistics.new
    @parser = AbsoluteHandHistoryParser.new(@stats)
  end

  it "should parse a tournament button line" do
    @stats.should_receive(:register_button).with(1)
    @parser.parse("Table: Seven Mile (Real Money) Seat #1 is the dealer")
  end

  # it "should parse a cash game button line" do
  #   @stats.should_receive(:register_button).with(2)
  #   @parser.parse("Table 'Charybdis IV' 9-max Seat #2 is the button")
  # end

  it "should parse a player line" do
    @stats.should_receive(:register_player).with(:screen_name => 'MAGELA_', :seat => 1)
    @parser.parse("Seat 1 - MAGELA_ ($11.95 in chips)")
  end

  # it "should parse a player line with accents" do
  #   @stats.should_receive(:register_player).with(:screen_name => 'Gwünni', :seat => 8)
  #   @parser.parse("Seat 8: Gwünni (3000 in chips)")
  # end

  it "should parse a small blind header and register the corresponding action" do
    @stats.should_receive(:register_action).with("XEXPO", 'posts', :result => :post, :amount => "0.25".to_d)
    @parser.parse("XEXPO - Posts small blind $0.25")
  end

  it "should parse a big blind header and register the corresponding action" do
    @stats.should_receive(:register_action).with("TUMTUM972", 'posts', :result => :post, :amount => "0.50".to_d)
    @parser.parse("TUMTUM972 - Posts big blind $0.50")
  end

  it "should parse an ante header and register the corresponding action" # do
  #     @stats.should_receive(:register_action).with("BadBeat_Brat", 'antes', :result => :post, :amount => "15".to_d)
  #     @parser.parse("BadBeat_Brat: posts the ante 15")
  #   end
end


describe AbsoluteHandHistoryParser, "when parsing poker actions" do
  before :each do
    @stats = HandStatistics.new
    @parser = AbsoluteHandHistoryParser.new(@stats)
  end
  
  it "should properly parse and register a fold" do
    @stats.should_receive(:register_action).with("DROPKICKU17", "folds", :result => :neutral)
    @parser.parse("DROPKICKU17 - Folds")
  end
  it "should properly parse and register a check" do
    @stats.should_receive(:register_action).with("TUTU1", "checks", :result => :neutral)
    @parser.parse("TUTU1 - Checks")
  end
  it "should properly parse and register a call" do
    @stats.should_receive(:register_action).with("CKDPLAYER", "calls", :result => :pay, :amount => "0.50".to_d)
    @parser.parse("CKDPLAYER - Calls $0.50")
  end
  it "should properly parse and register a bet" do
    @stats.should_receive(:register_action).with("MAKEYAHUMP", "bets", :result => :pay, :amount => "1.25".to_d)
    @parser.parse("MAKEYAHUMP - Bets $1.25")
  end
  it "should properly parse and register a raise" do
    @stats.should_receive(:register_action).with("POKR_WIZ", "raises", :result => :pay_to, :amount => "3.50".to_d)
    @parser.parse("POKR_WIZ - Raises $3 to $3.50")
  end
  it "should properly parse and register a return" do
    @stats.should_receive(:register_action).with("MAKEYAHUMP", "return", :result => :win, :amount => "1.50".to_d)
    @parser.parse("MAKEYAHUMP - returned ($1.50) : not called")
  end
  it "should properly parse and register a collection" do
    @stats.should_receive(:register_action).with("MAKEYAHUMP", "wins", :result => :win, :amount => "1.00".to_d)
    @parser.parse("MAKEYAHUMP Collects $1 from main pot")
  end
end