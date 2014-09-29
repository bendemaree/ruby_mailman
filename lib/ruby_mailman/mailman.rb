module RubyMailman
  class Mailman
    def self.deliver(action, obj, cs = CentralServiceInterface)
      self.new(action, obj, cs).deliver
    end

    def self.create(obj, cs = CentralServiceInterface)
      self.deliver(:create, obj, cs)
    end

    def self.update(obj, cs = CentralServiceInterface)
      self.deliver(:update, obj, cs)
    end

    def self.destroy(obj, cs = CentralServiceInterface)
      self.deliver(:destroy, obj, cs)
    end

    def initialize(action, object, central_service)
      self.action = action
      self.object = object
      self.central_service = central_service
    end

    def deliver
      Response.build(central_service.deliver(action.to_s, object))
    end

    private

    attr_accessor :action, :object, :central_service
  end
end
