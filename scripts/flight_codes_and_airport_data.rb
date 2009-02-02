#!/usr/bin/ruby
require 'rubygems'
root_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require root_path + "/lib/airport.rb"
require root_path + "/lib/flight_number.rb"

DataMapper.setup(:default, "sqlite3://#{root_path}/flights.db")

require 'open-uri'
require 'hpricot'

FlightNumber.all(:conditions => ['origin IS NULL']).each do |fn|
  doc = Hpricot(open("http://www.google.com/search?q=#{fn.number}"))
  codes = doc.search('ol li:first a').inner_text.match(/\((.+?)\) to .+? \((.+?)\)/)
  if codes
    fn.origin = codes[1]
    fn.destination = codes[2]
    fn.save
  end
end

origins = repository(:default).adapter.query('SELECT DISTINCT origin FROM flight_numbers')
destinations = repository(:default).adapter.query('SELECT DISTINCT destination FROM flight_numbers')

(origins + destinations).uniq.each do |code|
  Airport.first(:code => code) || Airport.create(:code => code)
end

wikipedia = YAML.load_file(File.join(File.dirname(__FILE__), '../data/airports_wikipedia.yml'))

Airport.all(:conditions => ['latitude IS NULL']).each do |airport|
  if wikipedia['mapping'][airport.code]
    doc = Hpricot(open("http://en.wikipedia.org/wiki/#{wikipedia['mapping'][airport.code]}"))
  else
    doc = Hpricot(open("http://en.wikipedia.org/wiki/#{airport.code}"))
  end
  
  geo = doc.search("span.geo")
  if geo and geo.any?
    coordinates = geo.last.inner_text.split(";")
    airport.latitude = coordinates[0]
    airport.longitude = coordinates[1]
    airport.name = doc.search('h1').inner_text
    airport.save
  else
    puts "no geo data found for #{airport.code}"
  end
end