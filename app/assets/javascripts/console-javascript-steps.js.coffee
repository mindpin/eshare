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
            # console.log(res)


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