class Omniauth < ActiveRecord::Base
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



  STOP_WORDS = begin
    file = File.new File.expand_path(Rails.root.to_s + '/lib/stopwords.txt')
    file.read.split("\r\n") - ['']
  end

  def _prepate_text(text)
    s1 = text.gsub /@\S+/, ''
    s1.gsub /http:\/\/\S+/, ''
  end

  def _combine_statuses(statuses)
    words = Hash.new(0)

    statuses.each do |status|

      algor = RMMSeg::Algorithm.new(_prepate_text(status))
    
      loop do
        tok = algor.next_token
        break if tok.nil?

        word = tok.text.force_encoding("UTF-8")

        if !STOP_WORDS.include?(word) && word.split(//u).length > 1
          words[word] = words[word] + 1            
        end
       
      end
    end

    words
  end


  def get_weibo_list
    client = WeiboOAuth2::Client.new
    client.get_token_from_hash({:access_token => self.token, :expires_at => self.expires_at})
    statuses = client.statuses

    weibo_records = statuses.public_timeline(:count => 3)

    weibo_text_list = []
    weibo_records['statuses'].each do |record|
      weibo_text_list << record['text']
    end

    weibo_text_list
  end


  def get_words
    records = get_weibo_list
    
    self._combine_statuses(records)
  end



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
