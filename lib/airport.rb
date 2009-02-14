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
  
  def update_from_wikipedia(force = false)
    if new_record? or force
      data = WikipediaAirport.get(airport.code)
      if data
        airport.latitude = data.latitude
        airport.longitude = data.longitude
        airport.name = data.name
        airport.save
      end
    end
  end
end