require 'net/http'

class SinaVideo
  class Parser
    API_URL = 'http://v.iask.com/v_play.php?vid='

    def initialize(video)
      @video = video
    end

    def get_xml
      @xml ||= Nokogiri::XML get_response.body
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

  class SinaVideoFile
    attr_reader :url, :seconds

    def initialize(url, seconds)
      @url = url
      @seconds = seconds
    end
  end

  attr_reader :parser

  def initialize(url)
    @url = url # like http://video.sina.com.cn/v/b/96748194-1418521581.html
    @parser = Parser.new self
  end

  # 96748194
  def video_id
    @video_id ||= begin
      @url.split('/').last.split('-').first
    end
  end

  def video_files
    xml = @parser.get_xml

    files = []
    xml.css('durl').each do |durl|
      seconds = durl.css('length').text.to_i / 1000.0
      url = durl.css('url').text
      vf = SinaVideoFile.new url, seconds
      files << vf
    end

    return files
  end
end