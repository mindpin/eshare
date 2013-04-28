class ReceivedMediaResourcesInfo
  attr_reader :sharer, :receiver

  def initialize(receiver, sharer)
    @receiver = receiver
    @sharer   = sharer
  end

  def media_resources
    @media_resources ||= receiver.received_media_resources_from_sharer(sharer)
  end
end
