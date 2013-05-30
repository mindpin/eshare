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

# 登录表单
jQuery ->
  class AuthInfo
    constructor: ()->
      @$infobox = jQuery('.page-sign .sign-res-info')

    clear: ->
      @$infobox.removeClass('success').find('.info:visible').remove()
      return @

    add: (info)->
      $info = @$infobox.find('.info').first().clone().show()
      $info.find('span').html(info)
      @$infobox.append($info)
      return @

    show: ->
      @$infobox.slideDown(200)
      return @

    success: ->
      @clear()
      @$infobox.addClass('success').find('.info.ok').show()
      @show()

      return @


  jQuery('.page-sign .sign-in-form').on 'ajax:error', (evt, xhr)->
    info = xhr.responseText
    new AuthInfo().clear().add(info).show()

  jQuery('.page-sign .sign-in-form').on 'ajax:success', (evt, xhr)->
    new AuthInfo().success()
    window.location.href = '/'

  jQuery('.page-sign .sign-up-form').on 'ajax:error', (evt, xhr)->
    infos = jQuery.parseJSON(xhr.responseText)
    ai = new AuthInfo().clear()
    jQuery.each infos, (index, info)->
      ai.add(info)
    ai.show()

  jQuery('.page-sign .sign-up-form').on 'ajax:success', (evt, xhr)->
    new AuthInfo().success()
    window.location.href = '/'