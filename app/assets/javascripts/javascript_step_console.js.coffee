$ ->
  class JSPrompt
    constructor: ($el)->
      @$el = $el
      @binding = {}
      @history = []

    clear: ->
      @$el.val(null)

    eval: ->
      try
        JSON.stringify eval.call(@binding, @$el.val())
      catch error
        error

    link: (jsconsole)->
      @$el.on 'keydown', (e)=>
        if e.keyCode == 13 && @$el.val() != ''
          @save_input()
          jsconsole.print(@eval())
          if jsconsole.current_step
            if jsconsole.current_step.check_rule(@$el.val())
              jsconsole.print('ok')
              jsconsole.current_step.next(jsconsole.$el)
          jsconsole.scroll_bottom()
          @clear()

    save_input: ->
      @history = @history + [@$el.val()]

  class JSConsole
    constructor: ($el)->
      @$el = $el

    escape_html: (str)->
      div = document.createElement('div')
      div.appendChild(document.createTextNode(str))
      div.innerHTML

    print: (str)->
      @$el.append("<p>=> #{@escape_html(str)}</p>")

    scroll_bottom: ->
      @$el.animate {
        scrollTop: @$el.prop('scrollHeight')
      }, 200

  class JSStep
    constructor: (obj)->
      for prop, value of obj
        @[prop] = value

    check_rule: (input)->
      true

    next: ($el)->
      $el.trigger('next_javascript_step')

    next_url: ->
      "/javascript_steps/#{@id}/next.json"

  jsprompt  = new JSPrompt(jQuery('.page-show-javascript-steps .jsprompt'))
  jsconsole = new JSConsole(jQuery('.page-show-javascript-steps .jsconsole'))
  
  cw_id = jQuery('.page-show-javascript-steps').data('course-ware-id')
  first_step_url = "/course_wares/#{cw_id}/javascript_steps/first.json"

  first_ajax = (res)=>
    step = new JSStep(res)
    jsconsole.current_step = step
    jsconsole.print(step.content)
    
  next_ajax = (res)=>
    console.log res

  jQuery.ajax
    url: first_step_url
    method: 'GET'
    success: first_ajax

  jsconsole.$el.on 'next_javascript_step', ->
    jQuery.ajax
      url: jsconsole.current_step.next_url()
      method: 'GET'
      success: next_ajax

  jsprompt.link(jsconsole)
