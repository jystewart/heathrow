#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../init.rb'

codes = repository(:default).adapter.query('SELECT DISTINCT number FROM flights')
codes.each do |code| 
  puts "#{code}"
  fn = FlightNumber.new(:number => code)
  fn.save
end