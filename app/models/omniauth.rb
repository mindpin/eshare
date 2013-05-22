class Omniauth < ActiveRecord::Base
  PROVIDER_WEIBO = 'weibo'
  attr_accessible :provider, :token, :expires_at, :expires, :info_json
  
  belongs_to :user
  validates :user, :provider, :token, :expires_at, :expires, :presence => true
  validates :provider, :inclusion => [PROVIDER_WEIBO]
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

      omniauth = get_omniauth(provider)

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

    def get_omniauth(provider)
      self.omniauths.by_provider(provider).first
    end

    def get_weibo_omniauth
      get_omniauth(Omniauth::PROVIDER_WEIBO)
    end

    def get_weibo_bind_info
      JSON::parse get_omniauth(Omniauth::PROVIDER_WEIBO).info_json
    end

    def is_binded_weibo?
      self.omniauths.by_provider(Omniauth::PROVIDER_WEIBO).present?
    end

    def binded_weibo_is_expired?
      return true if !is_binded_weibo?

      omniauth = self.get_weibo_omniauth
      return false if !omniauth.expires

      omniauth.expires_at.to_i <= Time.now.to_i
    end

    def unbind_omniauth(provider)
      get_omniauth(provider).destroy
    end

  end
end
