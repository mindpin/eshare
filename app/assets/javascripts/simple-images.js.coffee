# @author ben7th

jQuery ->
  $page_fit_images = jQuery('div.page-fit-image.auto-load[data-src]')
  $page_fit_images.fit_image()

  $wallpaper = $page_fit_images.select('.wallpaper')
  jQuery(window).resize ->
    $wallpaper._fit_image_resize()
  

# 在某个容器中加载其上的由 data-src 声明的图片，
# 并且图片通过调整以最佳自适应容器大小，填满容器同时避免宽高比变化

jQuery.fn.fit_image = ()->
  this.each ->
    $elm = jQuery(this)
      .css('overflow', 'hidden')

    src  = $elm.data('src')
    alt  = $elm.data('alt') || ''

    if !src
      console.log('simple-images: fit_image_load() need data-src attr.')
      return

    $img = jQuery("<img style='display:none;'/>")
      .attr('src', src)
      .attr('alt', alt)
      .bind 'load', ->
        $img.fadeIn(300)
        $elm._fit_image_resize()
      .appendTo($elm.empty().show())

# 计算某容器内图片缩放宽度，高度，左，上偏移值
# 图片通过调整以最佳自适应容器大小，填满容器同时避免宽高比变化
# 分两步走：
#   1 如果宽度不等，调齐宽度，计算高度
#   2 如果此时高度不足，补齐高度
# 最后调整左偏移和上偏移

jQuery.fn._fit_image_resize = ->
  this.each ->
    $elm = jQuery(this)

    $img = $elm.find('img')
    return if !$img.length > 0

    box_width  = $elm.width()
    box_height = $elm.height()

    img_width  = $img.width()
    img_height = $img.height()

    # step 1 如果宽度不等，调齐宽度，计算高度
    w1 = box_width
    if img_width != box_width
      h1 = img_height * box_width / img_width
    else
      h1 = img_height
    
    # step 2 如果此时高度不足，补齐高度
    if h1 < box_height
      rh = box_height
      rw = w1 * box_height / h1
    else
      rh = h1
      rw = w1

    # set position
    left = (box_width  - rw) / 2
    top  = (box_height - rh) / 2

    $img
      .css('width', rw)
      .css('height', rh)
      .css('margin-left', left)
      .css('margin-top', top)