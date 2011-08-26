require 'rubygems'
require 'bundler'

Bundler.require(ENV['RACK_ENV'].to_sym)

require './runner'
run Service
