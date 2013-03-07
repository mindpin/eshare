module MindpinSidebar
  class Group
    attr_accessor :title, :options, :navs
    def initialize(title, options)
      self.title = title
      self.options = options
      self.navs = []
    end
  end
end