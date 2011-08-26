require 'init'
require 'sinatra/base'
require 'json'
require 'haml'

require 'lib/upload'
require 'lib/helper'

class Service < Sinatra::Base
  configure do |c|
    helpers Sinatra::MyHelper
    use Rack::MethodOverride

    set :public, File.dirname(__FILE__) + '/public'
    set :haml, :format => :html5

    layout :layout
  end
  configure :development do |c|
    require "sinatra/reloader"
    register Sinatra::Reloader
    c.also_reload "./lib/**/*.rb"
    c.also_reload "./views/**/*.rb"
  end

  get '/' do
    haml :main
  end

  post '/filelist' do
    Upload.filelist.map{|f| {"link"=>"/#{$env.imageStorage}/#{f}","filename"=>f}}.to_json
  end

  post '/' do
    u = Upload.new
    u.data = param['qqfile']
    u.save
  end

  delete '/remove' do
    FileUtils.rm("#{Upload.base_dir}/#{params['filename']}")
    redirect '/'
  end
end
