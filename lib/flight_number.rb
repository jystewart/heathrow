require 'datamapper'

class FlightNumber
  include DataMapper::Resource

  # property :id,         Integer, :serial => true
  property :number,     String, :unique => true, :key => true
  property :origin,     String
  property :destination, String
  
  has n, :flights, :child_key => [:number]
  belongs_to :origin_airport, :class_name => 'Airport', :child_key => [:origin]
  belongs_to :destination_airport, :class_name => 'Airport', :child_key => [:destination]
  
  before :save, :update_from_google
  after :save, :update_airports
    
  def update_from_google(force = false)
    if new_record? or force
      data = GoogleFlight.get(self.number)
      if data
        self.origin = data.origin
        self.destination = data.destination
      end
    end
  end
  
  def update_airports
    Airport.first_or_create(:code => self.origin) if self.origin
    Airport.first_or_create(:code => self.destination) if self.destination
  end
end