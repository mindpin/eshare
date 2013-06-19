require 'net/http'

class YoukuVideo
  class Parser
    API_URL = 'http://v.youku.com/player/getPlaylist/VideoIDS/'

    def initialize(video)
      @video = video
    end

    def get_json
      @json ||= JSON::parse(get_response.body)
    end

    def get_response
      begin
        uri = URI.parse _request_url
        site = Net::HTTP.new(uri.host, uri.port)
        site.open_timeout = 20
        site.read_timeout = 20
        path = uri.query.nil? ? uri.path : "#{uri.path}?#{uri.query}"
        response = site.get2(path)
      rescue Exception => ex
        p ex
      end
    end

    private
      def _request_url
        "#{API_URL}#{@video.video_id}"
      end
  end

  class YoukuVideoFile
    attr_reader :url, :seconds, :size

    def initialize(url, seconds, size)
      @url = url
      @seconds = seconds
      @size = size
    end

    def self.get_mix_string(seed)
      mixed  = ''
      source = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\:._-1234567890'

      source.length.times do 
        seed = (seed * 211 + 30031) % 65536
        index = (seed.to_f / 65536 * source.length)
        c = source[index]
        mixed = mixed + c
        source.sub! c, ''
      end

      return mixed
    end

    def self.get_file_id(streamfileid, seed)
      mixed = get_mix_string(seed)
      ids = streamfileid.split('*')

      real_id = ''
      ids.each do |x|
        real_id = real_id + mixed[x.to_i]
      end

      return real_id
    end
  end

  attr_reader :parser

  def initialize(url)
    @url = url # like http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html
    @parser = Parser.new self
  end

  def video_id
    @video_id ||= begin
      @url.split('id_').last.split('.').first
    end
  end

  def video_cover_url
    @video_cover_url ||= begin
      @parser.get_json['data'][0]['logo']
    rescue Exception => e
      ''
    end
  end

  def video_title
    @video_title ||= begin
      @parser.get_json['data'][0]['title']
    rescue Exception => e
      ''
    end
  end

  def video_files
    json = @parser.get_json

    seed         = json['data'][0]['seed']
    streamfileid = json['data'][0]['streamfileids']['flv']
    segs         = json['data'][0]['segs']['flv']

    fid0 = YoukuVideoFile.get_file_id(streamfileid, seed)
    fid1 = fid0[0...8]
    fid2 = fid0[10..-1]

    i = 0
    files = []
    segs.map do |x|
      aa = i.to_s(16).upcase
      aa = ('0' + aa)[-2..-1]
      fid = fid1 + aa + fid2
      k1 = x['k']
      k2 = x['k2']
      size = x['size']
      seconds = x['seconds']

      vf = YoukuVideoFile.new "http://f.youku.com/player/getFlvPath/sid/00_00/st/flv/fileid/#{fid}?K=#{k1}", seconds, size
      files << vf
      i = i + 1
    end

    return files
  end
end