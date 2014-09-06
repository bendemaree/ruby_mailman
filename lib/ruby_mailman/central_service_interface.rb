require 'ffi-rzmq'
require 'delegate'

class CentralServiceInterface
  def self.send(action,object,cs_client = ZMQClient)
    self.new(cs_client).send(action,object)
  end

  def self.subscribe(channel, listener, options, cs_client = ZMQClient)
    self.new(cs_client).subscribe(channel, listener, options)
  end

  def initialize(cs_client)
    self.central_service_client = cs_client
  end

  def send(action,object)
    central_service_client.new.request(action,object)
  end

  def subscribe(channel, listener, options)
    central_service_client.new.subscribe(channel, listener, options)
  end

  private
  attr_accessor :central_service_client
end

class ZMQClient
  def initialize(configuration = ZMQClientConfiguration.default)
    self.configuration = configuration
  end

  def request(action, object)
    connect(:request)
    configuration.request.send_strings(connection, [action.to_s, object.to_s])
    configuration.response.recv_string(connection)
  end

  def subscribe(channel, listener, options)
  end

  private

  def connect(type)
    self.connection = configuration.connection.connect(type)
  end

  attr_accessor :connection, :configuration
end

class ZMQClientConfiguration
  attr_reader :connection, :request, :response

  def self.default
    self.build(ZMQConnection, ZMQRequest, ZMQResponse)
  end

  def self.build(connection_builder, request_builder, response_builder)
    self.new(connection_builder.build, request_builder.build, response_builder.build)
  end

  def initialize(connection, request, response)
    self.connection = connection
    self.request = request
    self.response = response
  end

  private
  attr_writer :connection, :request, :response
end

class ZMQConnection
  def self.build
    self.new
  end

  def initialize(server = String.new)
    self.context = ZMQ::Context.new
    self.server = server
  end

  def connect(type = :request)
    case type
    when :request
      connection = context.socket(ZMQ::REQ)
    end
    connection.connect('tcp://127.0.0.1:2200')
    connection
  end

  private

  attr_accessor :context, :connection, :server
end

class ZMQRequest
  def self.build
    self.new
  end

  def send_strings(connection, strings, flags = 0)
    connection.send_strings(strings, flags)
  end
end

class ZMQResponse
  def self.build
    self.new
  end

  def recv_string(connection,receiver = "")
    connection.recv_string(receiver)
    receiver
  end
end
