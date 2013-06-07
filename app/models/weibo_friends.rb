module WeiboFriends
  def self.included(base)
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def find_weibo_friends_from_edushare
      @find_weibo_friends_from_edushare ||= Finder.new(self)
    end
  end

  class Finder
    attr_reader :user, :list, :page_size, :cursor, :page, :cursor, :total, :max_pages

    def initialize(user, options = {})
      @user = user
      @cursor = options[:cursor] || 0
      @page_size = options[:page_size] || 16
      @list = []
    end

    def weibo_omniauth
      @weibo_omniauth ||= user.get_omniauth(Omniauth::PROVIDER_WEIBO)
    end
    
    def client
      user.get_weibo_oauth2_client(Omniauth::PROVIDER_WEIBO)
    end

    def request
      client.friendships.friends_ids(:uid => weibo_omniauth.uid, :cursor => cursor)
    end

    def fetch
      if !total || cursor < total
        response = request
        @total = response.total_number
        response.ids.each_with_index do |uid, index|
          user = find_registered_friend(uid)
          list << user if user
          @cursor += 1
          return list if list.size == page_size
        end
        fetch
      end
      list
    end

    def find_registered_friend(uid)
      User.joins(:omniauths).where(:omniauths => {:provider => 'weibo', :uid => uid}).first
    end
  end
end
