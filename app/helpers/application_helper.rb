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
end
