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
    tempfile = params['file'][:tempfile]
    filename = params['file'][:filename]
    FileUtils.cp(tempfile.path, "#{image_base_dir}/#{filename}")
    redirect '/'
  end
  get '/remove/:filename' do |filename|
    FileUtils.rm("#{image_base_dir}/#{filename}")
    redirect '/'
  end

  def image_base_dir
    @image_base_dir ||= "./public/#{ENV['image-dir']}"
  end
  run! if app_file == $0
end

