require "spec_helper"
require_relative "../../../lib/ruby_mailman"

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
