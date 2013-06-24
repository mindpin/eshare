HASH = {
  :libreoffice_path  => '/opt/libreoffice3.6',
  :convert_base_path => '../public'
}

oauth_key_path = Rails.root.join('config/oauth_key.yaml')
if File.exists?(oauth_key_path)
  oauth_key_hash = YAML.load_file(oauth_key_path).symbolize_keys
  HASH.merge!(oauth_key_hash)
end

class R
  INHOUSE = true
  INTERNET = !INHOUSE

  LIBREOFFICE_PATH = HASH[:libreoffice_path]
  CONVERT_BASE_PATH = File.expand_path(HASH[:convert_base_path], Rails.root.join('config'))

  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)

  # -------------------

  WEIBO_KEY = HASH[:weibo_key]
  WEIBO_SECRET = HASH[:weibo_secret]

  GITHUB_KEY = HASH[:github_key]
  GITHUB_SECRET = HASH[:github_secret]

  # -------------------

  EMAIL_ADDRESS  = ''
  EMAIL_USER     = ''
  EMAIL_PASSWORD = ''
end

WeiboOAuth2::Config.api_key = R::WEIBO_KEY
WeiboOAuth2::Config.api_secret = R::WEIBO_SECRET
WeiboOAuth2::Config.redirect_uri = ''

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  :address              => R::EMAIL_ADDRESS,
  :port                 => 25,
  :user_name            => R::EMAIL_USER,
  :password             => R::EMAIL_PASSWORD,
  :authentication       => 'plain',
  :enable_starttls_auto => true
}