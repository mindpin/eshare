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