require 'rubygems'
require 'rspec'
require 'mocha'

RSpec.configure do |config|
  config.mock_with :mocha
  #config.before(:each) do
  #  $db.select 12
  #  $db.flushdb
  #end
end
