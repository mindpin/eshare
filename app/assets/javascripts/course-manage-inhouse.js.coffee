# 设置选课人数上限的表单事件相关 INHOUSE
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


jQuery ->
  # 课程管理批准
  jQuery(document).on 'click', '.page-course-applies .course-applies a.accept', ->
    apply_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/manage/applies/#{apply_id}/accept"
      type : 'put'
      success : (res)=>
        $new_tr = jQuery(res.html).find('tr.select_course_apply')
        $old_tr = jQuery(this).closest('tr')
        $old_tr.after $new_tr
        $old_tr.remove()

# 课程管理拒绝
  jQuery(document).on 'click', '.page-course-applies .course-applies a.reject', ->
    apply_id = jQuery(this).data('id')
    jQuery.ajax
      url : "/manage/applies/#{apply_id}/reject"
      type : 'put'
      success : (res)=>
        $new_tr = jQuery(res.html).find('tr.select_course_apply')
        $old_tr = jQuery(this).closest('tr')
        $old_tr.after $new_tr
        $old_tr.remove()