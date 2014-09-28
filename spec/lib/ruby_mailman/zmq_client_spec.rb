require "spec_helper"
require_relative "../../../lib/ruby_mailman"
require_relative "../../zmq_servers/reply"

RSpec.describe ZMQClient do
  describe "request" do
    let (:request_client) { class_double(ZMQRequestClient) }
    let (:action) { "action#{rand}" }
    let (:object) { Object.new }

    it "uses the provided client to make a request" do
      expect(request_client).to receive(:run).with(action, object) { true }
      ZMQClient.request(action, object, request_client)
    end
  end

  describe "subscribe" do
    let (:subscription_client) { class_double(ZMQSubscriptionClient) }
    let (:channel) { "channel#{rand}" }
    let (:listener) { Object.new }

    it "uses the provided client to make a request" do
      expect(subscription_client).to receive(:run).with(channel, listener) { true }
      ZMQClient.subscribe(channel, listener, subscription_client)
    end
  end
end

RSpec.describe ZMQRequestClient do
  describe "run" do
    before(:example) do
      reply_randomizer = rand
      @server_configuration = {
        port: 6666,
        reply: -> {"reply #{reply_randomizer}"}
      }
      @pid = TestServer::Reply.run_as_process(@server_configuration)
    end

    it "returns a reply" do
      action = 'action'
      object = 'object'
      reply = ZMQRequestClient.run(action,object)
      expect(reply).to eq(@server_configuration[:reply].call)
    end

    after(:example) do
      Process.kill("KILL", @pid)
    end
  end
end

