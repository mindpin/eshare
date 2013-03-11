require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Eshare
  class Application < Rails::Application
    # 一般情况下这里不要轻易修改
    # gem 的配置可以放到 initialzers 文件夹里

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # 时区，国际化
    config.time_zone = 'Beijing'
    config.i18n.default_locale = 'zh-CN'
    config.encoding = 'utf-8'

    # 日志内容过滤
    config.filter_parameters += [:password, :password_confirm, :token, :private_token]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # active_record 属性白名单
    config.active_record.whitelist_attributes = true

    # asset pipeline and version
    config.assets.enabled = true
    config.assets.version = '1.0'
    
    ### 自定义增加的代码
    require File.join(Rails.root, 'lib/mindpin_global_methods.rb')

    ### sanitized config
    config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td', 'th',
      'thead', 'tbody', 'tfoot', 'h3', 'h4', 'div', 'ul', 'ol', 'li', 'a',
      'code', 'pre', 'p', 'br', 'img', 'cite', 'blockquote', 'b', 'i', 'em',
      'strong', 'span'
    config.action_view.sanitized_allowed_attributes = 'href', 'src'
  end
end
