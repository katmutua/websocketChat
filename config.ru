require 'rubygems'
require 'bundler'
Bundler.setup(:default, :example)
require 'json'
require 'cramp'
require 'http_router'

Cramp::Websocket.backend = :thin