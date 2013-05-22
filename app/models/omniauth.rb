class Omniauth < ActiveRecord::Base
  PROVIDER_WEIBO = 'weibo'
  attr_accessible :provider, :token, :expires_at, :expires
  
  belongs_to :user
  validates :user, :provider, :token, :expires_at, :expires, :presence => true
  validates :provider, :inclusion => [PROVIDER_WEIBO]
  validates :user_id, :uniqueness => {:scope => :provider}

  scope :by_provider, lambda {|provider| {:conditions => ['omniauths.provider = ?', provider]} }

  module UserMethods
    def self.included(base)
      base.has_many :omniauths
    end

    def create_or_update_omniauth(provider, token, expires, expires_at)
      omniauth = self.omniauths.by_provider(provider).first
      if omniauth.blank?
        self.omniauths.create(
          :provider => provider, :token => token,
          :expires => expires, :expires_at => expires_at
        )
      else
        omniauth.update_attributes(
          :token => token, :expires => expires, :expires_at => expires_at 
        )
      end
    end

    def is_binded_weibo?
      self.omniauths.by_provider(PROVIDER_WEIBO).present?
    end

    def binded_weibo_is_expired?
      return true if !is_binded_weibo?

      omniauth = self.omniauths.by_provider(PROVIDER_WEIBO).first
      return false if !omniauth.expires

      omniauth.expires_at.to_i <= Time.now.to_i
    end

    def unbind_omniauth(provider)
      self.omniauths.by_provider(provider).destroy_all
    end

  end
end
