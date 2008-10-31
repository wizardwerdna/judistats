#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end
ActiveRecord::Base.logger.warn "DAEMON [RE]STARTED at #{Time.now}.\n"

while($running) do
  Session.update_from_filesystem
  Session.update_stats_for_unparsed_sessions_from_filesystem
  Player.update_all_from_poker_edge
  sleep 15
end