require "ruby_mailman/version"
require "ruby_mailman/central_service_interface"

module RubyMailman
  class Mailman
    def self.send(action, obj, cs = CentralServiceInterface)
      self.new(action, obj, cs).send
    end

    def self.create(obj, cs)
      self.send(:create, obj, cs)
    end

    def self.update(obj, cs)
      self.send(:update, obj, cs)
    end

    def self.destroy(obj, cs)
      self.send(:destroy, obj, cs)
    end

    def initialize(action, object, central_service)
      self.action = action
      self.object = object
      self.central_service = central_service
    end

    def send
      central_service.send(action, object)
    end

    private

    attr_accessor :action, :object, :central_service
  end
end
