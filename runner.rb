require './env'
require 'sinatra/base'
require "sinatra/reloader" unless ENV['RACK_ENV'].to_sym == :production
require 'json'

require './lib/helper'

class Service < Sinatra::Base
  configure do |c|
    helpers Sinatra::MyHelper
    use Rack::MethodOverride

    set :public, File.dirname(__FILE__) + '/public'
    set :haml, :format => :html5

    layout :layout
  end
  configure :development do |c|
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.rb"
  end

  get '/' do
    haml :main
  end

  post '/filelist' do
    Dir.glob("#{image_base_dir}/*.*").map{|f| f.split('/').last}.map{|f| {"link"=>"/#{ENV['images-dir']}/#{f}","filename"=>f}}.to_json
  end

  post '/' do
    success = true
    data = params['qqfile']
    if data[:tempfile]
      #form-data
      tempfile = data[:tempfile]
      filename = data[:filename]
      FileUtils.cp(tempfile.path, "#{image_base_dir}/#{filename}")
    else
      #raw data
      filename = data
      raw = request.env["rack.input"].read
      File.open("#{image_base_dir}/#{filename}", "w") do |f| 
        f.puts raw
      end
    end
    "{success:#{success}, error:'', link:'/#{ENV['images-dir']}/#{filename}'}"
  end

  delete '/remove' do
    filename = params['filename']
    FileUtils.rm("#{image_base_dir}/#{filename}")
    redirect '/'
  end

  def image_base_dir
    @image_base_dir ||= "./public/#{ENV['images-dir']}"
  end
  run! if app_file == $0
end

