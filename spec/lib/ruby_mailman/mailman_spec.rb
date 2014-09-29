require 'spec_helper'
require_relative "../../../lib/ruby_mailman"

Mailman = RubyMailman::Mailman

describe Mailman do
  let (:cs_interface_double) { double(CentralServiceInterface) }
  let (:object_double) { Object.new }

  before do
    allow(RubyMailman::Response).to receive(:build) { Object.new }
  end

  describe "notifies of creation" do
    it "has the CentralServiceInterface do the work" do
      expect(cs_interface_double).to receive(:deliver).with("create", object_double)
      Mailman.deliver(:create, object_double, cs_interface_double)
    end

    it "supports the .deliver syntax" do
      expect(cs_interface_double).to receive(:deliver).with("create", object_double)
      Mailman.deliver(:create, object_double, cs_interface_double)
    end

    it "works with the .create syntax" do
      expect(cs_interface_double).to receive(:deliver).with("create", object_double)
      Mailman.create(object_double, cs_interface_double)
    end
  end

  describe "notifies of update" do
    it "has the CentralServiceInterface do the work" do
      expect(cs_interface_double).to receive(:deliver).with("update", object_double)
      Mailman.deliver(:update, object_double, cs_interface_double)
    end

    it "supports the .deliver syntax" do
      expect(cs_interface_double).to receive(:deliver).with("update", object_double)
      Mailman.deliver(:update, object_double, cs_interface_double)
    end

    it "works with the .update syntax" do
      expect(cs_interface_double).to receive(:deliver).with("update", object_double)
      Mailman.update(object_double, cs_interface_double)
    end
  end

  describe "notifies of destruction" do
    it "has the CentralServiceInterface do the work" do
      expect(cs_interface_double).to receive(:deliver).with("destroy", object_double)
      Mailman.deliver(:destroy, object_double, cs_interface_double)
    end

    it "supports the .deliver syntax" do
      expect(cs_interface_double).to receive(:deliver).with("destroy", object_double)
      Mailman.deliver(:destroy, object_double, cs_interface_double)
    end

    it "works with the .destroy syntax" do
      expect(cs_interface_double).to receive(:deliver).with("destroy", object_double)
      Mailman.destroy(object_double, cs_interface_double)
    end
  end
end
