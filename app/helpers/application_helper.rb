module ApplicationHelper
  class BreadcrumbRender


    def initialize(view, *args)
      @view = view

      @breadcrumbs = [

      ]
    end

    def add(text, url)

    end
  end

  def page_breadcrumb(*args)
    # BreadcrumbRender.new(self, *args)
    self.request.path
  end
end
