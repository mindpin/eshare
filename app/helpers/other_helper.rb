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