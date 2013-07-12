class JavascriptStepTester
  constructor: (@code, @rule, @jqconsole)->
    @window_console = console

  test: ->
    # 暂时不用 @run_code()

    code = @code

    return return @pack(false, '你没有输入任何代码。') if !code

    result = null
    error = null

    # 1，执行用户输入代码，获得 result, error, code 三个变量

    try
      # 暂时不用 @result = @_eval @code

      # 这里可以在当前 context 内重新设置一些变量 如 jQuery
      # 防止在 console 中调用

      # 约束一些变量
      jQuery = undefined
      window = {}
      _prints = []
      console =
        log: =>
          strs = []
          for arg in arguments
            if arg == undefined
              strs.push "undefined"
            else
              if typeof(arg) == 'string'
                strs.push arg  
              else
                strs.push JSON.stringify(arg)

          str = strs.join(' ')
          @jqconsole.Write str, 'output'
          _prints.push str
          return

      result = eval code

      if result != undefined
        @jqconsole.Write "#{JSON.stringify result}\n", 'output'

    catch err
      error = err
      @jqconsole.Write "#{error}", 'error'


    # 2, 用检查规则对代码做出检查

    try

      MT = {}
      try 
        ast = new JSAST code

        MT = 
          prints: _prints
          printed: (str)->
            _str = 
              if typeof(str) == 'string'
                str
              else
                JSON.stringify str

            for s in _prints
              return true if "#{_str}" == "#{s}"
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

      # 恢复对变量的约束

      console = @window_console

      func_str = "(function(){#{@rule}})();"
      test_return = eval(func_str)

      if test_return == true
        return @pack(true)
      else
        return @pack(false, test_return)

    catch e
      return @pack(false, '教程逻辑出错')

  pack: (passed, message)->
    msg = 
      if typeof(message) == 'string'
        message
      else
        JSON.stringify message

    return {
      passed: passed
      message: msg
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
      @rule         = @step_data.rule

      @pass_status  = @step_data.pass_status
      
      @code_reset     = @step_data.code_reset
      @init_code      = @step_data.init_code
      @submitted_code = @step_data.submitted_code
      @inputed_code   = null      

    # reset 的逻辑
    # 当 code_reset == true 时
    #   很简单，直接取 init_code 即可
    # 当 code_reset == false 时，reset的代码就和当前检查点无关了
    #   所以，尝试获取上一个节点的显示代码（ui_code）即可
    #   因为实际上 code_reset 设置为 false 的目的，就是让这个检查点继承上一个节点的代码
    get_reset_code: ->
      return @init_code if @code_reset
      return @prev.get_ui_code() if @prev
      return ''

    # 获取显示代码 (ui_code) 的逻辑
    # 当 code_reset == true 时，显示代码完全取决于检查点自身
    #   按照 @inputed_code > @submitted_code > @init_code 的优先级取得即可
    # 当 code_reset == false 是，显示代码按以下优先级取得
    #   @inputed_code > @submitted_code > @get_reset_code()
    # 
    # 由于 当 code_reset = true 时，@get_reset_code() 一定返回 @init_code
    # 所以，无论任何情况，都可以化简为
    #   按照 @inputed_code > @submitted_code > @get_reset_code() 取得
    get_ui_code: ->
      return @inputed_code || @submitted_code || @get_reset_code()


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
      @submitted_code = code

    save_error: (code)->
      @pass_status = 'error'
      @_save(code, false)
      @_set_dom_error()
      @submitted_code = code

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
      @start_console()
      @setup()
      @init_code_editor()
      @init_ctrl_s_for_submit()
      @init_window_onpopstate()

      @reset_nanoscroller()

      @last_submitted_code = null
      @last_submitted_step = null
      @last_test_result    = null

      @init_code_input_timer()

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
        @set_code @current_step.get_reset_code()

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
        @last_submitted_step == @current_step &&
        @last_test_result    == test_result
      )
      @last_submitted_code = code
      @last_submitted_step = @current_step
      @last_test_result    = test_result

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
      if @jqconsole
        @jqconsole.Reset()
      else
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

      # 切换检查点时设置编辑区代码
      @set_code step.get_ui_code()

      @$elm
        .find('.current-step-info').attr('data-id', step.id)
          .find('.step-title').html(step.title).end()
          .find('.step-desc').html(step.desc_html).end()
          .find('.step-content .cc').html(step.content_html).end()
          .find('.step-hint .cc').html(step.hint_html).end()
          .find('.info').hide().fadeIn().end()
        .end()

      @$elm.find('.nano-content').scrollTop(0)
      @start_console()

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
          contentClass: 'nano-content',
          alwaysVisible: true

      , 1

    init_code_input_timer: ->
      # 关键逻辑：
      #   当代码没有发生变化（当前输入代码，相比于 get_reset_code()）时，
      #   @inputed_code 赋值为 null

      code_input_timer = setInterval =>
        return if !@current_step
        reset_code = @current_step.get_reset_code()
        editor_value = @editor.getSession().getValue()

        if editor_value == reset_code
          @current_step.inputed_code = null
        else
          @current_step.inputed_code = editor_value
      , 100

  jQuery('.page-coding.javascript').each ->
    new JavascriptPage jQuery(this)