require 'datamapper'

class FlightNumber
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :number,     String, :unique => true
  property :origin,     String
  property :destination, String
end