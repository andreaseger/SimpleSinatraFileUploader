require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require(:development)

require './runner'
run Service
