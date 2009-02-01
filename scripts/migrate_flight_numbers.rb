#!/usr/bin/ruby

require 'rubygems'
require File.dirname(__FILE__) + '/lib/flight.rb'
require File.dirname(__FILE__) + '/lib/flight_number.rb'

DataMapper.setup(:default, "sqlite3:///Users/james/Desktop/flights.db")
FlightNumber.auto_migrate!

codes = repository(:default).adapter.query('SELECT DISTINCT number FROM flights')
codes.each do |code| 
  puts "#{code}"
  fn = FlightNumber.new(:number => code)
  fn.save
end