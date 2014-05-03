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


  # Print method
  def printing
    t = Tempfile.new(template)
    begin
      t.write(self.template.to_s)
      t.rewind
      system("lpr -P #{self.printer.to_s} -o raw #{t.read}")
    ensure
      t.close
      t.unlink
    end
  end

end

configure do
  set :root,    File.dirname(__FILE__)
  
  Mongoid.load!(File.dirname(__FILE__) + '/mongoid.yml')
end

before '*' do
  content_type :json
end

# Index jobs
get '/jobs/?' do
  Job.all.to_json
end

# Index printers
get '/printers/?' do
  data = `lpstat -a`
  @lines = data.split("\n")
  @printer_names = @lines.collect { |x| x.split(" ")[0] }
  @printer_names.to_json
end

# Find and print
get '/jobs/:id/?' do
  begin
    @job = Job.find(params[:id])
    @job.printing
    @job.to_json
  rescue
    status 500
  end
end

# Create and print
post '/jobs/?' do
  @job = Job.create(JSON.parse(request.body.read))
  @job.printing
  status 201
end

not_found do
  status 404
  ""
end