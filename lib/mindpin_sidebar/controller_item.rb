module MindpinSidebar
  class ControllerItem
    attr_accessor :controller_name, :options
    def initialize(controller_name, options)
      self.controller_name = controller_name
      self.options = options
    end

    def is_current?(controller, action)
      return false if self.controller_name != controller

      return false if !options[:only].blank? && ![options[:only]].flatten.include?(action)

      return false if !options[:except].blank? && [options[:except]].flatten.include?(action)

      return true
    end
  end
end