
require 'hpricot'
require 'net/http'

module Heathrow
  class Scraper
    @@hostname = 'www.heathrowairport.com'

    @@paths = {
      'arrival' => "/portal/controller/dispatcher.jsp?ChPath=Heathrow^General^Flight%20information^Live%20flight%20arrivals",
      'departure' => "/portal/page/Heathrow%5EGeneral%5EFlight+information%5ELive+flight+departures/"
    }
  
    class <<self
      def get_result(type)
        req = Net::HTTP::Get.new(@@paths[type])
        res = Net::HTTP.start(@@hostname) { |http| http.request(req) }
        return res
      end
  
      def fetch_array(type)
        res = get_result(type)
        doc = Hpricot(res.body)
        table = doc.search("table#timeTable")

        key = nil

        table.search("tbody tr").inject([]) do |results, table_row|
          if table_row.children[1].name == 'th'
            key = Date.parse(table_row.children[1].inner_text.strip)
          else
            details = table_row.search("td").collect { |td| td.inner_text.strip }
            details.unshift(key)
            details.unshift(type)
            results << Heathrow::Flight.new(details)
          end
          results
        end
      end
    end
  end
  
  class Flight
    @@terminals = {"Terminal five" => 5, "Terminal two" => 2, "Terminal one" => 1, "Terminal three" => 3, "Terminal four" => 4}
    
    attr_accessor :date
    attr_accessor :scheduled
    attr_accessor :number
    attr_accessor :origin
    attr_accessor :status
    attr_accessor :terminal_name
    attr_accessor :type
    
    attr_accessor :status_name
    attr_accessor :status_time
    
    def initialize(data)
      attributes = %W(type date scheduled number origin status terminal_name)
      attributes.each_with_index { |attr, index| self.send("#{attr}=", data[index]) }
    end
    
    # TODO : What if the scheduled time is tomorrow? Does that happen?
    def status=(status_string)
      return if status_string.nil? or status_string == ''
      
      status_name, status_time = status_string.split
      self.status_name = status_name.capitalize
      self.status_time = DateTime.parse("#{self.date} #{status_time[0,2]}:#{status_time[2,2]}:00")
    end
    
    def terminal
      @@terminals[self.terminal_name]
    end
    
    def due_at
      @due_at ||= DateTime.parse("#{self.date} #{self.scheduled}:00")
    end
    
    def identifier
      "#{self.date}-#{self.number}-#{self.type}"
    end

  end
end
