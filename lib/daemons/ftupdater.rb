#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  ActiveRecord::Base.logger.info "FT UPdater is still running at #{Time.now}.\n"
  f = Ftfile.new(:filename => "#{Time.now}", :content => "this is a try")
  ActiveRecord::Base.logger.info "ERROR1" if f.nil?
  Activps eRecord::Base.logger.info "ERROR2" unless f.save
  sleep 10
end