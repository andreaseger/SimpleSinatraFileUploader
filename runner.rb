require './env'
require 'sinatra/base'
require "sinatra/reloader" unless ENV['RACK_ENV'].to_sym == :production

require './lib/helper'

class Service < Sinatra::Base
  configure do |c|
    helpers Sinatra::MyHelper

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
    @list = Dir.glob("#{image_base_dir}/*.*").map{|f| f.split('/').last}
    haml :main
  end

  post '/' do
    data = params['qqfile']
    if data[:tempfile]
      #form-data
      tempfile = data[:tempfile]
      filename = data[:filename]
      FileUtils.cp(tempfile.path, "#{image_base_dir}/#{filename}")
    else
      filename = data
      raw = request.env["rack.input"].read
      File.open("#{image_base_dir}/#{filename}", "w") do |f| 
        f.puts raw
      end
    end
    "{success:true, error:'', filename:'#{filename}', link:'#{image_base_dir}/#{filename}'}"
  end
  get '/remove/:filename' do |filename|
    FileUtils.rm("#{image_base_dir}/#{filename}")
    redirect '/'
  end

  def image_base_dir
    @image_base_dir ||= "./public/#{ENV['images-dir']}"
  end
  run! if app_file == $0
end

