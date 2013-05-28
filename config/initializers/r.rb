HASH = {
  :libreoffice_path  => '/opt/libreoffice3.6',
  :convert_base_path => '../public',

  :weibo_key => 4271779692,
  :weibo_secret => '96371b3a41daaca4cec23e3e8d31018e',

  :github_key => 'c759c6d54e5a91ea0510',
  :github_secret => '90fb53f99cdd15e73c820a5365678dbda8e706c4'
}

class R
  INHOUSE = false
  INTERNET = !INHOUSE

  LIBREOFFICE_PATH = HASH[:libreoffice_path]
  CONVERT_BASE_PATH = File.expand_path(HASH[:convert_base_path], Rails.root.join('config'))

  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)

  WEIBO_KEY = HASH[:weibo_key]
  WEIBO_SECRET = HASH[:weibo_secret]

  GITHUB_KEY = HASH[:github_key]
  GITHUB_SECRET = HASH[:github_secret]
end
WeiboOAuth2::Config.api_key = R::WEIBO_KEY
WeiboOAuth2::Config.api_secret = R::WEIBO_SECRET
WeiboOAuth2::Config.redirect_uri = ''
