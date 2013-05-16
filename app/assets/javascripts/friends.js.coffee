jQuery ->
  jQuery(document).on 'click', 'a.page-follow.follow', (evt)->
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

  jQuery(document).on 'click', 'a.page-follow.unfollow', (evt)->
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