jQuery ->
  jQuery('.page-search-bar .do-search').on 'click', ->
    $a = jQuery(this)
    $input = jQuery('.page-search-bar input[name=q]')
    q = jQuery.trim $input.val()
    if q != ''
      location.href = "/search/#{q}"