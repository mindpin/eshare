jQuery ->

  class PageFileUploader
    constructor: (@$elm, config) ->
      @uploader = new PartUpload(config)

      @_sample_item = null
      @items = [] 
      @setup()

      @uploader.assign_button jQuery('a.upload')

    setup: ->
      @_sample_item = @$elm.find('.list .item.sample')

      @uploader.on 'fileAdded', (file) =>
        @add_file(file)
        @uploader.upload()

      @uploader.on 'fileProgress', (file) =>
        file.uploader_item.sync_percent() if file.uploader_item

      @uploader.on 'fileSuccess', (file) =>
        param_file_entity_id = file.file_entity_id

        jQuery.ajax
          url : '/disk/create'
          type : 'POST'
          data :
            path : @param_path(file)
            file_entity_id : param_file_entity_id
          success : (res)->
            console.log res
            file.uploader_item.mark_success() if file.uploader_item

    add_file: (file) =>
      uploader_item = new PageFileUploaderItem(@, file).init()
      @items.push uploader_item
      @$elm.find('.list').append uploader_item.$elm

    param_path: (file) =>
      dir = jQuery('.page-files-index').data('path')
      return "/#{file.file_name}" if dir == '/'
      return "#{dir}/#{file.file_name}"

  class PageFileUploaderItem
    constructor: (@uploader, @file) ->
      @$elm = @uploader._sample_item.clone().removeClass('sample').show()

    init: ->
      @$elm
        .find('.filename').html(@file.file_name).end()
        .find('.size').html(@file.size_str).end()
      @sync_percent()

      @file.uploader_item = @
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


  pfu = new PageFileUploader jQuery('.file-uploader'), {
    url : '/upload'
    multiple : true
  }