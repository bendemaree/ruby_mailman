module RubyMailman
  class Subscription
    class Message
      attr_reader :channel, :action, :content
      def initialize(channel, raw_message)
        self.channel = channel
        self.action = raw_message[0]
        self.content = raw_message[1]
      end

      private
      attr_writer :channel, :action, :content
    end
  end
end
