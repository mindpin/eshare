jQuery ->
  class JavascriptStep
    constructor: (obj, @widget)->
      @content = obj.content
      @rule = obj.rule
      @id = obj.id

    test: (data)->
      input = data.input
      result = data.result
      error = data.error

      func_str = "var f = function(){ #{@rule} }; f();"
      return eval(func_str)

    done: ->
      jQuery(jQuery('.page-code-steps .step')[@index])
        .removeClass('error')
        .addClass('done')

      $done = jQuery('.page-code-steps .progress .done')
      count = jQuery('.page-code-steps .step.done').length
      $done.data('done', count)
      $done.html(count)

    error: ->
      jQuery(jQuery('.page-code-steps .step')[@index])
        .removeClass('done')
        .addClass('error')

    set_current: ->
      jQuery('.page-code-steps .step').removeClass('current')

      jQuery(jQuery('.page-code-steps .step')[@index])
        .addClass('current')

    save: (input, passed)->
      if _CURRENT_USER_ID
        jQuery.ajax
          url: "/javascript_steps/#{@id}/record_input"
          type: 'POST'
          data:
            input: input
            passed: passed
          success: (res)->
            console.log(res)


  class JavascriptStepWidget
    constructor: ($elm)->
      @$box = $elm.find('.console-box')
      @course_ware_id = $elm.data('course-ware-id')
      
      @get_steps()
      @start()

    get_steps: ->
      steps = []
      idx = 0
      jQuery.each _COURSE_WARE_STEPS, ->
        step = new JavascriptStep(this)

        if steps.length > 0
          last = steps[steps.length - 1]
          last.next = step
          step.prev = last

        step.index = idx
        idx = idx + 1
        steps.push step
      @steps = steps

    start: ->
      # 启动 console，欢迎
      @jqconsole = @$box.jqconsole('', '> ')
      @jqconsole.Write "你好，欢迎使用 MINDPIN edushare javascript 在线教学", 'welcome'

      # 先读取第一个step
      @current_step = null
      @run_next_step()

    run_next_step: ->
      if @current_step == null
        @step_load_callback @steps[0]
      else
        @step_load_callback @current_step.next

    step_load_callback: (step)=>
      @current_step = step

      if !!!step # 已经没有step了
        @all_done()
        return

      @current_step.set_current()

      @jqconsole.Write @current_step.content, 'log'
      @$box.find('span.log').last().effect 'highlight', {}, 1000

      @start_prompt()

    start_prompt: ->
      @jqconsole.Prompt true, (input)=>
        @input_handler(input)

    input_handler: (input)->
      result = null
      error = null

      if !input
        @start_prompt()

      else
        try
          result = @_eval(input)
          @jqconsole.Write("=> #{result}\n", 'output')

        catch err
          error = err
          @jqconsole.Write("#{error}", 'error')

        finally
          test = @current_step.test
            input: input
            result: result
            error: error

          if test == true
            @current_step.done()
            @current_step.save(input, true)
            @run_next_step()
          else
            @current_step.error()
            @current_step.save(input, false)
            @jqconsole.Append(
              "<span class='log'><span style='color:red;'>啊，再试一次吧。</span><br/><span>#{test}</span></span>"
            )

            @start_prompt()

    _eval: (input)->
      # 这里可以在当前 context 内重新设置一些变量 如 jQuery
      # 防止在 console 中调用

      that = this
      jQuery = null

      eval(input)

    all_done: ->
      @jqconsole.Write "祝贺你，你已经完成了这个小节的学习 :)", 'done'
      jQuery('.page-code-steps .progress').addClass('finish')

  jQuery('.page-code-console.javascript').each ->
    new JavascriptStepWidget jQuery(this)

# 以上是控制台风格的代码教学，一般不用。
# ---------------------------------------

class JavascriptStepTester
  constructor: (@code, @rule, @jqconsole)->

  _eval: ->
    # 这里可以在当前 context 内重新设置一些变量 如 jQuery
    # 防止在 console 中调用

    jQuery = undefined
    eval(@code)

  test: ->
    @run_code()

    code = @code
    result = @result
    error = @error

    try

      func_str = "var f = function(){ #{@rule} }; f();"
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

    save_error: (code)->
      @pass_status = 'error'
      @_save(code, false)
      @_set_dom_error()

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
            console.log(res)

    is_last: ->
      console.log @next
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

      @last_submitted_code = null

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
      @current_step = @steps[0]

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
        return that.editor.focus() if !(
          $s.hasClass('done') || 
          $s.hasClass('error') || 
          $s.hasClass('newest')
        )

        id = $s.data('id')
        jQuery(that.steps).each ->
          if this.id == id
            that.load_step this

    submit_code: ->
      code = @editor.getSession().getValue()
      test_result = @current_step.test(code)

      not_repeat_input = ( @last_submitted_code != code )
      @last_submitted_code = code

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
      @editor.getSession().setMode("ace/mode/javascript")
      @editor.getSession().setTabSize(2)
      @editor.setHighlightActiveLine(false)

      jQuery('#code-input').fadeIn()
      @$elm.find('.code-ops').fadeIn()
      @$elm.find('.code-console').fadeIn()
      @$elm.find('.steps-status').fadeIn()

      @editor.focus()
      # n = @editor.getSession().getValue().split("\n").length
      # @editor.gotoLine(n)

    start_console: ->
      @jqconsole = @$console_elm.jqconsole('', '> ')
      @jqconsole.Write "调试结果将输出在这里", 'log'

    go_next: ->
      @load_step @current_step.next

    load_step: (step)->
      return if step == null

      @current_step = step
      step.set_current()

      @hide_done_message()
      @set_code step.init_code

      @$elm.find('.current-step-info')
        .find('.step-title').html(step.title).end()
        .find('.step-desc').html(step.desc_html).end()
        .find('.step-content').html(step.content_html).end()
        .find('.step-hint .cc').html(step.hint_html).end()

      @editor.focus()

    init_ctrl_s_for_submit: ->
      jQuery(window).keypress (event)=>
        if !(event.which == 115 && event.ctrlKey) && !(event.which == 19) 
          return true

        @submit_code()
        return false


  jQuery('.page-coding.javascript').each ->
    new JavascriptPage jQuery(this)