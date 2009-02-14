#!/usr/bin/ruby

if ARGV.size < 2
  puts "Usage: ./tweet.rb <username> <password>"
  exit(2)
end

require File.dirname(__FILE__) + '/../init.rb'

gem 'twitter'
require 'twitter'

# TODO: Make this logic a bit more fluent
# TODO: Detect whether periods of quiet are at night or during the day and comment on that
# TODO: "This has been a busy day" etc.
hourly_take_offs = Flight.departed.in_past_hour.count
hourly_arrivals = Flight.arrived.in_past_hour.count
two_hourly_take_offs = Flight.departed.since(Time.now - 7200).count
two_hourly_arrivals = Flight.arrived.since(Time.now - 7200).count
time_and_day = DateTime.now.strftime("%H:%M on %A")

# A few greetings stolen from http://www.elite.net/~runner/jennifers/hello.htm
# Just to provide some variety
greetings = ["G'day", 'Hello', 'Salut', 'guten tag',  'Shlama', 'Hej', 'Hoi', 'Torova', 'Haileo', 'Salaam', 'Ti nâu', 'Óla']
update = "#{greetings[rand(greetings.length)]}. It's #{time_and_day}"
send_update = false

if hourly_take_offs > 0 or hourly_arrivals > 0
  if hourly_take_offs == two_hourly_take_offs and hourly_arrivals == two_hourly_arrivals
    update += " and I'm waking up"
  end
  update += ". In the past hour I've watched #{hourly_take_offs} flights take off, and #{hourly_arrivals} planes have come to visit"
  send_update = true
elsif two_hourly_take_offs > 0 and two_hourly_arrivals > 0
  update += " and I'm getting some rest. No take offs or landings in the past hour"
  send_update = true
end

if send_update
  begin
    Twitter::Base.new(ARGV[0], ARGV[1]).update(update)
  rescue Twitter::CantConnect
    puts "Couldn't connect to twitter. Check username/password"
  end
end