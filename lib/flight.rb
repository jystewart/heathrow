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
  property :origin, String

  property :created_at, DateTime
  
  # Scopes for common queries
  
  def self.departures
    all(:type => 'departure')
  end
  
  def self.arrivals
    all(:type => 'arrival')
  end
  
  def self.departed
    departures.all(:status_name => 'Airborne')
  end
  
  def self.arrived
    arrivals.all(:status_name => 'Landed')
  end
  
  def self.in_past_hour
    all(:status_time.gte => Time.now - 3600)
  end
  
  def self.since(time)
    all(:status_time.gte => time)
  end
end