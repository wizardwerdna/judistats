# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def as_money(value, sb)
    return "***" if value.nil? || sb.nil?
    if sb < "1.0".to_d
      "$%-7.2f" % value
    else
      "$%-15.0f" % value
    end
  end
  
  def as_cards(string)
    string.split(' ').collect do |each|
      '<span style="color:' +
      case each.last
      when /[Hh]/
        "red"
      when /[Hh]/
        "red"
      when /[Hh]/
        "red"
      when /[Hh]/
        "red"
      else
        "black"
      end + '">' +
      each.first + 
      case each.last
      when /[Cc]/
        "&clubs"
      when /[Dd]/
        "&diams"
      when /[Hh]/
        "&hearts"
      when /[Ss]/
        "&spades"
      else
        each.last
      end +
      '</span>'
    end.join(' ')
  end
end
