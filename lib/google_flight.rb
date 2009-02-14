require 'open-uri'
require 'hpricot'

class GoogleFlight
  attr_accessor :origin, :destination
  
  def self.get(flight_number)
    doc = Hpricot(open("http://www.google.com/search?q=#{fn.number}"))
    codes = doc.search('ol li:first a').inner_text.match(/\((.+?)\) to .+? \((.+?)\)/)
    if codes and codes.length >= 3
      result = new
      result.origin = codes[1]
      result.destination = codes[2]
    end
  end
end