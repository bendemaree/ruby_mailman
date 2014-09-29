require 'spec_helper'

require 'rubygems'
require 'ffi-rzmq'
require 'protobuf'
require_relative 'zmq_server'
require_relative '../../lib/ruby_mailman'
require_relative '../models/auth.pb'
require_relative "../zmq_servers/reply"

RSpec.describe "Making requests" do

  let(:auth) { Interfaces::Auth.new }

  describe "main methods work" do
    before(:example) do
      @server_configuration = {
        port: 6666,
        reply: -> { "#{rand}" }
      }
      @pid = TestServer::Reply.run_as_process(@server_configuration)
    end

    after(:example) do
      Process.kill("KILL", @pid)
    end

    it "returns non nil when using the .deliver method" do
      expect(RubyMailman::Mailman.deliver(:create, auth.encode)).not_to be_nil
      expect(RubyMailman::Mailman.deliver(:update, auth.encode)).not_to be_nil
      expect(RubyMailman::Mailman.deliver(:destroy, auth.encode)).not_to be_nil
    end

    it "returns non nil when using the named method" do
      expect(RubyMailman::Mailman.create(auth.encode)).not_to be_nil
      expect(RubyMailman::Mailman.update(auth.encode)).not_to be_nil
      expect(RubyMailman::Mailman.destroy(auth.encode)).not_to be_nil
    end
  end

  describe "responses behave as expected" do
    describe "When the server repsonds with '200'" do
      before(:example) do
        @server_configuration = {
          port: 6666,
          reply: -> { "200" }
        }
        @pid = TestServer::Reply.run_as_process(@server_configuration)
      end

      after(:example) do
        Process.kill("KILL", @pid)
      end

      it "Requests get a sucessful response" do
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).success?).to be_truthy
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).retry?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).fail?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).body).to eq("200")
      end
    end

    describe "When the server repsonds with '409'" do
      before(:example) do
        @server_configuration = {
          port: 6666,
          reply: -> { "409" }
        }
        @pid = TestServer::Reply.run_as_process(@server_configuration)
      end

      after(:example) do
        Process.kill("KILL", @pid)
      end

      it "Requests get a retry response" do
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).success?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).retry?).to be_truthy
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).fail?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).body).to eq("409")
      end
    end

    describe "When the server repsonds with '500'" do
      before(:example) do
        @server_configuration = {
          port: 6666,
          reply: -> { "500" }
        }
        @pid = TestServer::Reply.run_as_process(@server_configuration)
      end

      after(:example) do
        Process.kill("KILL", @pid)
      end

      it "Requests get a failure response" do
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).success?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).retry?).to be_falsey
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).fail?).to be_truthy
        expect(RubyMailman::Mailman.deliver(:create, auth.encode).body).to eq("500")
      end
    end
  end
end
