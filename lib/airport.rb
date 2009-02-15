class Airport
  include DataMapper::Resource

  # property :id,         Integer, :serial => true
  property :code,       String, :unique => true, :key => true
  property :alias,      String
  property :name,       String
  property :longitude,  Float
  property :latitude,   Float
  
  has n, :outgoing_routes, :class_name => 'FlightNumber', :child_key => [:origin]
  has n, :outgoing_flights, :class_name => 'Flight', :through => :outgoing_routes
  
  has n, :incoming_routes, :class_name => 'FlightNumber', :child_key => [:destination]
  has n, :incoming_flights, :class_name => 'Flight', :through => :incoming_routes
  
  before :save, :update_from_wikipedia
  
  def update_from_wikipedia(force = false)
    if new_record? or force
      data = WikipediaAirport.get(self.code)
      if data
        self.latitude = data.latitude
        self.longitude = data.longitude
        self.name = data.name
      end
    end
  end
end