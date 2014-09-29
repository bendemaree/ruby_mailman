class CentralServiceInterface
  def self.deliver(action,object,cs_client = CSTransportClient)
    self.new(cs_client).deliver(action,object)
  end

  def self.subscribe(channel, listener, cs_client = CSTransportClient)
    self.new(cs_client).subscribe(channel, listener)
  end

  def initialize(cs_client)
    self.central_service_client = cs_client
  end

  def deliver(action,object)
    central_service_client.request(action,object)
  end

  def subscribe(channel, listener)
    central_service_client.subscribe(channel, listener)
  end

  private
  attr_accessor :central_service_client
end
