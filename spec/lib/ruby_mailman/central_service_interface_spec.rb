require "spec_helper"
require_relative "../../../lib/ruby_mailman"

RSpec.describe CentralServiceInterface do
  let (:client_class_double) { class_double(ZMQClient) }
  let (:client_double) { double(ZMQClient) }

  describe "self.send" do
    before do
      @action = "action#{rand}"
      @object = Object.new
    end

    it "uses the provided client to make a request" do
      expect(client_class_double).to receive(:new) { client_double }
      expect(client_double).to receive(:request).with(@action, @object) { true }
      CentralServiceInterface.send(@action,@object,client_class_double)
    end
  end

  describe "self.subscribe" do
    before do
      @channel = "channel#{rand}"
      @listener = Object.new
    end

    it "uses the provided client to subscribe" do
      expect(client_class_double).to receive(:new) { client_double }
      expect(client_double).to receive(:subscribe).with(@channel, @listener) { true }
      CentralServiceInterface.subscribe(@channel, @listener, client_class_double)
    end
  end
end

RSpec.describe ZMQClient do
  describe "new" do
    it 'uses the default configuration' do
      expect(ZMQClientConfiguration).to receive(:default) { Object.new }
      ZMQClient.new
    end
  end

  describe "request" do
    before do
      @action = "action#{rand}"
      @object = Object.new
      @configuration = ZMQClientConfiguration.default
      @connection_double = double(ZMQConnection)
      allow(@connection_double).to receive(:send_strings) { true }
      allow(@configuration.response).to receive(:recv_string) { "" }
      allow(@configuration.connection).to receive(:connect) { @connection_double }
    end

    it "establishes a connection for a request" do
      expect(@configuration.connection).to receive(:connect).with(:request) { @connection_double }
      ZMQClient.new(@configuration).request(@action, @object)
    end

    it "uses the provided request to send the action and object" do
      expect(@configuration.request).to receive(:send_strings).with(@connection_double, [@action.to_s, @object.to_s] ) { true }
      ZMQClient.new(@configuration).request(@action, @object)
    end

    it "returns what the response gets" do
      executed_request = Object.new
      allow(@configuration.request).to receive(:send_strings).with(@connection_double, [@action.to_s, @object.to_s] ) { executed_request }
      expect(@configuration.response).to receive(:recv_string).with(@connection_double) { "" }
      ZMQClient.new(@configuration).request(@action, @object)
    end
  end
end

RSpec.describe ZMQConnection do
  describe "self.build" do
    it "creates a new instance" do
      expect(ZMQConnection).to receive(:new) { Object.new }
      ZMQConnection.build
    end
  end

  describe "connect" do
    let(:context_double) { double(ZMQ::Context) }
    let(:connection_double) { Object.new }

    before do
      allow(ZMQ::Context).to receive(:new) { context_double }
      allow(context_double).to receive(:socket) { connection_double }
      allow(connection_double).to receive(:connect) { true }
    end

    it "gets a ZMQ context" do
      expect(ZMQ::Context).to receive(:new) { context_double }
      ZMQConnection.new.connect
    end

    it "establishes a socket" do
      expect(context_double).to receive(:socket).with(ZMQ::REQ) { connection_double }
      ZMQConnection.new.connect
    end

    it "connects to the socket" do
      expect(connection_double).to receive(:connect) { true }
      ZMQConnection.new.connect
    end
  end
end

RSpec.describe ZMQRequest do
  describe "self.build" do
    it "creates a new instance" do
      expect(ZMQRequest).to receive(:new) { Object.new }
      ZMQRequest.build
    end
  end

  describe "send_strings" do
    let (:strings) { Array.new }
    let (:flags) { rand }

    it "returns the connection's send_strings return value" do
      rand_return = rand
      connection_double = Object.new
      expect(connection_double).to receive(:send_strings).with(strings, flags) { rand_return }
      it = ZMQRequest.new.send_strings(connection_double, strings, flags)
      expect(it).to eq(rand_return)
    end
  end
end

RSpec.describe ZMQResponse do
  describe "self.build" do
    it "creates a new instance" do
      expect(ZMQResponse).to receive(:new) { Object.new }
      ZMQResponse.build
    end
  end

  describe "recv_string" do
    let (:receiver) { "" }

    it "uses the connection's recv_string and returns the provided receiver" do
      connection_double = Object.new
      expect(connection_double).to receive(:recv_string).with(receiver) { true }
      it = ZMQResponse.new.recv_string(connection_double, receiver)
      expect(it).to eq(receiver)
    end
  end
end
