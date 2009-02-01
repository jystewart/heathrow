require 'datamapper'

class Airport
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :code,       String, :unique => true
  property :alias,      String
  property :name,       String
  property :longitude,  Float
  property :latitude,   Float
end