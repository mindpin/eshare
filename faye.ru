require "faye"
Faye::WebSocket.load_adapter("thin")

app = Faye::RackAdapter.new(:mount => "/faye", :timeout => 25)

app.bind(:publish) do |client_id, channel, data|
  hash = {client_id: client_id, channel: channel, data: data}
  puts hash
end

run app
