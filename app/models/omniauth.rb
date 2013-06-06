class Omniauth < ActiveRecord::Base
  include Fengci

  PROVIDER_WEIBO = 'weibo'
  PROVIDER_GITHUB = 'github'

  PROVIDERS = [PROVIDER_WEIBO, PROVIDER_GITHUB]
  attr_accessible :provider, :token, :expires_at, :expires, :info_json
  
  belongs_to :user
  validates :user, :provider, :token, :presence => true
  validates :expires_at, :presence => {:if => :expires? }
  validates :provider, :inclusion => PROVIDERS
  validates :user_id, :uniqueness => {:scope => :provider}

  scope :by_provider, lambda {|provider| {:conditions => ['omniauths.provider = ?', provider]} }


  
  module UserMethods
    def self.included(base)
      base.has_many :omniauths
    end

    def create_or_update_omniauth(auth_hash)
      provider = auth_hash['provider']
      token = auth_hash['credentials']['token']
      expires = auth_hash['credentials']['expires']
      expires_at = auth_hash['credentials']['expires_at']
      info = auth_hash['info']

      omniauth = _get_omniauth(provider)

      if omniauth.blank?
        self.omniauths.create(
          :provider   => provider, 
          :token      => token,
          :expires    => expires, 
          :expires_at => expires_at,
          :info_json  => info.to_json
        )
      else
        omniauth.update_attributes(
          :token      => token, 
          :expires    => expires, 
          :expires_at => expires_at,
          :info_json  => info.to_json
        )
      end
    end

    Omniauth::PROVIDERS.each do |provider|

      define_method "get_#{provider}_bind_info" do
        JSON::parse _get_omniauth(provider).info_json
      end

      define_method "is_binded_#{provider}?" do
        omniauths.by_provider(provider).present?
      end

      define_method "binded_#{provider}_is_expired?" do
        return true if omniauths.by_provider(provider).blank?

        omniauth = _get_omniauth(provider)
        return false if !omniauth.expires

        omniauth.expires_at.to_i <= Time.now.to_i
      end
      
    end

    def unbind_omniauth(provider)
      _get_omniauth(provider).destroy
    end

    def send_weibo(text)
      client = _get_weibo_oauth2_client(PROVIDER_WEIBO)
      client.statuses.update(text)
    end

    def get_weibo_comments(url_long, page)
      client = _get_weibo_oauth2_client(PROVIDER_WEIBO)
      short_url = client.short_url.shorten(url_long).urls.first.url_short
      comments = client.short_url.comment_comments(short_url, opt={:count => 50, :page => page})

      weibo_comments = []
      comments['share_comments'].each do |comment|
        weibo_comments << WeiboComment.new(comment)
      end

      weibo_comments
    end

    def get_weibo_messages
      client = WeiboOAuth2::Client.new
      client.get_token_from_hash({:access_token => _get_omniauth(PROVIDER_WEIBO).token, 
                                  :expires_at => _get_omniauth(PROVIDER_WEIBO).expires_at})
      statuses = client.statuses

      weibo_list = statuses.public_timeline(:count => 3)

      messages = []
      weibo_list['statuses'].each do |row|
        messages << row['text']
      end

      messages
    end

    def get_weibo_words_rate
      records = get_weibo_messages
      
      Fengci._combine_statuses(records)
    end

    private
      def _get_omniauth(provider)
        self.omniauths.by_provider(provider).first
      end

      def _get_weibo_oauth2_client(provider)
        omniauth = _get_omniauth(provider)
        return if omniauth.blank?

        client = WeiboOAuth2::Client.new

        client.get_token_from_hash(
          :access_token => omniauth.token,
          :expires_at => omniauth.expires_at
        )
        client
      end

  end
end
