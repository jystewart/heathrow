#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../init.rb'

def update_flight_data(type)
  Heathrow::Scraper.fetch_array(type).each do |flight_data|
    flight = Flight.first(:identifier => flight_data.identifier) || Flight.new

    %W(identifier number terminal due_at status_name status_time type origin).each do |attr|
      flight.send("#{attr}=", flight_data.send(attr))
    end

    flight.save
  end
  
end

update_flight_data('arrival')
update_flight_data('departure')
