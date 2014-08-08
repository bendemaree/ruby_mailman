require 'spec_helper'

require 'rubygems'
require 'ffi-rzmq'
require_relative 'zmq_server'
require_relative '../../lib/ruby_mailman'


class Key
end


RSpec.describe "Making requests" do
  before :each do
    @context = create_context
    @rep_sock = @context.socket(ZMQ::REP)
    @rc = @rep_sock.bind('tcp://127.0.0.1:2200')
  end

  after :each do
    @context.terminate
    @server.kill
  end

  let(:key) { Key.new }

  it "returns non nil when using the .send method" do
    @server = run_reply_server(@context, @rep_sock, @rc)
    expect(RubyMailman::Mailman.send(:create, key)).not_to be_nil
    expect(RubyMailman::Mailman.send(:update, key)).not_to be_nil
    expect(RubyMailman::Mailman.send(:destroy, key)).not_to be_nil
  end

  it "returns non nil when using the named method" do
    @server = run_reply_server(@context, @rep_sock, @rc)
    expect(RubyMailman::Mailman.create(key)).not_to be_nil
    expect(RubyMailman::Mailman.update(key)).not_to be_nil
    expect(RubyMailman::Mailman.destroy(key)).not_to be_nil
  end

  it "returns a successful response if provided a action and object" do
    @server = run_reply_server(@context, @rep_sock, @rc, 'always_succeed')
    expect(RubyMailman::Mailman.send(:create, key).success?).to be_truthy
    expect(RubyMailman::Mailman.send(:create, key).retry?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).fail?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).body).to eq("200")
  end

  it "returns a fail response if it receives" do
    @server = run_reply_server(@context, @rep_sock, @rc, 'always_fail')
    expect(RubyMailman::Mailman.send(:create, key).success?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).retry?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).fail?).to be_truthy
    expect(RubyMailman::Mailman.send(:create, key).body).to eq("500")
  end

  it "returns a retry response if it receives" do
    @server = run_reply_server(@context, @rep_sock, @rc, 'always_retry')
    expect(RubyMailman::Mailman.send(:create, key).success?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).retry?).to be_truthy
    expect(RubyMailman::Mailman.send(:create, key).fail?).to be_falsey
    expect(RubyMailman::Mailman.send(:create, key).body).to eq("409")
  end
end
