require 'spec_helper'
require_relative "../../../lib/ruby_mailman"

Subscription = RubyMailman::Subscription

describe Subscription do
  describe "subscribe" do
    let(:args) { {channel: 'test', listener: Object.new } }
    let(:cs_mock) { double(CentralServiceInterface) }

    before do
      allow(cs_mock).to receive(:subscribe) { true }
    end

    it "implements the method" do
      expect(Subscription.respond_to?(:subscribe)).to be_truthy
    end

    it "requires a channel" do
      args.delete(:channel)
      expect { Subscription.subscribe(args,cs_mock) }.to raise_error(ArgumentError)
    end

    it "requires a listener" do
      args.delete(:listener)
      expect { Subscription.subscribe(args,cs_mock) }.to raise_error(ArgumentError)
    end

    it "uses the Central Service Interfac subscription method" do
      expect(cs_mock).to receive(:subscribe).with(args[:channel], args[:listener])
      Subscription.subscribe(args, cs_mock)
    end
  end
end
