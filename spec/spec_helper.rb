require 'rubygems'
require 'rspec'
require 'mocha'
require 'sinatra/base'

require 'ostruct'
require 'fileutils'

RSpec.configure do |config|
  config.mock_with :mocha
#  config.before(:each) do
#    $db.flushdb
#  end
end
