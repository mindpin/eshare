module ApplicationHelper
  def jcheckbox(name, value, checked, text)
    span_klass = checked ? 'c checked' : 'c'

    content_tag :div, :class => 'pie-j-checkbox' do
      re1 = content_tag :span, :class => span_klass do
        check_box_tag(name, value, checked)
      end

      re2 = link_to(text.html_safe, 'javascript:;', :class => 'text')

      re1 + re2
    end
  end

  def htitle(str)
    content_for :title do
      str
    end
  end

  def hbreadcrumb(str, url = nil, options = {})
    url ||= 'javascript:;'

    content_for :breadcrumb do
      content_tag :div, :class => 'link' do
        content_tag(:a, truncate_u(str, 16), :href => url)
      end
    end
  end

  def truncate_u(text, length = 30, truncate_string = "...")
    truncate(text, :length => length, :separator => truncate_string)
  end
end
