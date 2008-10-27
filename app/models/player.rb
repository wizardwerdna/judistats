class Player < ActiveRecord::Base
  has_many :stats
  has_many :sessions, :through => :stats
  has_many :hands, :through => :stats
  
  named_scope :needs_update, :conditions => ['updated_from_internet_at IS NULL']
  
  def self.update_all_from_poker_edge
    needs_update.each do |player|
      player.update_from_poker_edge
    end
  end
  
  def update_from_poker_edge
    # puts "=" * 90
    # puts "Reading Poker-Edge Data for '#{screen_name}'... "
    # puts "-" * 90
    result = `curl -s http://www.poker-edge.com/whoami.php?name='#{screen_name.gsub(/ /, "%20")}'`
    puts "Results for #{screen_name}:"
    if result =~ /(Pre-Flop Tend.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /Pre-Flop Tendency: ([^-]*) -/
        preflop = $1
      else
        preflop = "N/A"
      end
      puts verbose
    else
      raise "internet data unavailable for #{player}"
      # puts "could not get data for this player"
      # puts "=" * 90
      # next
    end
    if result =~ /(Player Type.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /[Yy]ou are a ([^(]* \(.*\))/
        player_type = $1
      else
        player_type = ""
      end
      puts verbose
    else
      raise "internet data unavailable for #{player}"
      # puts "could not get type data for this player"
      # puts "=" * 90
      # next
    end
    # puts "=" * 90
    self.rating = preflop
    self.rating += " " + player_type unless player_type.empty?
    adjust_icon_from_rating player_type
    self.updated_from_internet_at = Time.now
puts self.inspect
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