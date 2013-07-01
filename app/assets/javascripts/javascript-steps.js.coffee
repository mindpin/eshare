class JavascriptStepTester
  constructor: (@code, @rule, @jqconsole)->

  _eval: ->
    # 这里可以在当前 context 内重新设置一些变量 如 jQuery
    # 防止在 console 中调用

    _console = console
    jQuery = undefined
    window = {}

    @prints = []
    console =
      log: =>
        str = (arg for arg in arguments).join(' ')
        @jqconsole.Write str, 'output'
        @prints.push str
        return null

    eval(@code)

  test: ->
    @run_code()

    code = @code
    result = @result
    error = @error

    try

      MT = {}
      try 
        ast = new JSAST code

        MT = 
          prints: @prints
          printed: (str)->
            for s in @prints
              return true if "#{str}" == "#{s}"
            return false
          calls: ast.calls
          array_equals: (a, b)->
            JSON.stringify(a) == JSON.stringify(b)

      catch e
        MT = 
          prints: -> null
          printed: -> null
          calls: -> null
          array_equals: -> null

      func_str = "(function(){#{@rule}})();"
      test_return = eval(func_str)

      if test_return == true
        return @pack(true)
      else
        return @pack(false, test_return)

    catch e
      return @pack(false, '教程逻辑出错')


  # 先 run 一遍代码，获取执行结果以及抛出的错误（如果有）
  run_code: ->
    return '没有输入任何代码' if !@code

    @result = null
    @error = null

    try
      @result = @_eval @code
      @jqconsole.Write "=> #{@result}\n", 'output'

    catch err
      @error = err
      @jqconsole.Write "#{@error}", 'error'

  pack: (passed, message)->
    return {
      passed: passed
      message: message
    }

jQuery ->
  class JavaScriptPageStep
    constructor: (@step_data, @page)->
      @id = @step_data.id

      @title        = @step_data.title
      @desc         = @step_data.desc
      @desc_html    = @step_data.desc_html
      @content      = @step_data.content
      @content_html = @step_data.content_html
      @hint         = @step_data.hint
      @hint_html    = @step_data.hint_html
      @init_code    = @step_data.init_code
      @rule         = @step_data.rule

      @pass_status  = @step_data.pass_status
      @inputed_code = @step_data.inputed_code

    get_reset_code: ->
      return @inputed_code || @init_code

    test: (code)->
      return new JavascriptStepTester(code, @rule, @page.jqconsole).test()

    get_dom: ->
      return jQuery(jQuery('.steps-status .step')[@index])

    _get_doms_done: ->
      return jQuery('.steps-status .step.done')

    _is_all_step_finish: ->
      return jQuery('.steps-status .step').length == 
             jQuery('.steps-status .step.done').length

    _set_progress_count_value: (count)->
      $progress_done = jQuery('.steps-status .progress .done')
      $progress_done.data('done', count)
      $progress_done.html(count)

    save_done: (code)->
      @pass_status = 'done'
      @_save(code, true)
      @_set_dom_done()
      @inputed_code = code

    save_error: (code)->
      @pass_status = 'error'
      @_save(code, false)
      @_set_dom_error()
      @inputed_code = code

    _clear_dom_klass: ->
      return @get_dom().removeClass('error').removeClass('newest').removeClass('done')

    _is_empty_klass: ->
      $dom = @get_dom()
      return !($dom.hasClass('error') || $dom.hasClass('done') || $dom.hasClass('newest'))

    _set_dom_done: ->
      @_clear_dom_klass().addClass('done')
      @_set_progress_count_value(@_get_doms_done().length)

      if @next
        @next._set_dom_newest()

      if @_is_all_step_finish()
        jQuery('.steps-status .progress').addClass('finish')

    _set_dom_error: ->
      @_clear_dom_klass().addClass('error')

    _set_dom_newest: ->
      @get_dom().addClass('newest') if @_is_empty_klass()

    set_current: ->
      jQuery('.steps-status .step').removeClass('current')
      @get_dom().addClass('current')

    _save: (input, passed)->
      if _CURRENT_USER_ID
        jQuery.ajax
          url: "/javascript_steps/#{@id}/record_input"
          type: 'POST'
          data:
            input: input
            passed: passed
          success: (res)->

    is_last: ->
      return @next == null

  class JavascriptPage
    constructor: (@$elm)->
      @$console_elm = @$elm.find('.code-console .con')

      @$error = @$elm.find('.code-ops .error')
      @$done  = @$elm.find('.code-ops .done')

      @load_steps()
      @setup()
      @init_code_editor()
      @start_console()
      @init_ctrl_s_for_submit()
      @init_window_onpopstate()

      @reset_nanoscroller()

      @last_submitted_code = null
      @last_submitted_step = null

    load_steps: ->
      steps = []
      idx = 0
      that = @
      jQuery.each _COURSE_WARE_STEPS, ->
        step = new JavaScriptPageStep(this, that)
        step.prev = null
        step.next = null
        if steps.length > 0
          last = steps[steps.length - 1]
          last.next = step
          step.prev = last
        step.index = idx
        idx = idx + 1
        steps.push step
      @steps = steps

    setup: ->
      current_step_id = @$elm.find('.current-step-info').data('id')
      @current_step = @get_step_by_id current_step_id

      @$elm.find('a.submit-code').click =>
        @submit_code()

      @$elm.find('a.reset-code').click =>
        @set_code @current_step.init_code

      @$error.find('a.close').click =>
        @hide_error_message()

      @$done.find('a.close').click =>
        @hide_done_message()

      @$done.find('a.go-next').click =>
        @go_next()

      that = this
      @$elm.find('.steps-status a.step').click ->
        $s = jQuery(this)

        return that.editor.focus() if $s.hasClass('current')

        # 这里先不限制，随意切换
        # return that.editor.focus() if !(
        #   $s.hasClass('done') || 
        #   $s.hasClass('error') || 
        #   $s.hasClass('newest')
        # )

        step_id = $s.data('id')
        that.load_step that.get_step_by_id(step_id)

    submit_code: ->
      code = @editor.getSession().getValue()
      test_result = @current_step.test(code)

      not_repeat_input = !(
        @last_submitted_code == code && 
        @last_submitted_step == @current_step
      )
      @last_submitted_code = code
      @last_submitted_step = @current_step

      if test_result.passed
        # 通过
        if not_repeat_input
          @current_step.save_done(code)
        @show_done_message()
      else
        # 未通过
        if not_repeat_input
          @current_step.save_error(code)
        @show_error_message(test_result.message)

    set_code: (code)->
      @editor.getSession().setValue code

    hide_all_message: ->
      @hide_done_message()
      @hide_error_message()


    show_error_message: (message)->
      # @jqconsole.Append(
      #   "<span class='log'>" + 
      #     "<span class='tryagain'>啊，再试一次吧。</span>" +
      #     "<br/>" +
      #     "<span>#{message}</span>" + 
      #   "</span>"
      # )

      @hide_done_message()
      @$error
        .find('.message').html(message).end()
        .css
          left: -40
          opacity: 0
        .show()
        .animate
          left: 20
          opacity: 1
        , 200

    hide_error_message: ->
      @$error
        .animate
          left: -40
          opacity: 0
        , 200, =>
          @$error.hide()

    show_done_message: ->
      @hide_error_message()
      @$done
        .css
          left: -40
          opacity: 0
        .show()
        .animate
          left: 20
          opacity: 1
        , 200

      if @current_step.is_last()
        @$done.addClass('finish')
      else
        @$done.removeClass('finish')

    hide_done_message: ->
      @$done
        .animate
          left: -40
          opacity: 0
        , 200, =>
          @$done.hide()

    init_code_editor: ->
      @editor = ace.edit("code-input")
      @editor.setTheme("ace/theme/twilight")
      @editor.setHighlightActiveLine(false)

      @init_code_scroller_dom()
      @reset_nanoscroller()

      @editor.getSession().on 'change', =>
        @reset_nanoscroller()

      @editor.getSession().setMode("ace/mode/javascript")
      @editor.getSession().setTabSize(2)
      @editor.getSession().setUseWrapMode(true)

      jQuery('#code-input').fadeIn()
      @$elm.find('.code-ops').fadeIn()
      @$elm.find('.code-console').fadeIn()
      @$elm.find('.steps-status').fadeIn()

      @editor.focus()
      # n = @editor.getSession().getValue().split("\n").length
      # @editor.gotoLine(n)

      @load_step @current_step

    start_console: ->
      @jqconsole = @$console_elm.jqconsole('', '> ')
      @jqconsole.Write "调试结果将输出在这里：", 'output'

    go_next: ->
      @load_step @current_step.next

    get_step_by_id: (step_id)->
      step = null
      jQuery.each @steps, ->
        if this.id == step_id
          return step = this
      return step

    load_step: (step, save_history = true)->
      return if step == null
      
      @current_step = step
      step.set_current()

      @hide_done_message()
      @set_code step.get_reset_code()

      @$elm
        .find('.current-step-info').attr('data-id', step.id)
          .find('.step-title').html(step.title).end()
          .find('.step-desc').html(step.desc_html).end()
          .find('.step-content').html(step.content_html).end()
          .find('.step-hint .cc').html(step.hint_html).end()
          .find('.info').hide().fadeIn().end()
        .end()
      
      @hide_all_message()

      @editor.focus()

      if save_history
        @push_step_histroy(step)


    init_ctrl_s_for_submit: ->
      jQuery(document).keypress (event)=>
        if !(event.which == 13 && event.ctrlKey) && !(event.which == 10) 
          return true

        @submit_code()
        return false

    push_step_histroy: (step)->
      state = { step_id : step.id }
      window.history.pushState(
        state, 
        document.title, 
        "/javascript_steps/#{step.id}"
      )

    init_window_onpopstate: ->
      step = @current_step
      state = { step_id : step.id }
      window.history.replaceState(
        state, 
        document.title, 
        "/javascript_steps/#{step.id}"
      )

      window.addEventListener 'popstate', (e)=>
        that = this
        if e.state
          step_id = e.state.step_id
          @load_step @get_step_by_id(step_id), false

    init_code_scroller_dom: ->
      $ace_nanoscroller = jQuery('<div class="nano"></div>')
      $asb = jQuery('.ace_scrollbar')
      $asb.after $ace_nanoscroller
      $ace_nanoscroller.append $asb

    reset_nanoscroller: ->
      setTimeout =>
        jQuery('.code-box .nano').nanoScroller
          contentClass: 'ace_scrollbar'

        jQuery('.info.nano-content').css('overflow-y', 'scroll')
        jQuery('.current-step-info.nano').nanoScroller
          contentClass: 'nano-content'

      , 1


  jQuery('.page-coding.javascript').each ->
    new JavascriptPage jQuery(this)