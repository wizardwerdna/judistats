class Stat < ActiveRecord::Base
  belongs_to  :player
  belongs_to  :session
  belongs_to  :hand
  
  named_scope :general, :select => 'COUNT(*) AS number_hands, SUM(vpip) as vpip, SUM(pfrp) as pfrp, ' +
    'SUM(preflop_aggressive) as preflop_aggressive, SUM(preflop_passive) as preflop_passive, ' +
    'SUM(postflop_aggressive) as postflop_aggressive, SUM(postflop_passive) as postflop_passive'
    
  named_scope :for_player_screen_name, lambda{|player_screen_name| {:conditions => {:player_id => Player.find_by_screen_name(player_screen_name)}}}
  
  named_scope :cards_class_stats, :select => 'cards_class, sum(net_in_bb) as avg_net', :group => 'cards_class'
  
  def self.update_from_sessions
    Session.unparsed.each do |session|
      session.stats.each do |stat|
        result = find_or_create_by_player_id_and_hand(stat.player.id, stat.hand)
        result.update(stat)
      end
    end
  end
end
