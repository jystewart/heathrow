#!/usr/bin/ruby

if ARGV.size < 2
  puts "Usage: ./tweet.rb <username> <password>"
  exit(2)
end

this_path = File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require "#{this_path}/lib/flight.rb"
DataMapper.setup(:default, "sqlite3://#{this_path}/flights.db")

gem 'twitter'
require 'twitter'

hourly_take_offs = Flight.departed.in_past_hour.count
hourly_arrivals = Flight.arrived.in_past_hour.count
two_hourly_take_offs = Flight.departed.since(Time.now - 7200).count
two_hourly_arrivals = Flight.arrived.since(Time.now - 7200).count
time_and_day = DateTime.now.strftime("%H:%M on %A")
update = "Hello. It's #{time_and_day}"
  
if hourly_take_offs > 0 or hourly_arrivals > 0
  if hourly_take_offs == two_hourly_take_offs and hourly_arrivals == two_hourly_arrivals
    update += " and I'm waking up"
  end
  update += ". In the past hour I've watched #{hourly_take_offs} flights take off, and #{hourly_arrivals} planes have come to visit"
elsif two_hourly_take_offs > 0 and two_hourly_arrivals > 0
  update += " and I'm getting some rest. No take offs or landings in the past hour"
end

begin
  Twitter::Base.new(ARGV[0], ARGV[1]).update(update)
rescue Twitter::CantConnect
  puts "Couldn't connect to twitter. Check username/password"
end
