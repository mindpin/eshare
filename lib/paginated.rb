require 'active_support/concern'

module Paginated
  extend ActiveSupport::Concern
  PERPAGE = 20

  included do
    self.per_page = PERPAGE
  end

  module ClassMethods
    def paginated(page)
      paginate(:page => page)
    end
  end
end
