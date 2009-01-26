require 'datamapper'

class Flight
  include DataMapper::Resource
 
  property :id,         Integer, :serial => true
  property :number, String
  property :identifier, String
  property :terminal, Integer
  property :due_at, Time
  property :status_time, Time
  property :status_name, String
  property :type, String

  property :created_at, DateTime
end