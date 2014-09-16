module RubyMailman
  class Subscription
    def self.subscribe(args, cs = CentralServiceInterface)
      channel = args.fetch(:channel) do
        raise ArgumentError, "Subscribtion requries a channel"
      end

      listener = args.fetch(:listener) do
        raise ArgumentError, "Subscribtion requries a listener"
      end

      self.new(channel, listener, cs).subscribe
    end

    def initialize(channel, listener, cs)
      self.channel = channel
      self.listener = listener
      self.central_service = cs
    end

    def subscribe
      central_service.subscribe(channel, listener)
    end

    private
    attr_accessor :channel, :listener, :central_service
  end
end
