jQuery ->

  class PageFileUploader
    constructor: (@$elm, @uploader_item_class, config) ->
      @uploader = new PartUpload(config)
      @items = [] 
      @setup()

      @on_file_success = config.on_file_success || () ->

    assign_button: ($button) ->
      @uploader.assign_button $button
      @

    setup: ->
      @uploader.on 'fileAdded', (file) =>
        @add_file(file)
        @uploader.upload()

      @uploader.on 'fileProgress', (file) =>
        file.uploader_item.sync_percent() if file.uploader_item

      @uploader.on 'fileSuccess', (file) =>
        @on_file_success(file)

        # param_file_entity_id = file.file_entity_id

        # jQuery.ajax
        #   url : '/disk/create'
        #   type : 'POST'
        #   data :
        #     path : @param_path(file)
        #     file_entity_id : param_file_entity_id
        #   success : (res)->
        #     console.log res
        #     file.uploader_item.mark_success() if file.uploader_item

    add_file: (file) =>
      uploader_item = new @uploader_item_class(@$elm, file).init()
      @items.push uploader_item

    param_path: (file) =>
      dir = jQuery('.page-files-index').data('path')
      return "/#{file.file_name}" if dir == '/'
      return "#{dir}/#{file.file_name}"

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

  pfu = new PageFileUploader(jQuery('.page-file-uploader'), PageFileUploaderItem, {
    url : '/upload'
    multiple : true
  }).assign_button(jQuery('a.upload'))

  pfu1 = new PageFileUploader(jQuery('.page-file-uploader'), PageFileUploaderItem, {
    url : '/upload'
    multiple : true
    on_file_success : (file) ->
      param_file_entity_id = file.file_entity_id
      param_file_name = file.file_name

      $attaches = jQuery('.page-homework-new form .attaches')
      count = $attaches.data('count')

      $f_id   = jQuery("<input type='text' />")
                 .attr('name', "homework[homework_attaches_attributes][#{count}][file_entity_id]")
                 .val(param_file_entity_id)
      $f_name = jQuery("<input type='text' />")
                 .attr('name', "homework[homework_attaches_attributes][#{count}][name]")
                 .val(param_file_name)

      $attaches
        .append($f_id)
        .append($f_name)
        .data('count', count + 1)
  }).assign_button(jQuery('a.btn.homework-attach-upload'))

  pfu2 = new PageFileUploader(jQuery('.page-file-uploader'), PageFileUploaderItem, {
    url : '/upload'
    multiple : false
    on_file_success : (file) ->
      param_file_entity_id = file.file_entity_id
      param_file_name = file.file_name
      param_id = jQuery(file.input_target).closest('.item').data('id')

      jQuery.ajax
        url : "/homework_requirements/#{param_id}/upload"
        type : 'POST'
        data :
          'homework_upload[file_entity_id]' : param_file_entity_id
          'homework_upload[name]' : param_file_name
        success : (res) ->
          console.log res
          file.uploader_item.mark_success() if file.uploader_item

  }).assign_button(jQuery('a.btn.homework-requirement-upload'))