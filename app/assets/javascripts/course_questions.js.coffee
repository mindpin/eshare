jQuery ->
  class QuestionWidget
    constructor: (@$questions) ->
      @$form = @$questions.find('form')
      @$input = @$form.find('#question_title')
      @$desc = @$form.find('.question-desc')
      @$form_actions = @$form.find('.form-actions')
      @$list = @$questions.find('.questions-list')

      @opened = false
      @setup()

    setup: ->
      @$input.on 'focus', =>
        @open() if !@opened

      @$form_actions.find('.btn.cancel').on 'click', =>
        @close() if @opened

      @$form_actions.find('.btn.submit').on 'click', =>
        @submit()

      jQuery(document).on 'click', '.questions .questions-list .ops a.delete', (evt)=>
        if confirm('确定要删除吗？')
          qid = jQuery(evt.target).data('id')
          @delete_question(qid)

    open: =>
      @opened = true
      @$desc.slideDown()
      @$form_actions.fadeIn(200)
      @$input.animate
        height : 80

    close: =>
      @opened = false
      @$desc.slideUp()
      @$form_actions.fadeOut(200)
      @$input.animate
        height : 20
      @$input.val('')

    submit: =>
      jQuery.ajax
        url : @$form.attr('action')
        type : 'post'
        data :
          @$form.serialize()
        success : (res)=>
          $new_question = jQuery(res).find('.question').hide().fadeIn()
          @$list.prepend $new_question
          @close()

    delete_question: (qid)=>
      jQuery.ajax
        url : "/questions/#{qid}"
        type : 'delete'
        success : (res)=>
          $q = @$list.find("[data-id=#{qid}]").closest('.question')
          $q.slideUp ->
            $q.remove()

  new QuestionWidget jQuery('.page-course-ware-show .questions')

jQuery ->
  class AnswerEditor
    constructor: (@$answer) ->
      @$edit_btn = @$answer.find('.ops a.btn.edit')
      @$form = @$answer.find('.edit-form form')
      @$edit_cancel_btn = @$form.find('a.btn.cancel')

      @id = @$answer.attr('id').split('-')[1]

      @setup()

    setup: ->
      @$edit_btn.on 'click', =>
        @show()

      @$edit_cancel_btn.on 'click', =>
        @hide()

      @$form.on 'ajax:success', (xhr, data)=>
        $html = jQuery(data.html)
        $new_answer = $html.find('.answer')
        @$answer.after($new_answer)
        @$answer.remove()
        new AnswerEditor($new_answer)

    show: ->
      @$answer.find('.tile-field:not(.edit-form, .creator)').slideUp(250)
      @$form.slideDown(250)

    hide: ->
      @$answer.find('.tile-field').slideDown(250)
      @$form.slideUp(250)
        

  jQuery('.page-question-tree .answers > .answer').each ->
    $answer = jQuery(this)
    if $answer.find('.ops').length > 0
      new AnswerEditor($answer)


jQuery ->
  class QuestionEditor
    constructor: (@$question) ->
      @$edit_btn = @$question.find('.ops a.btn.edit')
      @$form = @$question.find('.edit-form form')
      @$edit_cancel_btn = @$form.find('a.btn.cancel')

      @id = @$question.data('id')

      @setup()

    setup: ->
      console.log @$edit_btn

      @$edit_btn.on 'click', =>
        @show()

      @$edit_cancel_btn.on 'click', =>
        @hide()

      @$form.on 'ajax:success', (xhr, data)=>
        $html = jQuery(data.html)
        $new_question = $html
        @$question.after($new_question)
        @$question.remove()
        new QuestionEditor($new_question)

    show: ->
      @$question.find('.tile-field:not(.edit-form, .creator)').slideUp(250)
      @$form.slideDown(250)

    hide: ->
      @$question.find('.tile-field').slideDown(250)
      @$form.slideUp(250)
        

  jQuery('.page-question-tree .question[data-id]').each ->
    $question = jQuery(this)
    if $question.find('.ops').length > 0
      new QuestionEditor($question)