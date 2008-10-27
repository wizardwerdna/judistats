require File.expand_path(File.dirname(__FILE__) + "../../../lib/checker/FTFile.rb")

class Summary < ActiveRecord::Base
  belongs_to :ftfile
  
  def self.update_recent_summaries
    players_shown = {}
    Ftfile.last5.each do |ftfile|
# puts ftfile.inspect
      first_summary = Summary.find(:first, :conditions => {:ftfile_id => ftfile.id})
      update_summary(ftfile, players_shown) unless first_summary && first_summary.updated_at > ftfile.mtime
    end
  end
  
  def self.display_player(playername, players_shown = {})
    return if players_shown[playername]
# puts "Reading Poker-Edge Data for '#{playername}'... "
    result = `curl -s http://www.poker-edge.com/whoami.php?name='#{playername.gsub(/ /, "%20")}'`
    if result =~ /(Pre-Flop Tend.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /Pre-Flop Tendency: ([^-]*) -/
        preflop = $1
      else
        preflop = "N/A"
      end
    else
      preflop = "ERR"
    end
    if result =~ /(Player Type.*\n)/
      verbose = $1.gsub(/<\/?[^>]*>/, "")
      if verbose =~ /[Yy]ou are a ([^(]* \(.*\))/
        player_type = $1
      else
        player_type = ""
      end
    else
      player_type = ""
    end
    players_shown[playername] = preflop
    players_shown[playername] += " " + player_type unless player_type.empty?
  end
  
  def self.update_summary(ftfile, players_shown = {})
    Summary.destroy_all :ftfile_id => ftfile
    this = nil
    hands = {}
    vpip = {}
    pfr = {}
    sawflop = {}
    preflop_aggressive = {}
    postflop_aggressive = {}
    preflop_passive = {}
    postflop_passive = {}
    last = nil
    FTFile.open(ftfile.path).each do |handrecord|
      # puts handrecord.lines
      last = handrecord
      next if handrecord.players.nil?
      handrecord.players.each do |player|
        hands[player] ||= 0
        hands[player]+=1
        vpip[player] ||= 0
        vpip[player]+=1 if handrecord.vpip? player
        pfr[player] ||= 0
        pfr[player]+=1 if handrecord.pfr? player
        sawflop[player] ||= 0
        sawflop[player]+=1 if handrecord.sawflop? player
        preflop_aggressive[player] ||= 0
        preflop_aggressive[player]+= handrecord.preflop_aggressive player
        preflop_passive[player] ||= 0
        preflop_passive[player]+= handrecord.preflop_passive player
        postflop_aggressive[player] ||= 0
        postflop_aggressive[player]+= handrecord.postflop_aggressive player
        postflop_passive[player] ||= 0
        postflop_passive[player]+= handrecord.postflop_passive  player
      end
    end
    return if last.nil?
    players = last.players
    return if players.nil?
    players.each {|each| display_player(each, players_shown)}
    players.each_with_index do |each, position|
      description = players_shown[each][/\(.*\)/]
      description ||= ""
      description.gsub!("Passive", "P")
      description.gsub!("Aggressive", "A")
      description.gsub!("Tight", "T")
      description.gsub!("Loose", "L")
      players_shown[each].gsub!(/\(.*\)/, description)
      Summary.create(
        :ftfile => ftfile, :position => position, :screen_name => each, :hands => hands[each],
        :vpip => (100.0 * vpip[each])/hands[each], :pfrp => (100.0 * pfr[each])/hands[each],
        :pre_agg => preflop_passive[each].zero? ? 0.0 : (1.0 * preflop_aggressive[each]) / preflop_passive[each],
        :post_agg => postflop_passive[each].zero? ? 0.0 : (1.0 * postflop_aggressive[each]) / postflop_passive[each],
        :poker_edge => players_shown[each]
      )
    end
    hands = vpip = pfr = sawflop = preflop_aggressive = preflop_passive = nil
    GC.start
  end
end