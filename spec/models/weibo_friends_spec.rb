# -*- coding: utf-8 -*-
require "spec_helper"

describe WeiboFriends do
  describe WeiboFriends::Finder do
    let(:finder) {WeiboFriends::Finder.new FactoryGirl.create(:user), 1}
    let(:uid1)   {Omniauth.all[3].uid}
    let(:uid2)   {Omniauth.all[7].uid}
    before(:each) do
      8.times {FactoryGirl.create :omniauth}

      WeiboFriends::Finder.send :define_method, :request do
        response = Hashie::Mash.new(:total_number => 10)
        response.users = (
          [Hashie::Mash.new(:id => Omniauth.all[3].uid), Hashie::Mash.new(:id => Omniauth.all[7].uid)] +
          1.upto(8).map {|i| Hashie::Mash.new(:id => "notregistered#{i}")}
        )[cursor..-1]
        response
      end
    end

    describe "#next" do
      it "returns first page" do
        finder.next.should eq [finder.find_registered_friend(uid1)]
      end

      it "returns second page" do
        finder.next
        finder.next.should eq [finder.find_registered_friend(uid2)]
      end

      it "returns next page util last page" do
        finder.next
        finder.next
        finder.next.should eq [finder.find_registered_friend(uid2)]
      end
    end

    describe "#prev" do
      it "returns nothing" do
        finder.prev.should be nil
      end

      it "returns first page" do
        2.times {finder.next}
        finder.prev.should eq [finder.find_registered_friend(uid1)]
      end

      it "returns previous page util first page" do
        2.times {finder.next}
        2.times {finder.prev}
        finder.prev.should eq [finder.find_registered_friend(uid1)]
      end
    end
  end
end
