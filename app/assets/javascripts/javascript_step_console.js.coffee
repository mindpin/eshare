$ ->
  # 输入提示框类
  class JSPrompt
    constructor: ($el)->
      @$el = $el

      # eval语句的执行上下文
      @binding = {}

      @history = []

    # 清空输入区域
    clear: ->
      @$el.val(null)

    # 对输入的javascript语句在@binding上下文环境中进行求值
    eval: ->
      try
        JSON.stringify eval.call(@binding, @$el.val())
      catch error
        error

    # 关联输入框到对应的jsconsole
    link: (jsconsole)->
      @$el.on 'keydown', (e)=>

        @history_keydown_handler(e)
        if e.keyCode == 13 && @$el.val() != ''
          @save_input()
          jsconsole.print(@eval())

          # 如果jsconsole存在当前javascript_step步骤且规则检查通过
          if jsconsole.current_step && jsconsole.current_step.check_rule(@$el.val())
            jsconsole.print('ok')

            # 进入到下一步
            jsconsole.current_step.next()

          jsconsole.scroll_bottom()
          @clear()

    ###############################
    #
    #  一下三个方法为输入历史相关方法
    #
    ###############################

    # 记录输入历史
    save_input: ->
      @history = @history + [@$el.val()]
      @cursor = @history.length - 1

    # 当前历史记录
    cursor_cmd: ->
      @cursor = 0 if @cursor < 0
      @cursor = @history.length - 1 if @cursor >= @history.length
      @history[@cursor]

    # 绑定历史浏览按键监听
    history_keydown_handler: (e)->
      # 方向键上
      if e.keyCode == 38 && @cursor >= 0
        @$el.val(@cursor_cmd())
        @cursor -= 1

      # 方向键下
      if e.keyCode == 40 && @cursor < @history.length
        @$el.val(@cursor_cmd())
        @cursor += 1

  # jsconsole打印结果类
  class JSConsole
    constructor: ($el)->
      @$el = $el

    # 转义html输入
    escape_html: (str)->
      div = document.createElement('div')
      div.appendChild(document.createTextNode(str))
      div.innerHTML

    # 在jsconsole的输出元素里打印结果
    print: (str)->
      @$el.append("<p>=> #{@escape_html(str)}</p>")

    # 滚动到console底部, 只在jsconsole输出元素上有滚动条的时候生效
    scroll_bottom: ->
      @$el.animate {
        scrollTop: @$el.prop('scrollHeight')
      }, 200

  class JSStep
    constructor: (obj)->
      for prop, value of obj
        @[prop] = value

    ######################
    #
    #  以下四个方法为类方法
    #
    ######################

    # 第一步ajax请求的url
    @first_step_url: ->
      cw_id = jQuery('.page-show-javascript-steps').data('course-ware-id')
      "/course_wares/#{cw_id}/javascript_steps/first.json"

    # 初始化页面jsconsole
    @init_jsconsole: ->
      @jsprompt  = new JSPrompt(jQuery('.page-show-javascript-steps .jsprompt'))
      @jsconsole = new JSConsole(jQuery('.page-show-javascript-steps .jsconsole'))
      @jsprompt.link(@jsconsole)

    # 开始javascript steps流程
    @start: ->
      @init_jsconsole()
      jQuery.ajax
        url: @first_step_url()
        method: 'GET'
        success: @callback

    # ajax请求回调
    @callback: (res)=>
      console.log(res)

      # 如果没有更多的后续step，则判断该javascript step课件学习完成
      if res == null
        return @jsconsole.print("恭喜你完成了学习！")

      step = new JSStep(res)
      @jsconsole.current_step = step
      @jsconsole.print(step.content)

    # 检查javascript step的规则
    check_rule: (input)->
      true

    # "下一步" ajax请求
    next: ->
      jQuery.ajax
        url: JSStep.jsconsole.current_step.next_url()
        method: 'GET'
        success: JSStep.callback

    # "下一步" ajax请求的地址
    next_url: ->
      "/javascript_steps/#{@id}/next.json"


  JSStep.start()
