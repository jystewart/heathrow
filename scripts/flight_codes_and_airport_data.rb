#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../init.rb'

FlightNumber.all(:conditions => ['origin IS NULL']).each do |fn|
  fn.update_from_google(true)
end

origins = repository(:default).adapter.query('SELECT DISTINCT origin FROM flight_numbers')
destinations = repository(:default).adapter.query('SELECT DISTINCT destination FROM flight_numbers')

(origins + destinations).uniq.each do |code|
  Airport.first_or_create(:code => code)
end

Airport.all(:conditions => ['latitude IS NULL']).each do |airport|
  airport.update_from_wikipedia(true)
end