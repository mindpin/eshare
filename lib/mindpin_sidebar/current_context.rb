require 'singleton'

module MindpinSidebar
  class CurrentContext
    attr_accessor :rules, :group, :nav, :subnav
    include Singleton
  end
end