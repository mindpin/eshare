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

    mark_success: =>
      setTimeout =>
        @$elm
          .find('.page-progress').addClass('success').removeClass('active').end()
      , 700

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