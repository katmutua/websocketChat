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
    template_path = File.expand_path('views/index.html')
    @@template = File.read(template_path)

    def start
      render @@template
      finish
    end
  end

  class SocketAction < Cramp::Action
    self.transport = :websocket
    @@user_set = %w['pete', 'pan', 'piper']

    on_start :connected_users
    on_finish :user_left
    on_data :message_received

    def connected_users
      @@user_set
    end

    def user_left
      @@user_set.shift
    end

    def message_received(data)
    message = {}
    message['time'] = Time.now
    message['some_message'] = data
    @@user_set.each {|u| u.render message.to_json }
    end
  end
end

routes = HttpRouter.new do
  add('/').to(Chat::HomeAction)
  add('/socket').to(Chat::SocketAction)
end

run routes