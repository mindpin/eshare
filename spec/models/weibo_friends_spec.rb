# -*- coding: utf-8 -*-
require "spec_helper"

describe WeiboFriends do
  describe WeiboFriends::Finder do
    let(:user)   {FactoryGirl.create(:user)}
    let(:finder) {user.find_weibo_friends_from_edushare(:page_size => 1)}
    let(:uid1)   {Omniauth.all[3].uid}
    let(:uid2)   {Omniauth.all[4].uid}
    let(:user1)  {finder.find_registered_friend(uid1)}
    let(:user2)  {finder.find_registered_friend(uid2)}

    before(:each) do
      8.times {FactoryGirl.create :omniauth}

      WeiboFriends::Finder.send :define_method, :request do
        response = Hashie::Mash.new(:total_number => 10)
        response.ids = (
          [Omniauth.all[3].uid, Omniauth.all[4].uid] +
          1.upto(8).map {|i| "notregistered#{i}"}
        )[cursor..-1]
        response
      end
    end

    describe "#fetch" do
      it "fetches first page" do
        finder.fetch.should =~ [user1]
      end

      it "fetches second page" do
        finder.fetch
        finder.fetch.should =~ [user1, user2]
      end

      it "fetches next page util reaching the end" do
        2.times {finder.fetch}
        finder.fetch.should =~ [user1, user2]
      end

      it "fetches with a middle way cursor" do
        finder = user.find_weibo_friends_from_edushare(:page_size => 1, :cursor => 1)
        finder.fetch.should =~ [user2]
      end
    end

  end
end
