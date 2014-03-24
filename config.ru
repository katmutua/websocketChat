require 'rubygems'
require 'bundler'
Bundler.setup(:default, :example)
require 'json'
require 'cramp'
require 'http_router'

Cramp::Websocket.backend = :thin

module Chat
  class HomeAction < Cramp::Action
    self.transport = :chunked
    template_path = File.expand_path( 'views/index.html')
    @@template = File.read(template_path)

    def start
      render @@template
      finish
    end
  end
end