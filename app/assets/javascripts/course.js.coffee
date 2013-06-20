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


# 选课 - INHOUSE
jQuery ->
  jQuery(document).on 'click', '.page-course-show a.doselect', ->
    course_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/courses/#{course_id}/student_select"
      type : 'post'
      success : (res)=>
        jQuery('.student-select-course').addClass(res.status)

# 课程适用度评价
jQuery ->
  class CourseAttitudeInputer
    constructor: (@$elm)->
      @$ipt = @$elm.find('textarea.ipt')
      @$form = @$elm.find('.form')
      @course_id = @$form.data('id')

      @$editbtn = @$elm.find('.edi a.edit')

      @setup()

    setup: ->
      that = this
      @$elm.find('.faces a.face').on 'click', ->
        $face = jQuery(this)
        that.select($face)

      @$editbtn.on 'click', =>
        $face = @$elm.find('.faces a.face.done')
        that.select($face)

      @$form.find('a.btn.cancel').on 'click', ->
        that.cancel()

      @$form.find('a.btn.submit').on 'click', ->
        that.submit()

    select: ($face)->
      @$elm.find('.edi').slideUp(250)
      @$elm.find('.faces a.face').removeClass('selected')
      $face.addClass('selected')
      @$form.slideDown(250)

    cancel: ->
      @$elm.find('.edi').slideDown(250)
      @$elm.find('.faces a.face').removeClass('selected')
      @$elm.find('.faces a.face.done').addClass('selected')
      @$form.slideUp(250)

    submit: ->
      kind = @$elm.find('.faces a.face.selected').data('kind')
      content = jQuery.trim @$ipt.val()

      @$elm.find('.edi').slideDown(250)
      @$form.slideUp(250)
      @$elm.find('.faces a.face.selected').addClass('done')
      @$editbtn.show()

      jQuery.ajax
        url: "/courses/#{@course_id}/course_attitudes"
        type: 'POST'
        data:
          kind: kind
          content: content
        success: (res)=>
          $new = jQuery(res.html).find('.attitudes')
          $old = @$elm.find('.attitudes')

          $old.after $new
          $old.remove()


  jQuery('.page-course-attitudes-form').each ->
    new CourseAttitudeInputer(jQuery(this))