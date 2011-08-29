require './env'
require './lib/helper'
require 'json'

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

  get '/gallery' do
    haml :gallery
  end
  post '/gallery-data' do
    filelist.map{|f| {"image" => "/#{$env.imageStorage}/#{f}", "title" => f }}.to_json
  end

  post '/filelist' do
    filelist.map{|f| {"link"=>"/#{$env.imageStorage}/#{f}","filename"=>f}}.to_json
  end

  post '/' do
    binding.pry
    filename, success, errors = save params['qqfile']
    "{success:#{success}, errors:#{errors}, link:'/#{$env.imageStorage}/#{filename}'}"
  end

  delete '/remove' do
    require 'ruby-debug/debugger'
    filename = params['filename']
    FileUtils.rm("#{image_base_dir}/#{filename}")
    redirect '/'
  end

private

  def image_base_dir
    @image_base_dir ||= "./public/#{$env.imageStorage}"
  end
  def filelist
    Dir.glob("#{image_base_dir}/*.*").map{|f| f.split('/').last}
  end
  def save(data)
    if data[:tempfile]
      tempfile = data[:tempfile]
      filename = data[:filename]
    else
      raw = request.env["rack.input"].read
      tempfile saveAsTmpFile(raw)
      filename = data
    end
    #valid, errors = validate tempfile.size, data[:type]
    #filename, write = getFilename(filename, tempfile)
    #errors[:not_new] = "the same file already existed" unless write
    FileUtils.cp(tempfile.path, "#{image_base_dir}/#{filename}")# if valid && write
    return filename, true, ""#, valid, errors
  end
  def getFilename(org, tempfile)
    unless filelist.include? org
      return org, true
    end
    if FileUtils.compare_stream("#{image_base_dir}/#{org}", tempfile.path)
      return org, false
    else
      i=(org =~ /\.(png|jpg)$/)
      return "#{org[0..i-1]}_#{Time.now.to_i}#{org[i..org.size]}",true
    end
  end
  def saveAsTmpFile(raw)
    name = "#{Time.now.to_i}_#{raw.hash}"
    File.open("./tmp/#{name}", "w") do |f| 
      f.puts raw
    end
    name
  end
  def validate(size, filename, mime)
    errors={}
    valid = true

    if size >= $env.imageMaxSize
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
