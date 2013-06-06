class Omniauth < ActiveRecord::Base
  PROVIDER_WEIBO = 'weibo'
  PROVIDER_GITHUB = 'github'

  PROVIDERS = [PROVIDER_WEIBO, PROVIDER_GITHUB]
  attr_accessible :provider, :token, :expires_at, :expires, :info_json, :uid
  
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
      uid = auth_hash['uid']
      info = auth_hash['info']

      omniauth = _get_omniauth(provider)

      if omniauth.blank?
        self.omniauths.create(
          :provider   => provider, 
          :token      => token,
          :uid        => uid,
          :expires    => expires, 
          :expires_at => expires_at,
          :info_json  => info.to_json
        )
      else
        omniauth.update_attributes(
          :token      => token, 
          :uid        => uid,
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

    private
      def _get_omniauth(provider)
        self.omniauths.by_provider(provider).first
      end

  end
end
