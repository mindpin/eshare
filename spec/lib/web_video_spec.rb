require 'spec_helper'

describe YoukuVideo do
  before {
    @youku_video = YoukuVideo.new 'http://v.youku.com/v_show/id_XNTQ0MDM5NTY4.html'
  }

  it { @youku_video.video_id.should == 'XNTQ0MDM5NTY4' }
  it { 
    p url = @youku_video.video_cover_url
    url.should be_present
  }

  describe YoukuVideo::Parser do
    it {
      p json = @youku_video.parser.get_json
      json.should be_present
    }
  end
end

describe SinaVideo do
  before {
    @sina_video = SinaVideo.new 'http://video.sina.com.cn/v/b/96748194-1418521581.html'
  }

  it { @sina_video.video_id.should == '96748194' }

  it {
    p files = @sina_video.video_files
    files.count.should > 0 
  }

  describe SinaVideo::Parser do
    it {
      p xml = @sina_video.parser.get_xml
      xml.should be_present
    }
  end
end