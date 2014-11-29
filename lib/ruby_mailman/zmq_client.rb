require 'ffi-rzmq'

class ZMQConfiguration
  def self.server
    ENV['ZEROMQ_SERVER_ADDRESS'] || "tcp://localhost:6666"
  end
end

class ZMQRequestClient
  def self.run(action, object)
    context = ZMQ::Context.new
    connection = context.socket(ZMQ::REQ)
    connection.connect(ZMQConfiguration.server)
    connection.send_strings([action, object])
    receiver = ""
    connection.recv_string(receiver)
    receiver
  end
end

class ZMQSubscriptionClient
  def self.run(channel, listener, message_builder = RubyMailman::Subscription::Message)
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
        listener.call(received_channel, message_builder.new(received_channel, message))
      end
    end
  end
end

class ZMQClient
  attr_reader :connection

  def self.request(action, object, concrete_client = ZMQRequestClient)
    concrete_client.run(action, object)
  end

  def self.subscribe(channel, listener, concrete_client = ZMQSubscriptionClient)
    concrete_client.run(channel, listener)
  end
end
