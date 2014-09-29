require "spec_helper"
require_relative "../../../lib/ruby_mailman"
require_relative "../../zmq_servers/reply"
require_relative "../../zmq_servers/publish"

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
        reply: -> {"reply #{reply_randomizer}"},
        publish_delay: 0.03
      }
      @pid = TestServer::Reply.run_as_process(@server_configuration)
      @test_delay = @server_configuration[:publish_delay] * 2
      #wait so the publisher process can get rolling
      sleep(@test_delay)
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

RSpec.describe ZMQSubscriptionClient do
  describe "run" do
    let (:message_builder) { class_double(RubyMailman::Subscription::Message) }
    let (:message) { instance_double(RubyMailman::Subscription::Message) }

    before(:example) do
      @server_configuration = {
        channel: "mychannel",
        port: 6666,
        message_parts: ["published message", rand(20).to_s],
        publish_delay: 0.03
      }
      @pid = TestServer::Publish.run_as_process(@server_configuration)
      @test_delay = @server_configuration[:publish_delay] * 2
      #wait so the publisher process can get rolling
      sleep(@test_delay)
    end

    it "Creates a Message and then calls the listener" do
      listener = lambda{|channel, message| rand}
      expect(message_builder).to receive(:new).at_least(:once).with(@server_configuration[:channel],@server_configuration[:message_parts]) { message }
      expect(listener).to receive(:call).at_least(:once).with(@server_configuration[:channel], message)
      ZMQSubscriptionClient.run(@server_configuration[:channel], listener, message_builder)
      sleep(@test_delay)
    end

    after(:example) do
      Process.kill("KILL", @pid)
    end
  end
end
