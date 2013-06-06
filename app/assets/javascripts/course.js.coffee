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