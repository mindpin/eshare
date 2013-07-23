jQuery ->

  class PageFileUploader
    constructor: (@$elm, config) ->
      @uploader = new PartUpload(config)
      @uploader_item_class = PageFileUploaderItem

      @on_file_added = config.on_file_added || () ->
      @on_file_success = config.on_file_success || () ->
      @$button = config.button

      @items = [] 
      @setup()

    setup: ->
      @uploader.assign_button @$button

      @uploader.on 'fileAdded', (file) =>
        @add_file(file)
        @uploader.upload()
        @on_file_added(file)

      @uploader.on 'fileProgress', (file) =>
        file.uploader_item.sync_percent() if file.uploader_item

      @uploader.on 'fileSuccess', (file) =>
        @on_file_success(file)

    add_file: (file) =>
      uploader_item = new @uploader_item_class(@$elm, file).init()
      @items.push uploader_item

# -----------------

  class PageFileUploaderItem
    constructor: (@$uploader, @file) ->
      @$elm = @$uploader.find('.list .item.sample').clone().removeClass('sample').show()

    init: ->
      @$elm
        .find('.filename').html(@file.file_name).end()
        .find('.size').html(@file.size_str).end()
      @sync_percent()
      @file.uploader_item = @

      @$uploader.find('.list').append @$elm

      return @

    sync_percent: =>
      @$elm
        .find('.percent').html(@file.percent()).end()
        .find('.bar').css('width', @file.percent()).end()

    mark_success: (func)=>
      setTimeout =>
        @$elm
          .find('.page-progress').addClass('success').removeClass('active').end()
        func() if func
      , 600

# ----------------------
  
  # 资源文件
  new PageFileUploader jQuery('.page-file-uploader'), {
    url : '/upload'
    multiple : true
    button : jQuery('a.media-resource-upload')
    on_file_success : (file) ->

      dir = jQuery('.page-files-index').data('path')
      if dir == '/'
        param_path = "/#{file.file_name}" 
      else 
        param_path = "#{dir}/#{file.file_name}"

      jQuery.ajax
        url : '/disk/create'
        type : 'POST'
        data :
          path : param_path
          file_entity_id : file.file_entity_id
        success : (res)->
          console.log res
          file.uploader_item.mark_success() if file.uploader_item

  }

# ----------------------

  # 课程编辑 - 课件上传
  new PageFileUploader jQuery('.page-file-uploader'), {
    url : '/upload'
    multiple : false
    button : jQuery('a.btn.course-ware-upload')
    on_file_added : (file) ->
      jQuery('.page-course-ware-form .linked').slideUp()
      jQuery('.page-course-ware-form .course-ware-upload').hide()

      fitems = jQuery('.page-file-uploader .item')
      if fitems.length > 2
        jQuery(fitems.get(1)).remove()

      $input = jQuery('input#course_ware_title')
      if $input.val() == ''
        $input.val(file.file_name)

    on_file_success : (file) ->
      jQuery('input#course_ware_file_entity_id').val file.file_entity_id
      file.uploader_item.mark_success() if file.uploader_item

      setTimeout ->
        jQuery('.page-course-ware-form .linked')
          .slideDown()
          .find('.name').html(file.file_name)
        jQuery('.page-course-ware-form .course-ware-upload')
          .show()
          .find('span').html('重新上传')
      , 700
  }

# ------------------------

  if jQuery('.page-account-avatar').length > 0
    _upload_f = ->
      origin_width = null
      origin_height = null
      page_width  = null
      page_height = null
      $img = null
      $pimg = null

      update_preview = (c)->
        if page_width && parseInt(c.w) > 0
          rx = 180 / c.w;
          ry = 180 / c.h;

          $pimg.css
            width      : Math.round(rx * page_width)
            height     : Math.round(ry * page_height)
            marginLeft : - Math.round(rx * c.x)
            marginTop  : - Math.round(ry * c.y)

          jQuery('input[name=cx]').val c.x
          jQuery('input[name=cy]').val c.y
          jQuery('input[name=cw]').val c.w
          jQuery('input[name=ch]').val c.h


      jQuery('.page-account-avatar a.btn.cancel').on 'click', ->
        jQuery('.page-account-avatar .crop-avatars').slideDown(200)
        jQuery('.page-account-avatar .upload .btn').show()
        jQuery('.page-account-avatar .form').hide()
        jQuery('.page-file-uploader .item:not(.sample)').remove()

      jQuery('.page-account-avatar a.btn.submit').on 'click', ->
        jQuery('.page-account-avatar form').submit()


      # 头像上传
      new PageFileUploader jQuery('.page-file-uploader'), {
        url : '/upload'
        multiple : false
        button : jQuery('.page-account-avatar a.btn.avatar-upload')
        on_file_success : (file) ->
          if file.uploader_item
            jQuery('input[name=file_entity_id]').val file.file_entity_id

            file.uploader_item.mark_success =>

              $img = jQuery("<img src='#{file.file_entity_url}' />")
              $pimg = $img.clone()

              $img.hide().fadeIn()
              $img.on 'load', =>
                jQuery('.form-inputs .image').html $img
                jQuery('.form-inputs .preview').html $pimg

                jQuery('.page-account-avatar .crop-avatars').slideUp(200)
                jQuery('.page-account-avatar .upload .btn').hide()
                jQuery('.page-account-avatar .form').show()
              
                setTimeout =>
                  origin_width  = jQuery('.form-inputs .image img').width()
                  origin_height = jQuery('.form-inputs .image img').height()
                  jQuery('input[name=origin_width]').val origin_width
                  jQuery('input[name=origin_height]').val origin_height

                  $img.css('max-width', '100%')

                  $img.Jcrop
                    bgColor: 'black'
                    bgOpacity: 0.4
                    setSelect: [ 0, 0, 180, 180 ]
                    addClass: 'jcrop-dark'
                    bgFade: true
                    aspectRatio: 1
                    onChange: update_preview
                    onSelect: update_preview
                  , ->
                    this.ui.selection.addClass('jcrop-selection');
                    bounds = this.getBounds()
                    page_width = bounds[0]
                    page_height = bounds[1]

                    jQuery('input[name=page_width]').val page_width
                    jQuery('input[name=page_height]').val page_height
                    jQuery('input[name=cx]').val 0
                    jQuery('input[name=cy]').val 0
                    jQuery('input[name=cw]').val 180
                    jQuery('input[name=ch]').val 180
                , 1
      }

    _upload_f()