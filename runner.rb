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
    Dir.glob("#{image_base_dir}/*.*").map{|f| f.split('/').last}.map{|f| {"link"=>"/#{@@env.imageStorage}/#{f}","filename"=>f}}.to_json
  end

  post '/' do
    filename, success = save params['qqfile']
    "{success:#{success}, error:'', link:'/#{@@env.imageStorage}/#{filename}'}"
  end

  delete '/remove' do
    require 'ruby-debug/debugger'
    filename = params['filename']
    FileUtils.rm("#{image_base_dir}/#{filename}")
    redirect '/'
  end

private

  def image_base_dir
    @image_base_dir ||= "./public/#{@@env.imageStorage}"
  end
  def save(data)
    if data[:tempfile]
      return saveForm data
    else
      return saveRaw data
    end
  end
  def saveRaw(data)
    filename = data
    raw = request.env["rack.input"].read
    valid, errors = validate raw.size, filename, nil
    if valid
      File.open("#{image_base_dir}/#{filename}", "w") do |f| 
        f.puts raw
      end
    end
    return filename, valid
  end
  def saveForm(data)
    tempfile = data[:tempfile]
    filename = data[:filename]
    valid, errors = validate tempfile.size, filename, data[:type]
    if valid
      FileUtils.cp(tempfile.path, "#{image_base_dir}/#{filename}")
    end
    return filename, valid
  end
  def validate(size, filename, mime)
    errors={}
    valid = true

    if size/1024/1024 >= @@env.imageMaxSize
      valid = false
      errors[:size] = "file to big"
    end
    if mime
      unless mime =~ /image.*/
        valid = false
        errors[:mime] = "wrong mime type"
      end
    end
    unless filename =~ /(jpeg|jpg|png)/
      valid = false
      errors[:extention] = "extention not allowed"
    end

    return valid, errors
  end
end
