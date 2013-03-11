module OtherHelper
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

  def page_field(css_class, options={}, &block)
    options.assert_valid_keys :title
    content_tag :div, :class => ['page-field', css_class] do
      content_tag(:div, options[:title], :class => 'field-title') +
      content_tag(:div, :class => 'field-data') do
        capture(&block)
      end
    end
  end

  def page_list_head(options={})
    options.assert_valid_keys :cols
    content_tag :div, :class => :cells do
      yield HeadWidget.new(self, options[:cols])
    end
  end

  def page_model_list(models, options={}, &block)
    options.assert_valid_keys :cols, :class
    cols = options[:cols] || {}

    content_tag :div, :class => ['page-model-list', options[:class]] do
      if models.blank?
        content_tag :div, '目前列表没有内容', :class => :blank
      else
        models.map do |model|
          page_list_body :cols => cols, :model => model, &block
        end.reduce(&:+)
      end
    end
  end

  def page_list_body(options={})
    options.assert_valid_keys :cols, :model
    content_tag :div, :class => :cells do
      yield BodyWidget.new(self, options[:cols], options[:model])
    end
  end

  def page_buttons
    content_tag :div, :class => :buttons do
      yield HeadWidget.new(self)
    end
  end

  def avatar(user, style = :normal)
    klass = ['page-avatar-img', style]*' '

    if user.blank?
      alt   = '未知用户'
      src   = User.new.avatar.versions[style].url
      meta  = 'unknown-user'
    else
      alt   = user.name
      src   = user.avatar.versions[style].url
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

  def user_name(user)
    return "未知用户" if user.blank?
    user.name
  end

  def user_email(user)
    return "未知用户" if user.blank?
    user.email
  end

  def user_link(user)
    return '未知用户' if user.blank?
    link_to user.name, "/users/#{user.id}", :class=>'u-name'
  end

  def flash_info
    re = ''

    [:success, :error, :notice].each do |kind|
      info = flash[kind]
      if !info.blank?
        re += content_tag(:div, info, :class=>'page-flash-info')
      end
    end

    return re.html_safe
  end

  def list_pagination(collection)
    str = content_tag(:span, :class => 'desc') {current_displaying_items_str_for(collection)}
    pagination = will_paginate(collection, :class => 'pagination')
    content_tag(:div, :class => 'paginate-info') {str + pagination}
  end

  def sortable(column, header)
    is_current = is_current_sort?(column)
    param_dir = params[:dir]

    dir       = is_current && param_dir == 'asc' ? 'desc' : 'asc'
    css_class = is_current ? "sortable current #{param_dir}" : 'sortable'
    link_to header, {:sort => column, :dir => dir}, {:class => css_class}
  end

  def is_current_sort?(column)
    column.to_s == params[:sort].to_s
  end

  def current_displaying_items_str_for(collection)
    offset = (params[:page] ? params[:page].to_i : 1) * Paginated::PERPAGE
    start  = collection.blank? ? 0 : offset - Paginated::PERPAGE + 1
    total  = collection.all.count
    stop   = offset > total ? total : offset
    "当前显示第#{start}-#{stop}项(共#{total}项)"
    [_make_span('当前显示第'),
     _make_span(start, 'count'),
     _make_span('-第'),
     _make_span(stop, 'count'),
     _make_span('条结果（共'),
     _make_span(total, 'count'),
     _make_span('条结果）')].reduce(&:+)
  end

  def _make_span(content, css_class=nil)
    content_tag :span, content, :class => [css_class]
  end

  class HeadWidget < ActionView::Base
    def initialize(context, cols_hash=nil)
      @context = context
      @cols_hash = cols_hash
    end

    def button(text, path, options={})
      options.assert_valid_keys :class, :'data-model'
      link_to text, path, :class => [:button, options[:class]], :'data-model' => options[:'data-model']
    end

    def cell(attr_name, text, options={})
      options.assert_valid_keys :sortable
      col = @cols_hash[attr_name] ? "col_#{@cols_hash[attr_name]}" : 'col_1'
      content_tag :div, :class => [:cell, col, attr_name.to_s.dasherize] do
        options[:sortable] ? @context.sortable(attr_name, text) : @context._make_span(text)
      end
    end

    def checkbox(options={})
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, :checkbox] do
        @context.jcheckbox :checkbox, :check, false, ''
      end

    end

    def batch_destroy(model)
      self.button '删除选中项', 'javascript:;', :class => 'batch-destroy', :'data-model' => model.to_s
    end

    # 用于封装使用fbox进行model create的行为逻辑
    def ajax_create_button(name, title, url, &block)
      c1 = @context.jfbox_link name, title

      block_content = @context.capture(&block)

      form_buttons_content = @context.content_tag :div, :class=>'box-buttons' do
        b1 = link_to '确定', 'javascript:;', :class => 'ajax-submit'
        b2 = link_to '取消', 'javascript:;', :class => 'ajax-cancel'
        b1 + b2
      end

      @context.content_for :fbox do
        @context.jfbox name, title do
          @context.form_tag url, :method=>:post do
            block_content + form_buttons_content
          end
        end
      end

      return c1
    end
  end

  class BodyWidget < ActionView::Base
    attr_reader :model

    def initialize(context, cols_hash, model=nil)
      @context   = context
      @cols_hash = cols_hash
      @model     = model
    end

    def cell(*args, &block)
      attr_name = args.first

      if block_given?
        options = args.second || {}
        content = @context.capture(&block)
      else
        text = args.second
        content = @context._make_span(text)
        options = args.third || {}
      end

      col = @cols_hash[attr_name] ? "col_#{@cols_hash[attr_name]}" : 'col_1'

      content_tag :div, content, :class => [:cell, col, attr_name.to_s.dasherize]
    end

    def checkbox(model, options={})
      col = options[:col] ? "col_#{options[:col]}" : 'col_1'
      content_tag :div, :class => [:cell, col, :checkbox], :'data-model-id' => model.id do
        @context.jcheckbox :checkbox, :check, false, ''
      end

    end
  end
end