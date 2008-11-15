class Player < ActiveRecord::Base
  has_many :stats
  has_many :sessions, :through => :stats
  has_many :hands, :through => :stats
  
  named_scope :needs_update, :conditions => ['updated_from_internet_at IS NULL']
  
  def self.update_all_from_poker_edge
    time_begun = Time.now
    players = needs_update
    number_of_players = players.count
    players.each_with_index do |player, index|
      logger.warn "judistats/update_from_poker_edge: updated_at: #{Time.now}; '#{player.screen_name}' (#{index} of #{number_of_players})"
      player.update_from_poker_edge
    end
    time_completed = Time.now
    logger.warn "judistats/update_all_from_poker_edge: completed_at: #{time_completed}; elapsed: #{time_completed - time_begun}"
  end
  
  def uri_escaped_screen_name
    URI.escape(screen_name)
  end
  
  def shell_and_uri_escaped_screen_name
    uri_escaped_screen_name.gsub(/["']/,'\\\\\&')
  end
  
  def update_from_poker_edge
    result = `curl -s http://www.poker-edge.com/whoami.php?name=#{shell_and_uri_escaped_screen_name}`
    if result =~ /(Pre-Flop Tend.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /Pre-Flop Tendency: ([^-]*) -/
        preflop = $1
      else
        preflop = "N/A"
      end
    else
      logger.warn "judistats/update_from_poker_edge: internet data not available for #{screen_name}"
      logger.warn "attempted 'curl -s http://www.poker-edge.com/whoami.php?name=#{shell_and_uri_escaped_screen_name}'"
      raise "internet data unavailable for #{screen_name}"
    end
    if result =~ /(Player Type.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /[Yy]ou are a ([^(]* \(.*\))/
        player_type = $1
      else
        player_type = ""
      end
    else
      logger.warn "judistats/update_from_poker_edge: internet data not available for #{screen_name}"
      raise "internet data unavailable for #{screen_name}"
    end
    self.rating = preflop
    self.rating += " " + player_type unless player_type.empty?
    adjust_icon_from_rating player_type
    self.updated_from_internet_at = Time.now
    save
  end
  
  def adjust_icon_from_rating player_type
    self.icon = case player_type
    when /Bomb/
      "bomb.png"
    when /Calling/
      "calling.png"
    when /Green/
      "greenfish.png"
    when /Mouse/
      "mouse.png"
    when /Red/
      "redfish.png"
    when /Rock/
      "rock.png"
    when /Shark/
      "shark.png"
    when /MANIAC/
      "taz.png"
    when /Caution/
      "warning.png"
    else
      nil
    end
  end
end