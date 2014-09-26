require 'ffi-rzmq'

class ZMQConfiguration
  def self.server
    ENV['0MQServerAddress'] || "tcp://localhost:6666"
  end
end

class ZMQRequestClient
  def self.run(action, object)
    context = ZMQ::Context.new
    connection = context.socket(ZMQ::REQ)
    connection.connect(ZMQConfiguration.server)
    connection.send_strings([action.to_s, object.to_s])
    receiver = ""
    connection.recv_string(receiver)
    receiver
  end
end

class ZMQSubscriptionClient
  def self.run(channel, listener)
    context = ZMQ::Context.new
    connection = context.socket(ZMQ::SUB)
    connection.connect(ZMQConfiguration.server)
    connection.setsockopt(ZMQ::SUBSCRIBE, channel)

    Thread.new do
      loop do
        received_channel = ''
        connection.recv_string(received_channel)
        message = []
        connection.recv_strings(message)
        listener.call(received_channel, RubyMailman::Subscription::Message.new(received_channel, message))
      end
    end
  end
end

class ZMQClient
  attr_reader :connection

  def self.request(action, object)
    ZMQRequestClient.run(action, object)
  end

  def self.subscribe(channel, listener)
    ZMQSubscriptionClient.run(channel, listener)
  end
end
