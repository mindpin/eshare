jQuery ->
  jQuery(document).on 'click', 'a.page-follow.follow', ->
    $btn = jQuery(this)
    user_id = $btn.data('id')
    jQuery.ajax
      url: '/friends/follow'
      type: 'POST'
      data:
        user_id: user_id
      success: ->
        $btn
          .removeClass('follow').addClass('unfollow')
          .html('取消关注')

  jQuery(document).on 'click', 'a.page-follow.unfollow', ->
    $btn = jQuery(this)
    user_id = $btn.data('id')
    jQuery.ajax
      url: '/friends/unfollow'
      type: 'POST'
      data:
        user_id: user_id
      success: ->
        $btn
          .removeClass('unfollow').addClass('follow')
          .html('关注')


jQuery ->
  jQuery(document).on 'click', 'a.page-question-follow.follow', ->
    $btn = jQuery(this)
    question_id = $btn.data('id')
    jQuery.ajax
      url: "/questions/#{question_id}/follow"
      type: 'POST'
      success: ->
        $btn
          .removeClass('follow').addClass('unfollow')
          .html('取消关注')

  jQuery(document).on 'click', 'a.page-question-follow.unfollow', ->
    $btn = jQuery(this)
    question_id = $btn.data('id')
    jQuery.ajax
      url: "/questions/#{question_id}/unfollow"
      type: 'POST'
      success: ->
        $btn
          .removeClass('unfollow').addClass('follow')
          .html('关注')