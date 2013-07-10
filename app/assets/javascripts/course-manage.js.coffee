# aj方式，暂时用不上
jQuery ->
  class CourseManager
    constructor: (@$elm)->
      @setup()
      @current_chapter_id = null

    setup: ->
      jQuery(document).on 'click', '.chapters a.chapter', (evt)=>
        jQuery.pjax.click evt, '#pjax-container'
        @current_chapter_id = jQuery(evt.target).data('id')

      jQuery(document).on 'click', 'a.add-chapter', (evt)=>
        jQuery.pjax.click evt, '#pjax-container'
        @current_chapter_id = null

      jQuery(document).on 'submit', 'form', (evt)=>
        # jQuery.pjax.submit evt, '#pjax-container'

      jQuery(document).on 'pjax:complete', =>
        jQuery('a.chapter').removeClass('current')

        if @current_chapter_id
          jQuery("a.chapter[data-id=#{@current_chapter_id}]").addClass('current')

  jQuery('.page-course-manage-aj').each ->
    new CourseManager jQuery(this)

# 设置选课人数上限的表单事件相关 INHOUSE
jQuery ->
  class CourseForm
    constructor: (@$form)->
      @setup()

    setup: ->
      that = @
      jQuery(@$form).on 'click', '#course_enable_apply_request_limit', ->
        $checkbox = jQuery(this)
        if $checkbox.is(':checked')
          that.show_limit()
        else
          that.hide_limit()

    show_limit: ->
      @$form.find('.limit-inputer').fadeIn(200).find('input').val('')

    hide_limit: ->
      @$form.find('.limit-inputer').fadeOut(200).find('input').val('')


  jQuery('.page-course-form form').each ->
    new CourseForm jQuery(this)

# javascript 教程编辑表单
jQuery ->
  class JavascriptCourseWareForm
    constructor: (@$elm)->
      @$current_step = @$elm.find('.current-step')
      @course_ware_id = @$elm.data('course-ware-id')

      @$save = @$elm.find('a.btn.save')
      @$preview = @$elm.find('a.btn.preview')

      @origin_data = null
      @setup()
      @init_change_watcher()
      @init_ctrl_s_for_save()

    setup: ->
      if @has_form()
        @init_code_editor()

      that = @
      jQuery(document).delegate '.javascript-steps-form .steps .step', 'click', ->
        that.select_step jQuery(this)


      @$preview.on 'click', =>
        window.open "/javascript_steps/#{@get_current_step_id()}"

      @$save.on 'click', =>
        @save_data()

      jQuery(document).delegate '.javascript-steps-form .steps a.add-step', 'click', =>
        jQuery.ajax
          url: "/manage/course_wares/#{@course_ware_id}/javascript_steps"
          type: 'POST'
          success: (res)=>
            $new_steps = jQuery(res).find('.steps')
            $old_steps = jQuery('.javascript-steps-form .steps')
            $old_steps.after($new_steps).remove()

            @select_step $new_steps.find('.step').last()

      jQuery(document).delegate '.javascript-steps-form form a.delete', 'click', =>
        if confirm('确定要删除吗？')

          current_step_id = @get_current_step_id()

          jQuery.ajax
            url: "/manage/javascript_steps/#{current_step_id}"
            type: 'DELETE'
            success: (res)=>
              $new_steps = jQuery(res).find('.steps')
              $old_steps = jQuery('.javascript-steps-form .steps')
              $old_steps.after($new_steps).remove()

              jQuery('.javascript-steps-form .steps .step').removeClass('current')

              @$current_step.html("<div class='deleted'>检查点已删除</div>")
              @hide_btns()

      jQuery(document).delegate '.javascript-steps-form form input#javascript_step_code_reset', 'change', =>
        @change_code_reset()

    change_code_reset: ->
      if jQuery('.javascript-steps-form form input#javascript_step_code_reset').is(':checked')
        @$elm.find('.codes .ic').removeClass('disabled')
        @editor_init_code.setReadOnly(false)
      else
        @$elm.find('.codes .ic').addClass('disabled')
        @editor_init_code.setReadOnly(true)

    select_step: ($step)->
      @origin_data = null

      step_id = $step.data('id')
      jQuery('.javascript-steps-form .steps .step').removeClass('current')
      $step.addClass('current')

      @$current_step
        .data('id', step_id)
        .html("<div class='loading'>loading...</div>")

      jQuery.ajax
        url: "/manage/javascript_steps/#{step_id}/form_html"
        type: 'GET'
        success: (res)=>
          new_html = jQuery(res).find('.current-step').html()
          @$current_step.html(new_html)
          @init_code_editor()

    init_code_editor: ->
      @editor_init_code = ace.edit("init-code")
      @editor_init_code.setTheme("ace/theme/twilight")
      @editor_init_code.getSession().setMode("ace/mode/javascript")
      @editor_init_code.getSession().setTabSize(2)

      @editor_check_rule = ace.edit("step-rule")
      @editor_check_rule.setTheme("ace/theme/twilight")
      @editor_check_rule.getSession().setMode("ace/mode/javascript")
      @editor_check_rule.getSession().setTabSize(2)

      @origin_data = @get_form_value()
      @show_preview()

    init_change_watcher: ->
      change_watcher = setInterval =>
        return if jQuery('.current-step .deleted').length > 0
        return if @origin_data == null
        if @get_form_value() != @origin_data
          @show_save()
        else
          @show_preview()
      , 100
    
    init_ctrl_s_for_save: ->
      jQuery(document).keypress (event)=>
        if !(event.which == 115 && event.ctrlKey) && !(event.which == 19) 
          return true

        @save_data()
        return false

    has_form: ->
      @$elm.find('.current-step form').length > 0

    get_form_value: ->
      return false if !@has_form()

      @$elm.find('input#javascript_step_init_code').val @editor_init_code.getSession().getValue()
      @$elm.find('input#javascript_step_rule').val @editor_check_rule.getSession().getValue()
      return @$elm.find('.current-step form').serialize()

    hide_btns: ->
      @$save.hide()
      @$preview.hide()

    show_save: ->
      @$save.show()
      @$preview.hide()

    show_preview: ->
      @$save.hide()
      @$preview.show()

    save_data: ->
      return false if !@has_form()

      current_step_id = @get_current_step_id()
      jQuery.ajax
        url: "/manage/javascript_steps/#{current_step_id}"
        type: 'PUT'
        data: @get_form_value()
        success: (res)=>
          @origin_data = @get_form_value()

    get_current_step_id: ->
      @$elm.find('.current-step').data('id')


  jQuery('.javascript-steps-form').each ->
    new JavascriptCourseWareForm jQuery(this)


jQuery ->

  # 课程管理批准
  jQuery(document).on 'click', '.page-course-applies .course-applies a.accept', ->
    apply_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/manage/applies/#{apply_id}/accept"
      type : 'put'
      success : (res)=>
        $new_tr = jQuery(res.html).find('tr.select_course_apply')
        $old_tr = jQuery(this).closest('tr')
        $old_tr.after $new_tr
        $old_tr.remove()

# 课程管理拒绝
  jQuery(document).on 'click', '.page-course-applies .course-applies a.reject', ->
    apply_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/manage/applies/#{apply_id}/reject"
      type : 'put'
      success : (res)=>
        $new_tr = jQuery(res.html).find('tr.select_course_apply')
        $old_tr = jQuery(this).closest('tr')
        $old_tr.after $new_tr
        $old_tr.remove()