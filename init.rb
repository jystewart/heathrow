#!/usr/bin/ruby

require 'rubygems'
require 'datamapper'

Dir.glob(File.join(File.dirname(__FILE__), 'lib/*.rb')).each { |f| require f  }
DataMapper.setup(:default, "sqlite3://#{File.dirname(__FILE__)}/flights.db")

HEATHROW_ROOT = File.dirname(__FILE__)