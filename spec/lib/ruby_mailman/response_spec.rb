require 'spec_helper'
require_relative "../../../lib/ruby_mailman"

Response = RubyMailman::Response
SuccessResponse = RubyMailman::SuccessResponse
RetryResponse = RubyMailman::RetryResponse
FailResponse = RubyMailman::FailResponse

describe Response do
  describe "build" do
    it "creates and returns a SuccessResponse if the raw_response is '200'" do
      x = Object.new
      expect(SuccessResponse).to receive(:new).with('200') { x }
      expect(Response.build('200')).to eq(x)
    end

    it "returns a SuccessResponse if the raw_response is '409'" do
      x = Object.new
      expect(RetryResponse).to receive(:new).with('409') { x }
      expect(Response.build('409')).to eq(x)
    end

    it "returns a FailResponse if the raw_response is '500'" do
      x = Object.new
      expect(FailResponse).to receive(:new).with('500') { x }
      expect(Response.build('500')).to eq(x)
    end

    it "returns a undecorated response with any other raw_response" do
      x = Object.new
      raw_response = rand(100).to_s
      expect(Response).to receive(:new).with(raw_response) { x }
      expect(Response.build(raw_response)).to eq(x)
    end

    it "has a body equal to the raw_response" do
      ['200', '409', '500', rand(100).to_s].each do |code|
        expect(Response.build(code).body).to eq(code)
      end
    end
  end

  describe "success?" do
    it "is false" do
      expect(Response.new('').success?).to be_falsey
    end
  end

  describe "retry?" do
    it "is false" do
      expect(Response.new('').retry?).to be_falsey
    end
  end

  describe "fail?" do
    it "is false" do
      expect(Response.new('').fail?).to be_falsey
    end
  end

  describe SuccessResponse do
    describe "success?" do
      it "is false" do
        expect(SuccessResponse.new('').success?).to be_truthy
      end
    end

    describe "retry?" do
      it "is false" do
        expect(SuccessResponse.new('').retry?).to be_falsey
      end
    end

    describe "fail?" do
      it "is false" do
        expect(SuccessResponse.new('').fail?).to be_falsey
      end
    end
  end

  describe FailResponse do
    describe "success?" do
      it "is false" do
        expect(FailResponse.new('').success?).to be_falsey
      end
    end

    describe "retry?" do
      it "is false" do
        expect(FailResponse.new('').retry?).to be_falsey
      end
    end

    describe "fail?" do
      it "is false" do
        expect(FailResponse.new('').fail?).to be_truthy
      end
    end
  end

  describe RetryResponse do
    describe "success?" do
      it "is false" do
        expect(RetryResponse.new('').success?).to be_falsey
      end
    end

    describe "retry?" do
      it "is false" do
        expect(RetryResponse.new('').retry?).to be_truthy
      end
    end

    describe "fail?" do
      it "is false" do
        expect(RetryResponse.new('').fail?).to be_falsey
      end
    end
  end
end
