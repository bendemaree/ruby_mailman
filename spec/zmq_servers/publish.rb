require 'ffi-rzmq'

module TestServer
  class Publish
    def self.run_as_process(configuration)
      Kernel.fork do

        port = configuration[:port] || 6666
        channel = configuration[:channel]
        message_parts = configuration[:message_parts]
        publish_delay = configuration[:publish_delay]

        context = ZMQ::Context.new
        publisher = context.socket(ZMQ::PUB)
        publisher.setsockopt(ZMQ::LINGER,1)
        publisher.bind("tcp://*:#{port}")

        loop do
          full_message = [message_parts[0].to_s, message_parts[1].to_s]
          publisher.send_string(channel, ZMQ::SNDMORE)
          publisher.send_strings(full_message)
          sleep(publish_delay)
        end
      end
    end
  end
end
