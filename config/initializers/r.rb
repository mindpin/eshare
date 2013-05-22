class R
  HASH = YAML.load_file(Rails.root.join('config/r.yaml'))
  LIBREOFFICE_PATH = HASH['libreoffice_path']
  CONVERT_BASE_PATH = File.expand_path(HASH['convert_base_path'], Rails.root.join('config'))

  STATIC_FILES_DIR = "static_files"
  UPLOAD_BASE_PATH = File.join(CONVERT_BASE_PATH, STATIC_FILES_DIR)

  WEIBO_KEY = HASH['weibo_key']
  WEIBO_SECRET = HASH['weibo_secret']

  WEIBO_REDIRECT_URI = HASH['weibo_redirect_uri']
end
Weibo2::Config.api_key = R::WEIBO_KEY
Weibo2::Config.api_secret = R::WEIBO_SECRET
Weibo2::Config.redirect_uri = R::WEIBO_REDIRECT_URI