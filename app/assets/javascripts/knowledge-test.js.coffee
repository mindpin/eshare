class KnowledgeTestQuestion
  constructor: (@$elm)->
    @kind        = @$elm.find('.question').data('kind')
    @question_id = @$elm.find('.question').data('id')

    if @kind == 'single_choice'
      @setup_single_choice()

    if @kind == 'multiple_choices'
      @setup_multiple_choices()

    if @kind == 'true_false'
      @setup_true_false()

  setup_single_choice: ->
    elm = @$elm
    question_id = @question_id

    elm.delegate '.choices a.choice', 'click', ->
      $choice = jQuery(this)
      value = $choice.data('value')
      
      elm.find('.choices a.choice').removeClass('selected')
      $choice.addClass('selected')

      elm.find('.my-choice .answer').html(value).data('answer', value)
      elm.find('a.submit').removeClass('disabled')

    @init_choice_submit()

  setup_multiple_choices: ->
    elm = @$elm
    question_id = @question_id

    elm.delegate '.choices a.choice', 'click', ->
      $choice = jQuery(this)
      
      $choice.toggleClass('selected')

      values = []
      elm.find('.choices a.choice.selected').each ->
        values.push jQuery(this).data('value')

      if values.length > 0
        value = values.join('')
        elm.find('.my-choice .answer').html(value).data('answer', value)
        elm.find('a.submit').removeClass('disabled')
      else
        elm.find('.my-choice .answer').html('--').data('answer', '')
        elm.find('a.submit').addClass('disabled')

    @init_choice_submit()

  setup_true_false: ->
    elm = @$elm
    question_id = @question_id

    elm.delegate '.choices a.choice', 'click', ->
      $choice = jQuery(this)
      value = $choice.data('value')
      
      elm.find('.choices a.choice').removeClass('selected')
      $choice.addClass('selected')

      elm.find('.my-choice .answer').html(value).data('answer', value)
      elm.find('a.submit').removeClass('disabled')

    @init_choice_submit()

  init_choice_submit: ->
    elm = @$elm
    question_id = @question_id
    elm.delegate 'a.submit:not(.disabled)', 'click', ->
      answer = elm.find('.my-choice .answer').data('answer')
      jQuery.ajax
        url: "/knowledge_test/questions/#{question_id}/submit_answer"
        method: 'POST'
        data:
          result: answer
        success: (res)->
          console.log res
          result = res.result
          if result
            alert('答对了')
          else
            alert('答错了')

  setup: ->

    # @code_inputer = ace.edit("code")
    # @code_inputer.setTheme("ace/theme/twilight")
    # @code_inputer.getSession().setMode("ace/mode/javascript")
    # @code_inputer.getSession().setTabSize(2)


jQuery ->
  jQuery('.page-knowledge-test-question-show').each ->
    new KnowledgeTestQuestion(jQuery(@)).setup()