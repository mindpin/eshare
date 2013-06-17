# aj方式，暂时用不上
jQuery ->
  class CourseManager
    constructor: (@$elm)->
      @setup()
      @current_chapter_id = null

    setup: ->
      jQuery(document).on 'click', '.chapters a.chapter', (evt)=>
        jQuery.pjax.click evt, '#pjax-container'
        @current_chapter_id = jQuery(evt.target).data('id')

      jQuery(document).on 'click', 'a.add-chapter', (evt)=>
        jQuery.pjax.click evt, '#pjax-container'
        @current_chapter_id = null

      jQuery(document).on 'submit', 'form', (evt)=>
        # jQuery.pjax.submit evt, '#pjax-container'

      jQuery(document).on 'pjax:complete', =>
        jQuery('a.chapter').removeClass('current')

        if @current_chapter_id
          jQuery("a.chapter[data-id=#{@current_chapter_id}]").addClass('current')

  jQuery('.page-course-manage-aj').each ->
    new CourseManager jQuery(this)


jQuery ->
  class CourseForm
    constructor: (@$form)->
      @setup()

    setup: ->
      that = @
      jQuery(@$form).on 'click', '#course_enable_apply_request_limit', ->
        $checkbox = jQuery(this)
        if $checkbox.is(':checked')
          that.show_limit()
        else
          that.hide_limit()

    show_limit: ->
      @$form.find('.limit-inputer').fadeIn(200).find('input').val('')

    hide_limit: ->
      @$form.find('.limit-inputer').fadeOut(200).find('input').val('')


  jQuery('.page-course-form form').each ->
    new CourseForm jQuery(this)