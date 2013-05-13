require "net/http"

class FayeClient
  include Celluloid
  attr_reader :channel, :params

  def self.publish(channel, params)
    self.provision.future.publish(channel, params)
  end

  def self.publish_queue(channel, params)
    self.provision.publish(channel, params)
  end

  def self.provision
    Celluloid::Actor[:faye_pool] ||= self.pool(:size => 16)
  end

  def publish(channel, params)
    message = {:channel => channel, :data => params}.to_json
    Net::HTTP.post_form(uri, :message => message)
  end

  def uri
    URI.parse("http://127.0.0.1:8080/faye")
  end
end
