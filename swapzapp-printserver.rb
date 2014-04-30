require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default)

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :completed, type: Boolean
  field :template,  type: String
  field :printer,   type: String


end

configure do
  set :root,    File.dirname(__FILE__)
  
  Mongoid.load!(File.dirname(__FILE__) + '/mongoid.yml')
end

def self.printing
    exec("echo #{self.template} > ./public/template.txt")
    exec("lpr -P #{self.printer} -o raw ./public/template.txt")
end


before '*' do
  content_type :json
end

# Index available printers
get '/jobs/?' do
  puts Job.all.to_json
end

# Find and print
get '/jobs/:id/?' do
  begin
    Job.find(params[:id]).to_json
    Job.printing
  rescue
    status 404
  end
end

# Create and print
post '/jobs/?' do
  Job.create(JSON.parse(request.body.read))
  Job.printing
  status 201
end


not_found do
  status 404
  ""
end