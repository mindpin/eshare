class KnowledgeTestQuestionNoteEditor
  constructor: (@$elm)->
    @$question   = @$elm.find('.question')
    @kind        = @$question.data('kind')
    @question_id = @$question.data('id')

    @$note_btn = @$elm.find('.question-ops a.add-note')

    @setup()

    @code_inputers = {}

    # @$elm.find('.note .code pre').each ->
    #   code_inputer = ace.edit this
    #   code_inputer.setTheme("ace/theme/twilight")
    #   code_inputer.getSession().setMode("ace/mode/javascript")
    #   code_inputer.getSession().setTabSize(2)


  cache_code_inputer: (rnd, inputer)->
    if inputer
      @code_inputers[rnd] = inputer
    
    return @code_inputers[rnd]

  submit_note: ($editor)->
    text = $editor.find('textarea').val()
    code_inputer = @cache_code_inputer $editor.find('pre.code').data('rnd')
    if code_inputer
      code = code_inputer.getSession().getValue()
    file_entity_id = ''

    jQuery.ajax
      url: '/knowledge_test/notes'
      method: 'POST'
      data:
        question_id: @question_id
        text: text
        code: code
        file_entity_id: file_entity_id
      success: (res)->
        $new_note = jQuery(res.html).find('.note').hide()
        $editor.before $new_note.fadeIn()
        $editor.find('textarea').val('')
        code_inputer.getSession().setValue('')
        $editor.find('pre.code').parent().hide()

  setup: ->
    # @$note_btn.on 'click', =>
    #   jQuery.ajax
    #     url: '/knowledge_test/notes'
    #     data:
    #       question_id: @question_id
    #     success: (res)->
    #       console.log res

    that = @

    # 增加笔记
    @$elm.delegate '.notes .editor textarea', 'keypress', (evt)->
      if evt.ctrlKey && evt.which == 13 || evt.which == 10
        that.submit_note $editor = jQuery(this).closest('.editor')

    @$elm.delegate '.notes a.submit', 'click', ->
      that.submit_note $editor = jQuery(this).closest('.editor')

    # 删除笔记
    @$elm.delegate '.notes .note a.remove', 'click', ->
      if confirm '你确定要删除这条笔记吗？'
        $note = jQuery(this).closest('.note')
        note_id = $note.data('id')
        jQuery.ajax
          url: "/knowledge_test/notes/#{note_id}"
          method: 'DELETE'
          success: (res)->
            $note.slideUp -> $note.remove()

    # 添加代码
    @$elm.delegate '.notes .editor a.code', 'click', ->
      $pre_code = jQuery(this).closest('.editor').find('pre.code')
      code_inputer = ace.edit $pre_code[0]
      code_inputer.setTheme("ace/theme/twilight")
      code_inputer.getSession().setMode("ace/mode/javascript")
      code_inputer.getSession().setTabSize(2)
      $pre_code.parent().fadeIn()

      rnd = Math.random()
      $pre_code.data('rnd', rnd)
      that.cache_code_inputer rnd, code_inputer


class KnowledgeTestQuestion
  constructor: (@$elm)->
    @$question   = @$elm.find('.question')
    @kind        = @$question.data('kind')
    @question_id = @$question.data('id')

    @$answer = @$elm.find('.my-choice .answer')
    @$submit = @$elm.find('a.submit')

    @$loading = jQuery("<i class='icon-spinner icon-spin'>")

    # @animation()

    if @kind == 'single_choice'
      @setup_single_choice()

    if @kind == 'multiple_choices'
      @setup_multiple_choices()

    if @kind == 'true_false'
      @setup_true_false()

    if @kind == 'code'
      @setup_code()

  # animation: ->
  #   @$elm.find('.choices a.choice')
  #     .css
  #       position: 'relative'
  #       left: 200
  #       opacity: 0
  #     .animate
  #       left: 0
  #       opacity: 1

  _clear_selected: ->
    @$elm.find('.choices a.choice').removeClass('selected')

  set_answer: (answer)->
    if answer == ''
      @$answer.addClass('no').html('未选').data('answer', '')
      @$submit.addClass('disabled')
    else
      @$answer.removeClass('no').html(answer).data('answer', answer)
      @$submit.removeClass('disabled')

    if @kind == 'true_false'
      if answer == 'T'
        @$answer.html jQuery('<i>').addClass('icon-ok')
      if answer == 'F'
        @$answer.html jQuery('<i>').addClass('icon-remove')

  setup_single_choice: ->
    elm = @$elm
    that = @

    elm.delegate '.choices a.choice', 'click', ->
      $choice = jQuery(this)
      value = $choice.data('value')
      
      that._clear_selected()
      $choice.addClass('selected')

      that.set_answer(value)

    @init_choice_submit()

  setup_multiple_choices: ->
    elm = @$elm
    that = @

    elm.delegate '.choices a.choice', 'click', ->
      $choice = jQuery(this)
      $choice.toggleClass('selected')

      values = []
      elm.find('.choices a.choice.selected').each ->
        values.push jQuery(this).data('value')

      that.set_answer values.join('')

    @init_choice_submit()

  setup_true_false: ->
    @setup_single_choice()

  init_choice_submit: ->
    elm = @$elm
    that = @
    elm.delegate '.question a.submit:not(.disabled)', 'click', ->
      answer = elm.find('.my-choice .answer').data('answer')
      jQuery.ajax
        url: "/knowledge_test/questions/#{that.question_id}/submit_answer"
        method: 'POST'
        data:
          result: answer
        beforeSend: ->
          that.$submit.hide()
          that.$submit.after that.$loading
        success: (res)->
          that.$loading.remove()
          console.log res
          result = res.result
          if result
            that.show_correct_res()
          else
            that.show_error_res()

  setup_code: ->
    @code_inputer = ace.edit("code")
    @code_inputer.setTheme("ace/theme/twilight")
    @code_inputer.getSession().setMode("ace/mode/javascript")
    @code_inputer.getSession().setTabSize(2)

  show_correct_res: ->
    @$question.addClass('answered')
    @$elm.find('.result-response').hide()
      .find('.error').hide().end()
      .find('.correct').show().end()
      .slideDown(150)

  show_error_res: ->
    @$question.addClass('answered')
    @$elm.find('.result-response').hide()
      .find('.error').show().end()
      .find('.correct').hide().end()
      .slideDown(150)

jQuery ->
  jQuery('.page-knowledge-test-question-show').each ->
    new KnowledgeTestQuestion(jQuery(@))
    new KnowledgeTestQuestionNoteEditor(jQuery(@))