require 'spec_helper'
require 'securerandom'
require 'protobuf'

require_relative '../models/auth.pb'
require_relative '../../lib/ruby_mailman'
require_relative "../zmq_servers/publish"

class MyListener
  attr_reader :channel, :message
  def call(channel, message)
    @channel = channel
    @message = message
  end
end

RSpec.describe "Subscribing to channels" do
  let(:listener) { MyListener.new }

  before(:example) do
    @message_action = ['create','update','destroy'].sample
    auth = Interfaces::Auth.new
    auth.email = rand.to_s
    auth.public_key = SecureRandom.uuid
    auth.private_key = SecureRandom.uuid
    @message_content = auth.encode

    @server_configuration = {
      channel: "mychannel",
      port: 6666,
      message_parts: [@message_action, @message_content],
      publish_delay: 0.05
    }
    @pid = TestServer::Publish.run_as_process(@server_configuration)
    @test_delay = @server_configuration[:publish_delay] * 2

    #wait so the publisher process can get rolling
    sleep(@test_delay)
  end

  after(:example) do
    Process.kill("KILL", @pid)
  end

  it "returns a RubyMailman::Subscription instance when subscribing" do
    subscription_return = RubyMailman::Subscription.subscribe(channel: @server_configuration[:channel], listener: listener)
    expect(subscription_return).to be_a(RubyMailman::Subscription)
  end

  it "calls the listener when a new message is published" do
    expect(listener).to receive(:call).at_least(:once)
    RubyMailman::Subscription.subscribe(channel: @server_configuration[:channel], listener: listener)
    sleep(@test_delay)
  end

  it "calls the listener with the channel name and a RubyMailman::Subscription::Message instance" do
    RubyMailman::Subscription.subscribe(channel: @server_configuration[:channel], listener: listener)
    sleep(@test_delay)

    expect(listener.channel).to eq(@server_configuration[:channel])
    expect(listener.message).to be_a(RubyMailman::Subscription::Message)
  end

  it "The message instance has the channel, action and content we expect" do
    RubyMailman::Subscription.subscribe(channel: @server_configuration[:channel], listener: listener)
    sleep(@test_delay)

    expect(listener.message.channel).to eq(@server_configuration[:channel])
    expect(listener.message.action).to eq(@message_action)
    expect(listener.message.content).to eq(@message_content)
  end
end
