class Stat < ActiveRecord::Base
  belongs_to  :player
  belongs_to  :session
  belongs_to  :hand
  
  named_scope :general, :select => 'COUNT(*) AS number_hands, SUM(vpip) as vpip, SUM(pfrp) as pfrp, ' +
    'SUM(preflop_aggressive) as preflop_aggressive, SUM(preflop_passive) as preflop_passive, ' +
    'SUM(postflop_aggressive) as postflop_aggressive, SUM(postflop_passive) as postflop_passive'
  
  def self.update_from_sessions
    Session.unparsed.each do |session|
      session.stats.each do |stat|
        result = find_or_create_by_player_id_and_hand(stat.player.id, stat.hand)
        result.update(stat)
      end
    end
  end
end
