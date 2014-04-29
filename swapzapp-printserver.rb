require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default)

class Swatch
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :printjob,  type: Text
  field :printername, type: String
end

configure do
  set :root,    File.dirname(__FILE__)
  
  Mongoid.load!(File.dirname(__FILE__) + '/mongoid.yml')
end