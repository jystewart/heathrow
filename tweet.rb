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

update = "Hello. It's #{DateTime.now.strftime("%H:%M on %A")}. In the past hour I've watched #{Flight.departed.in_past_hour.count} flights take off, and #{Flight.arrived.in_past_hour.count} planes have come to visit"

begin
  Twitter::Base.new(ARGV[0], ARGV[1]).update(update)
rescue Twitter::CantConnect
  puts "Couldn't connect to twitter. Check username/password"
end
