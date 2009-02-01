#!/usr/bin/ruby
require 'rubygems'
require File.dirname(__FILE__) + "/lib/airport.rb"
require File.dirname(__FILE__) + "/lib/flight_number.rb"
DataMapper.setup(:default, "sqlite3:///Users/james/Desktop/flights.db")

require 'open-uri'
require 'hpricot'

FlightNumber.all(:conditions => ['origin IS NULL']).each do |fn|
  begin
    doc = Hpricot(open("http://www.google.com/search?q=#{fn.number}"))
    codes = doc.search('ol li:first a').inner_text.match(/\((.+?)\) to .+? \((.+?)\)/)
    fn.origin = codes[1]
    fn.destination = codes[2]
    fn.save
  rescue => e
    puts "Problem parsing #{fn.number} : #{e.message}"
  end
end

origins = repository(:default).adapter.query('SELECT DISTINCT origin FROM flight_numbers')
destinations = repository(:default).adapter.query('SELECT DISTINCT destination FROM flight_numbers')

(origins + destinations).uniq.each do |code|
  Airport.first(:code => code) || Airport.create(:code => code)
end

wikipedia = Yaml.load_file(File.join(File.dirname(__FILE__), '../data/airports_wikipedia.yml'))

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