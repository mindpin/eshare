jQuery ->
  jQuery('.you-can-answer-only-once a').click ->
    href = jQuery(this).attr('href')
    $answer = jQuery(href) #.find('.tile-body')
    $answer.effect("highlight", {}, 2000)

jQuery('.btn').on 'dragstart', (evt) ->
  evt.preventDefault()

# jQuery('.page-sign .toggle a').click ->
#   $a = jQuery(this)
#   console.log $a

#   if $a.hasClass('sign-in')
#     $a.addClass('active')
#     jQuery('.page-sign .toggle a.sign-up').removeClass('active')
#     jQuery('.page-sign .sign-up-form').fadeOut 100, ->
#       jQuery('.page-sign .sign-in-form').fadeIn 100

#   if $a.hasClass('sign-up')
#     $a.addClass('active')
#     jQuery('.page-sign .toggle a.sign-in').removeClass('active')
#     jQuery('.page-sign .sign-in-form').fadeOut 100, ->
#       jQuery('.page-sign .sign-up-form').fadeIn 100