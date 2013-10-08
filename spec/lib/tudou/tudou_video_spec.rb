require "spec_helper"

describe TudouVideo do
  before {
    @video1 = TudouVideo.new 'http://www.tudou.com/albumplay/4NP7mtf2VYg/yqM7MXyWjPc.html'
    @video2 = TudouVideo.new 'http://www.tudou.com/programs/view/c7Yv5D7kZew/'
    @video3 = TudouVideo.new 'http://www.tudou.com/listplay/y_WvP2J5LuM.html'
  }

  it '视频一应当能获得正确的iid' do
    p "视频一 iid: #{iid = @video1.iid}"
    iid.should_not be_blank
  end

  it '视频二应当能获得正确的iid' do
    p "视频二 iid: #{iid = @video2.iid}"
    iid.should_not be_blank
  end

  it '视频三应当能获得正确的iid' do
    p "视频三 iid: #{iid = @video3.iid}"
    iid.should_not be_blank
  end
end