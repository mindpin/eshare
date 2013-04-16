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

# ------------------------
# 课程签到
jQuery ->
  jQuery('.page-course-show a.checkin').on 'click', ->
    course_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/courses/#{course_id}/checkin"
      type : 'post'
      success : (res)=>
        jQuery('.user-course-checkin')
          .addClass('signed')
          .find('.count').html(res.streak).end()
          .find('.order').html(res.order).end()