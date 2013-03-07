module MindpinSidebar
  class Rule
    attr_accessor :title, :groups
    def initialize(title)
      self.title = title
      self.groups = []
    end

    def self.get(title)
      @@rules[title] ||= self.new(title)
    end

    def self.all
      @@rules
    end

    def self.init
      @@rules = {}
    end
  end
end