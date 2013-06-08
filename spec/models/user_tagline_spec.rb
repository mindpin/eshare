require "spec_helper"

describe '用户个人签名档' do
  before{
    @user = FactoryGirl.create :user
  }

  it{
    expect {
      @user.name = 'user_1_gai'
      @user.save!
    }.to change{
      Feed.count
    }.by(0)
  }

  it{
    expect {
      @user.tagline = 'user_1_gai'
      @user.save!
    }.to change{
      Feed.count
    }.by(1)
  }

end