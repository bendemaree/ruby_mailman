require 'spec_helper'

require 'rubygems'
require 'ffi-rzmq'
require_relative 'zmq_server'
require_relative '../../lib/ruby_mailman'

run_reply_server

class Key
end

RSpec.describe "Making requests" do
  let(:key) { Key.new }

  it "returns non nil when using the .send method" do
    expect(RubyMailman::Mailman.send(:create, key)).not_to be_nil
    expect(RubyMailman::Mailman.send(:update, key)).not_to be_nil
    expect(RubyMailman::Mailman.send(:destroy, key)).not_to be_nil
  end

  it "returns non nil when using the named method" do
    expect(RubyMailman::Mailman.create(key)).not_to be_nil
    expect(RubyMailman::Mailman.update(key)).not_to be_nil
    expect(RubyMailman::Mailman.destroy(key)).not_to be_nil
  end
end
