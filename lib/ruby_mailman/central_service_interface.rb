class CentralServiceInterface
  def self.send(action,object,cs_client = ZMQClient)
    self.new(cs_client).send(action,object)
  end

  def initialize(cs_client)
    self.central_service_client = cs_client
  end

  def send(action,object)
    central_service_client.request(action,object)
  end

  private
  attr_accessor :central_service_client
end

class ZMQClient
  def self.request(action,object)
  end
end
