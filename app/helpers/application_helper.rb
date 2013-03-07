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

  def hgoback(url)
    content_for :breadcrumb do
      content_tag :div, :class => 'link goback' do
        content_tag(:a, '返回上级', :href => url)
      end
    end
  end
  ##
  def page_top_fixed(klass, &block)
    css_class = [klass, 'page-top-fixed'] * ' '
    content_tag :div, :class => css_class, &block
  end

  def avatar(user, style = :normal)
    klass = ['page-avatar-img', style]*' '

    if user.blank?
      alt   = '未知用户'
      src   = User.new.logo.url(style)
      meta  = 'unknown-user'
    else
      alt   = user.real_name
      src   = user.logo.url(style)
      meta  = dom_id(user)
    end
    
    # jimage src, :alt => alt, 
    #             :class => klass, 
    #             :'data-meta' => meta

    image_tag src, :alt => alt, 
                   :class => klass, 
                   :'data-meta' => meta
  end

  def current_user_title
    return '老师' if current_user.is_teacher?
    return '同学' if current_user.is_student?
  end
end
