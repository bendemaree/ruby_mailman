require 'ffi-rzmq'

module TestServer
  class Reply
    def self.run_as_process(configuration)
      port = configuration[:port] || '6666'
      reply = configuration[:reply]
      Kernel.fork do
        context = ZMQ::Context.new
        socket  = context.socket(ZMQ::REP)
        socket.bind("tcp://*:#{port}")
        loop do
          request = []
          socket.recv_strings(request)
          socket.send_string(reply.call)
        end
      end
    end
  end
end
