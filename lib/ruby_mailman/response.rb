module RubyMailman
  class Response
    attr_reader :body
    def self.build(raw_response)
      #Work with both a string "200" and an array ["200"]
      raw_response = Array(raw_response).join
      case raw_response
      when "200"
        SuccessResponse.new(raw_response)
      when "409"
        RetryResponse.new(raw_response)
      when "500"
        FailResponse.new(raw_response)
      else
        self.new(raw_response)
      end
    end

    def success?
      false
    end

    def retry?
      false
    end

    def fail?
      false
    end

    def initialize(body)
      self.body = body
    end

    private
    attr_writer :body
  end

  class SuccessResponse < Response
    def success?
      true
    end
  end

  class RetryResponse < Response
    def retry?
      true
    end
  end

  class FailResponse < Response
    def fail?
      true
    end
  end
end
