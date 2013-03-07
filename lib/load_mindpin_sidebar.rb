module MindpinSidebar
  class Railtie < Rails::Railtie

    initializer 'mindpin_sidebar.helper' do |app|
      ActionView::Base.send :include, MindpinSidebar::Helpers
    end
    config.to_prepare do
      filename = File.join(Rails.root.to_s, 'config/mindpin_sidebar_config.rb')
      load filename if File.exists?(filename)
    end
  end
end