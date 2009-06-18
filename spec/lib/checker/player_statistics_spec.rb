require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/hand_constants')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/checker/player_statistics')

TEST = [
  {"andy" => {
      :is_blind_attack_opportunity => false, 
      :is_blind_attack_opportunity_taken => nil, 
      :is_blind_defense_opportunity => false, 
      :is_blind_defense_opportunity_taken => nil,
      :is_cbet_opportunity => true, 
      :is_cbet_opportunity_taken => true,
      :posted => 1, 
      :paid => 2, 
      :won => 3, 
      :cards => nil,
      :preflop_passive => 1, 
      :preflop_aggressive => 2, 
      :postflop_passive => 3, 
      :postflop_aggressive => 4, 
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => true
    },
  "judi" => {
      :is_blind_attack_opportunity => true, 
      :is_blind_attack_opportunity_taken => false, 
      :is_blind_defense_opportunity => true, 
      :is_blind_defense_opportunity_taken => true,
      :is_cbet_opportunity => true, 
      :is_cbet_opportunity_taken => false,
      :posted => 10, 
      :paid => 20, 
      :won => 30, 
      :cards => nil,
      :preflop_passive => 10, 
      :preflop_aggressive => 20, 
      :postflop_passive => 30, 
      :postflop_aggressive => 40,
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => false
    }
  },
  {"andy" => {
      :is_blind_attack_opportunity => false, 
      :is_blind_attack_opportunity_taken => nil, 
      :is_blind_defense_opportunity => false, 
      :is_blind_defense_opportunity_taken => nil,
      :is_cbet_opportunity => true, 
      :is_cbet_opportunity_taken => false,
      :posted => 2, 
      :paid => 4, 
      :won => 6, 
      :cards => nil,
      :preflop_passive => 2, 
      :preflop_aggressive => 4, 
      :postflop_passive => 6, 
      :postflop_aggressive => 8,
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => true
    },
  "judi" => {
      :is_blind_attack_opportunity => true, 
      :is_blind_attack_opportunity_taken => false, 
      :is_blind_defense_opportunity => true, 
      :is_blind_defense_opportunity_taken => true,
      :is_cbet_opportunity => false, 
      :is_cbet_opportunity_taken => nil,
      :posted => 20, 
      :paid => 30, 
      :won => 40, 
      :cards => nil,
      :preflop_passive => 20, 
      :preflop_aggressive => 40, 
      :postflop_passive => 60, 
      :postflop_aggressive => 80,
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => false
    }
  },
  {"andy" => {
      :is_blind_attack_opportunity => false, 
      :is_blind_attack_opportunity_taken => nil, 
      :is_blind_defense_opportunity => true, 
      :is_blind_defense_opportunity_taken => false,
      :is_cbet_opportunity => false, 
      :is_cbet_opportunity_taken => nil,
      :posted => 3, 
      :paid => 6, 
      :won => 9, 
      :cards => nil,
      :preflop_passive => 3, 
      :preflop_aggressive => 6, 
      :postflop_passive => 9, 
      :postflop_aggressive => 12,
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => true
    },    
  "judi" => {
      :is_blind_attack_opportunity => true, 
      :is_blind_attack_opportunity_taken => true, 
      :is_blind_defense_opportunity => true, 
      :is_blind_defense_opportunity_taken => true,
      :is_cbet_opportunity => false, 
      :is_cbet_opportunity_taken => nil,
      :posted => 30, 
      :paid => 0, 
      :won => 0, 
      :cards => nil,
      :preflop_passive => 30, 
      :preflop_aggressive => 60, 
      :postflop_passive => 90, 
      :postflop_aggressive => 120,
      :is_pfr_opportunity => true, 
      :is_pfr_opportunity_taken => false
    }
  }
]

PS_RESULT = {
  "andy" => {
    :t_hands => 3,
    :t_vpip => 3,
    :t_posted => 6, 
    :t_paid => 12,
    :t_won => 18,
    :t_blind_attack_opportunity => 0, 
    :t_blind_attack_opportunity_taken => 0, 
    :t_blind_defense_opportunity => 1, 
    :t_blind_defense_opportunity_taken => 0,
    :t_cbet_opportunity => 2, 
    :t_cbet_opportunity_taken => 1,
    :t_preflop_passive => 6, 
    :t_preflop_aggressive => 12, 
    :t_postflop_passive => 18, 
    :t_postflop_aggressive => 24,
    :t_pfr_opportunity => 3, 
    :t_pfr_opportunity_taken => 3
  },
  "judi" => {
    :t_hands => 3,
    :t_vpip => 2,
    :t_posted => 60, 
    :t_paid => 50,
    :t_won => 70,
    :t_blind_attack_opportunity => 3, 
    :t_blind_attack_opportunity_taken => 1, 
    :t_blind_defense_opportunity => 3, 
    :t_blind_defense_opportunity_taken => 3,
    :t_cbet_opportunity => 1, 
    :t_cbet_opportunity_taken => 0,
    :t_preflop_passive => 60, 
    :t_preflop_aggressive => 120, 
    :t_postflop_passive => 180, 
    :t_postflop_aggressive => 240,
    :t_pfr_opportunity => 3, 
    :t_pfr_opportunity_taken => 0
  }
}

class AggregateTo
  def initialize(player, stat, expected)
    @player = player
    @stat = stat
    @expected = expected
  end

  def matches?(hash)
    @actual = hash[@player][@stat]
    # Satisfy expectation here. Return false or raise an error if it's not met.
    return @actual == @expected
  end

  def failure_message
    "expected report[#{@player.inspect}][#{@stat.inspect}] to aggregate to #{@expected.inspect}, got #{@actual.inspect}"
  end

  def negative_failure_message
    "expected report[#{@player.inspect}][#{@stat.inspect}] not to aggregate to #{@expected.inspect}, but it did"
  end
end

def should_correctly_aggregate(reports, stats = [])
  reports.keys.each do |each_player|
    stats.each do |each_stat|
      reports.should AggregateTo.new(each_player, each_stat, PS_RESULT[each_player][each_stat])
    end 
  end
end

describe PlayerStatistics, "when aggregating statistics" do
  before do
    @player_statistics = PlayerStatistics.new
    for each_test in TEST
      @hand_statistics = HandStatistics.new
      @hand_statistics.should_receive(:reports).and_return(each_test)
      @player_statistics.record(@hand_statistics)
    end
    @reports = @player_statistics.reports
  end
  
  it "should produce a report with data for each player in the reports" do
    players = {}
    for each_hand in TEST
      for each_player in each_hand.keys
        players[each_player] = true
      end
    end
    @reports.should have(players.size).keys
  end
  
  it "should correctly aggregate aggression for each player" do
    should_correctly_aggregate @reports, [:t_preflop_passive, :t_preflop_aggressive, :t_postflop_passive, :t_postflop_aggressive]
  end
  
  it 'should correctly aggregate blind attack statistics' do
    should_correctly_aggregate @reports, [:t_blind_attack_opportunity, :t_blind_attack_opportunity_taken, :t_blind_defense_opportunity, :t_blind_defense_opportunity_taken]
  end
  it 'should correctly aggregate cash statistics' do
    should_correctly_aggregate @reports, [:t_hands, :t_vpip, :t_posted, :t_paid, :t_won]
  end
  it 'should correctly aggregate continuation bet statistics' do
    should_correctly_aggregate @reports, [:t_cbet_opportunity, :t_cbet_opportunity_taken]
  end
  it 'should correctly aggregate preflop raise statistics' do
    should_correctly_aggregate @reports, [:t_pfr_opportunity, :t_pfr_opportunity_taken]
  end
end