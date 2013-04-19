require 'net/http'
require 'json'

class YoukuVideoParser
  API_URL = 'http://v.youku.com/player/getPlaylist/VideoIDS/'

  def initialize(video_id)
    @video_id = video_id
  end

  def get_cover_url
    get_json['data'][0]['logo']
  rescue
    ''
  end

  def get_json
    response = get_response(_request_url)
    return JSON::parse(response.body)
  end

  def get_response(url)
    begin
      uri = URI.parse url
      site = Net::HTTP.new(uri.host, uri.port)
      site.open_timeout = 20
      site.read_timeout = 20
      path = uri.query.nil? ? uri.path : "#{uri.path}?#{uri.query}"
      response = site.get2(path)
    rescue Exception => ex
      p ex
    end
  end

  def _request_url
    "#{API_URL}#{@video_id}"
  end
end