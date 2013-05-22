Rails.application.config.middleware.use OmniAuth::Builder do
  provider :weibo, R::WEIBO_KEY, R::WEIBO_SECRET
end

