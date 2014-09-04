module RubyMailman
  class Mailman
    def self.send(action, obj, cs = CentralServiceInterface)
      self.new(action, obj, cs).send
    end

    def self.create(obj, cs=CentralServiceInterface)
      self.send(:create, obj, cs)
    end

    def self.update(obj, cs=CentralServiceInterface)
      self.send(:update, obj, cs)
    end

    def self.destroy(obj, cs=CentralServiceInterface)
      self.send(:destroy, obj, cs)
    end

    def self.subscribe(args)
      channel = args.fetch(:channel) do
        raise ArgumentError, "Subscribtion requries a channel"
      end

      callback = args.fetch(:callback) do
        raise ArgumentError, "Subscribtion requries a callback"
      end

      RubyMailman::Subscription.build(channel, callback, args[:options])
    end

    def initialize(action, object, central_service)
      self.action = action
      self.object = object
      self.central_service = central_service
    end

    def send
      Response.build(central_service.send(action, object))
    end

    private

    attr_accessor :action, :object, :central_service
  end
end
