module TudouListImporter
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def parse_tudou_list(url)
      get_videos get_lid(url).each do ||
        
      end
    end

    def get_lid(url)
      open(url).read.match(/var\slid\s=\s'(\d*)';/)[1]
    end

    def get_videos(lid)
      JSON.parse(open(play_list_url lid).read)["message"]["items"]
    end

    def get_playlist_desc()
      Nokogiri::HTML(open(video_desc_url lcode)).css('h1#plCaption')[0].content
    end

    def get_video_desc(lcode)
      JSON.parse(open(video_desc_url lcode).read)["message"]["description"]
    end

    def video_desc_url(lcode)
      "http://www.tudou.com/playlist/service/getItemDetail.html?code=#{lcode}"
    end

    def play_list_url(lid)
      "http://www.tudou.com/plcover/coverPage/getIndexItems.html?lid=#{lid}"
    end
  end
end
