#!/usr/bin/ruby

require 'rubygems'
require 'datamapper'

HEATHROW_ROOT = File.expand_path(File.dirname(__FILE__))

Dir.glob(File.join(HEATHROW_ROOT, 'lib/*.rb')).each { |f| require f  }
DataMapper.setup(:default, "sqlite3://#{HEATHROW_ROOT}/flights.db")
