require 'spec_helper'
require_relative "../../../lib/ruby_mailman"

describe CentralServiceInterface do
  let (:client_double) { double(ZMQClient) }

  describe 'self.send' do
    before do
      @action = "action#{rand}"
      @object = Object.new
    end

    it "uses the provided client to make a request" do
      expect(client_double).to receive(:request).with(@action,@object)
      CentralServiceInterface.send(@action,@object,client_double)
    end
  end
end
