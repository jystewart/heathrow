require 'open-uri'
require 'hpricot'
require 'yaml'

class WikipediaAirport
  attr_accessor :longitude, :latitude, :name
  cattr_accessor :url_mapping

  class << self
    def mapping
      self.url_mapping ||= YAML.load_file(File.join(HEATHROW_ROOT, 'data/airports_wikipedia.yml'))['mapping']
    end
          
    def uri(airport_code)
      if mapping[airport_code]
        "http://en.wikipedia.org/wiki/#{mapping[airport_code]}"
      else
        "http://en.wikipedia.org/wiki/#{airport_code}"
      end
    end
  
    def get(airport_code)
      doc = Hpricot(open(uri(airport_code)))

      geo = doc.search("span.geo")
      if geo and geo.any?
        airport = new
        coordinates = geo.last.inner_text.split(";")
        airport.latitude = coordinates[0]
        airport.longitude = coordinates[1]
        airport.name = doc.search('h1').inner_text
        return airport
      end
    end
  end
end