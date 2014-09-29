require "spec_helper"
require_relative "../../../lib/ruby_mailman"

RSpec.describe CentralServiceInterface do
  let (:client_class_double) { class_double(ZMQClient) }

  describe "self.deliver" do
    before do
      @action = "action#{rand}"
      @object = Object.new
    end

    it "uses the provided client to make a request" do
      expect(client_class_double).to receive(:request).with(@action, @object) { true }
      CentralServiceInterface.deliver(@action,@object,client_class_double)
    end
  end

  describe "self.subscribe" do
    before do
      @channel = "channel#{rand}"
      @listener = Object.new
    end

    it "uses the provided client to subscribe" do
      expect(client_class_double).to receive(:subscribe).with(@channel, @listener) { true }
      CentralServiceInterface.subscribe(@channel, @listener, client_class_double)
    end
  end
end
