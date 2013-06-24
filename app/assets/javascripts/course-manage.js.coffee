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
    constructor: (@$form)->
      @$current_step = @$form.find('.current-step')
      @chapter_id = @$form.data('chapter-id')

      @setup()

    setup: ->
      if @$form.find('.current-step form').length > 0
        @init_code_editor()

      that = @
      jQuery(document).delegate '.javascript-steps-form .steps .step', 'click', ->
        $step = jQuery(this)
        step_id = $step.data('id')
        jQuery('.javascript-steps-form .steps .step').removeClass('current')
        $step.addClass('current')

        that.$current_step.data('id', step_id).html("<div class='loading'>loading...</div>")
        jQuery.ajax
          url: "/manage/chapters/#{that.chapter_id}/course_wares/javascript_steps_form"
          data:
            step_id: step_id
          type: 'GET'
          success: (res)=>
            new_html = jQuery(res).find('.current-step').html()
            that.$current_step.html(new_html)#.hide()
            that.init_code_editor()
            # that.$current_step.fadeIn(300)


    init_code_editor: ->
      editor0 = ace.edit("init-code")
      editor0.setTheme("ace/theme/twilight")
      editor0.getSession().setMode("ace/mode/javascript")

      editor1 = ace.edit("step-rule")
      editor1.setTheme("ace/theme/twilight")
      editor1.getSession().setMode("ace/mode/javascript")

  jQuery('.javascript-steps-form').each ->
    new JavascriptCourseWareForm jQuery(this)