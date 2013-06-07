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

    def initialize(user, page_size = 16)
      @user = user
      @cursor = 0
      @list = []
      @page_size = page_size
      @max_pages = 0
      @page = 1
    end

    def weibo_omniauth
      @weibo_omniauth ||= user.get_omniauth(Omniauth::PROVIDER_WEIBO)
    end
    
    def client
      user.get_weibo_oauth2_client(Omniauth::PROVIDER_WEIBO)
    end

    def request
      client.friendships.friends(:uid => weibo_omniauth.uid, :cursor => cursor)
    end

    def fetch
      if !total || cursor < total
        response = request
        @total = response.total_number
        list[max_pages] = [] if !list[max_pages]
        response.users.each_with_index do |friend, index|
          user = find_registered_friend(friend.id)
          list[max_pages] << user if user
          @cursor += 1
          return @max_pages += 1 if list[max_pages].size == page_size
        end
        list.reject!(&:blank?)
        fetch
      end
    end

    def goto(page)
      list[page - 1]
    end

    def prev
      @page -= 1 if page >= 2
      goto(page)
    end

    def next
      if fetch
        return list[max_pages - 1]
      end
      @page += 1 if page < max_pages
      goto(page)
    end

    def find_registered_friend(uid)
      User.joins(:omniauths).where(:omniauths => {:provider => 'weibo', :uid => uid}).first
    end
  end
end
