require 'rubygems'
require 'bundler'

ENV['RACK_ENV'] ||= 'development'

Bundler.require(:default)

class Job
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,      type: String
  field :to,        type: String
  field :from,      type: String
  field :date,      type: String
  field :completed, type: Boolean


end

configure do
  set :root,    File.dirname(__FILE__)
  
  Mongoid.load!(File.dirname(__FILE__) + '/mongoid.yml')
end


before '*' do
  content_type :json
end

# Index
get '/jobs/?' do
  Job.all.to_json
end

# Find
get '/jobs/:id/?' do
  begin
    Job.find(params[:id]).to_json
  rescue
    status 404
  end
end

# Create
post '/jobs/?' do
  Job.create(JSON.parse(request.body.read))
  status 201
end

# Update
put '/jobs/:id/?' do
  begin
    Job.find(params[:id]).update_attributes(JSON.parse(request.body.read))
  rescue
    status 404
  end
end

# Destroy
delete '/jobs/:id' do
  begin
    Job.find(params[:id]).destroy
  rescue
    status 404
  end
end

not_found do
  status 404
  ""
end