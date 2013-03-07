module MindpinSidebar
  module Helpers
    def mindpin_sidebar(rule)
      MindpinSidebar::Base.render_sidebar(self, rule)
    end
  end
end