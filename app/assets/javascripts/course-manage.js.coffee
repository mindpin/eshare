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

# 课程章节排序
jQuery ->
  class CourseSortTable
    constructor: (@$table)->
      @setup()

    setup: ->
      that = this
      @$table.delegate 'td.position a.btn.move-up', 'click', ->
        url = jQuery(this).data('url')
        old_tr = jQuery(this).closest('tr')

        jQuery.ajax
          url: url
          type: 'put'
          success: (res)->
            new_tr = jQuery(res.html).find('tbody tr')
            that.up_down_animate old_tr.prev(), old_tr, new_tr

            old_tr.prev().before(new_tr)
            old_tr.remove()


      @$table.delegate 'td.position a.btn.move-down', 'click', ->
        url = jQuery(this).data('url')
        old_tr = jQuery(this).closest('tr')

        jQuery.ajax
          url: url
          type: 'put'
          success: (res)->
            new_tr = jQuery(res.html).find('tbody tr')
            that.up_down_animate old_tr, old_tr.next(), new_tr

            old_tr.next().after(new_tr)
            old_tr.remove()

    up_down_animate: ($up_tr, $down_tr, $new_tr)->
      $up_tr_temp_table   = @_build_animate_table $up_tr
      $down_tr_temp_table = @_build_animate_table $down_tr

      $up_tr.css('opacity', 0)
      $down_tr.css('opacity', 0)
      $new_tr.css('opacity', 0)

      doh = $down_tr.outerHeight()
      uoh = $up_tr.outerHeight()

      $up_tr_temp_table
        .animate
          top: "+=#{doh}"
        , 400, -> 
          $up_tr_temp_table.remove()
          $up_tr.css('opacity', 1)
          $new_tr.css('opacity', 1)

      $down_tr_temp_table
        .animate
          top: "-=#{uoh}"
        , 400, -> 
          $down_tr_temp_table.remove()
          $down_tr.css('opacity', 1)

    _build_animate_table: ($tr)->
      $tr_clone = @_clone_tr($tr)

      width = @$table.outerWidth()
      offset = $tr.offset()

      return jQuery('<table><tbody></tbody></table>')
        .addClass('page-data-table')
        .addClass('striped')
        .addClass('bordered')
        .css
          'border-top': '0 none'
          position: 'absolute'
          'background-color': '#ffffda'
          width: width
          left: offset.left
          top: offset.top

        .find('tbody').append($tr_clone).end()
        .find('td').css('background-color', 'transparent').end() 
        .appendTo(jQuery('body'))

    _clone_tr: ($tr)->
      $clone_tr = $tr.clone()

      $tr.find('td').each (index)->
        width = jQuery(this).width()
        $clone_tr.find('td').eq(index).width(width)

      return $clone_tr

  jQuery('table.page-data-table.course-wares').each ->
    new CourseSortTable jQuery(this)

  jQuery('table.page-data-table.chapters').each ->
    new CourseSortTable jQuery(this)
