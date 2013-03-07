module MindpinSidebar
  class Nav
    attr_accessor :title, :options, :controller_items, :subnavs
    def initialize(title, options)
      self.title = title
      self.options = options
      self.controller_items = []
      self.subnavs = []
    end

    def is_current?(view)
      controller = view.params["controller"].to_sym
      action = view.params["action"].to_sym

      self.controller_items.each do |item|
        return true if item.is_current?(controller, action)
      end

      self.subnavs.each do |nav|
        return true if nav.is_current?(view)
      end
      
      return false
    end
  end
end