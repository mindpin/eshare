# ben7th
# 参考 https://raw.github.com/23/resumable.js/master/resumable.js 编写

class PartUpload
  constructor: (config) ->
    @url       = config.url || '/'
    @blob_size = config.blob_size || 524288 #1024*512

    # 是否允许多文件
    @multiple  = config.multiple
    @multiple  = false if null == @multiple

    @files = []
    @events = []

  fire: ->
    # `arguments` is an object, not array, in FF, so:
    args = (arg for arg in arguments)

    # Find event listeners, and support pseudo-event `catchAll`
    event = args[0].toLowerCase()
    
    for i in [0...@events.length] by 2
      @events[i + 1].apply(@, args.slice(1)) if @events[i] == event
      @events[i + 1].apply(null, args) if @events[i] == 'catchall'


    @fire('error', args[2], args[1]) if event == 'fileerror'
    @fire('progress') if event == 'fileprogress'

  # EVENTS
  # catchAll(event, ...)
  # fileSuccess(file), fileProgress(file), fileAdded(file), fileRetry(file), fileError(file, message),
  # complete(), progress(), error(message, file), pause()
  on: (event, callback) ->
    @events.push(event.toLowerCase(), callback)

  assign_button: ($doms) ->
    # 可以传一般 dom 或者 jQuery 对象
    $doms = [$doms] if typeof($doms.length) == 'undefined'

    jQuery($doms).each (index, $dom) =>
      if $dom.tagName == 'INPUT' && $dom.type == 'file'
        input = $dom
      else
        input = document.createElement('input')
        input.setAttribute('type', 'file')
        # Place <input /> with the dom node an position the input to fill the entire space
        $dom.style.display = 'inline-block'
        $dom.style.position = 'relative'
        input.style.position = 'absolute'
        input.style.top = input.style.right = 0
        input.style.left = 'auto'
        input.style.fontSize = '28px'
        input.style.opacity = 0
        input.style.cursor = 'pointer'
        $dom.appendChild(input)

      if @multiple
        input.setAttribute('multiple', 'multiple')
      else
        input.removeAttribute('multiple')

      # When new files are added, simply append them to the overall list
      input.addEventListener 'change', (e) =>
        @append_files_from_file_list(e.target)
        e.target.value = ''
      , false

      # if(isDirectory){
      #   input.setAttribute('webkitdirectory', 'webkitdirectory');
      # } else {
      #   input.removeAttribute('webkitdirectory');
      # }

  append_files_from_file_list: (input_target) =>
    filelist = input_target.files
    files = []
    jQuery(filelist).each (index, file) =>
      if file.size > 0
        f = new ResumableFile(@, file)
        f.input_target = input_target 
        # 为了适应这种情况：页面上有许多的上传按钮
        # 需要根据每个上传按钮所处的dom位置，获取上传后的回调中
        # 所需的参数

        @files.push f
        files.push f
        @fire('fileAdded', f)

    @fire('filesAdded', files)

  is_uploading: ->
    uploading = false

    jQuery(@files).each (i, file) =>
      jQuery(file.chunks).each (j, chunk) =>
        # 全部 chunk 都检查一遍，如果有 uploading 中的 chunk，则认为正在 uploading
        # 第一次调用的时候，肯定都是 pending
        if chunk.status() == 'uploading'
          uploading = true
          return false # break for each 
      return false if uploading

    return uploading

  upload: ->
    # Make sure we don't start too many uploads at once
    return if @is_uploading()
    # Kick off the queue
    @upload_next_chunk()

  upload_next_chunk: ->
    found = false

    # Now, simply look for the next, best thing to upload
    jQuery(@files).each (i, file) =>
      jQuery(file.chunks).each (j, chunk) =>
        if chunk.status() == 'pending' && chunk.preprocess_state == 0 # 0 = unprocessed
          chunk.send()
          found = true
          return false
      return false if found
    return true if found

    # The are no more outstanding chunks to upload, check is everything is done
    outstanding = false
    jQuery(@files).each (i, file) =>
      outstanding = false
      jQuery(file.chunks).each (j, chunk) =>
        status = chunk.status()
        if status == 'pending' || status == 'uploading' || chunk.preprocess_state == 1 # 1 = processing
          outstanding = true
          return false
      return false if outstanding
    @fire('complete') if !outstanding
    return false


class ResumableFile
  constructor: (@part_upload_obj, @file) ->
    @_prev_progress = 0

    @file_name = file.fileName||file.name
    @size = file.size
    @relative_path = file.webkitRelativePath || @file_name

    @file_entity_id = null
    @saved_size = 0

    @error = false
    @bootstrap()

  # 用于执行 chunk send 后的回调
  chunk_event: (event, message) =>
    # event can be 'progress', 'success', 'error' or 'retry'
    switch event
      when 'progress'
        @part_upload_obj.fire('fileProgress', @)
        break
      when 'error'
        @abort()
        @error = true
        @chunks = []
        @part_upload_obj.fire('fileError', @, message)
        break
      when 'success'
        return if @error
        @set_some_info_from_json(message)
        @part_upload_obj.fire('fileProgress', @)
        if @progress() == 1
          @part_upload_obj.fire('fileSuccess', @, message)
        break
      when 'retry'
        @part_upload_obj.fire('fileRetry', @)
        break

  set_some_info_from_json: (json_string) ->
    json = jQuery.parseJSON json_string
    @file_entity_id = json.file_entity_id
    @saved_size = json.saved_size
    console.log json
    # 可能需要捕捉异常？

  bootstrap: ->
    @abort()
    @error = false
    @chunks = []
    @_prev_progress = 0
    round = Math.ceil # 最后一块较小的方式，如果是最后一块较大，要用 Math.floor

    blob_count = Math.max(round(@file.size / @part_upload_obj.blob_size), 1)
    for offset in [0...blob_count]
      @chunks.push new ResumableChunk(@part_upload_obj, @, offset, @chunk_event)

  abort: ->
    jQuery(@chunks).each (index, chunk) =>
      chunk.abort() if chunk.status() == 'uploading'
    @part_upload_obj.fire('fileProgress', @)

  progress: ->
    return 1 if @error
    # Sum up progress across everything
    ret = 0
    error = false
    jQuery(@chunks).each (i, c) ->
      error = true if c.status() == 'error'
      ret += c.progress(true) # get chunk progress relative to entire file
    ret = if error then 1 else if ret > 0.999 then 1 else ret
    # console.log('hahaah', ret)

    ret = Math.max @_prev_progress, ret # We don't want to lose percentages when an upload is paused
    @_prev_progress = ret
    return ret

  percent: =>
    return "#{new Number(@progress() * 100).toFixed(1)}%"

  size_str: =>
    return "#{@size}B" if @size < 1024
    return "#{new Number(@size/1024).toFixed(1)}K" if @size < 1048576
    return "#{new Number(@size/1048576).toFixed(1)}M" if @size < 1073741824
    return "#{new Number(@size/1073741824).toFixed(1)}G"

class ResumableChunk
  constructor: (@part_upload_obj, @file_obj, @offset, @callback) ->
    @file_obj_size = @file_obj.size
    @last_progress_callback = new Date
    @retries = 0
    @preprocess_state = 0 # 0 = unprocessed, 1 = processing, 2 = finished

    @start_byte = @offset * @part_upload_obj.blob_size
    @end_byte = Math.min(@file_obj_size, (@offset + 1) * @part_upload_obj.blob_size)
    # the last chunk will be smaller than the chunk size

    # 最后一个 chunk 设置为较大的处理方式，暂时不用
    # if @file_obj_size - @end_byte < @part_upload_obj.blob_size
    #   # The last chunk will be bigger than the chunk size, but less than 2*chunkSize
    #   @end_byte = @file_obj_size;

    @xhr = null

  status: ->
    # Returns: 'pending', 'uploading', 'success', 'error'
    if @file_obj.saved_size >= @end_byte
      # 这一小块已经被服务器接收过
      return 'success'
    
    if !@xhr
      return 'pending'
    else if @xhr.readyState < 4
      # Status is really 'OPENED', 'HEADERS_RECEIVED' or 'LOADING' - meaning that stuff is happening
      return 'uploading'
    else
      if @xhr.status == 200
        # HTTP 200, perfect
        return 'success'
      else if @xhr.status == 415 || @xhr.status == 500 || @xhr.status == 501
        # HTTP 415/500/501, permanent error
        return 'error'
      else
        # this should never happen, but we'll reset and queue a retry
        # a likely case for this would be 503 service unavailable
        @abort()
        return 'pending'

  message: ->
    return if @xhr then @xhr.responseText else ''

  abort: ->
    # Abort and reset
    @xhr.abort() if @xhr
    @xhr = null

  send: ->
    @xhr = new XMLHttpRequest()

    # Progress
    @xhr.upload.addEventListener 'progress', (e) =>
      if (new Date) - @last_progress_callback > 500
        @callback 'progress'
        @last_progress_callback = new Date
      @loaded = e.loaded || 0
    , false
    @loaded = 0
    @callback 'progress'

    # Done (either done, failed or retry)
    handler = (e) =>
      status = @status()
      # console.log "send response: #{status}"
      if status == 'success' || status == 'error'
        @callback status, @message() # 出错的 file_obj 其 chunks 将被清空
        @part_upload_obj.upload_next_chunk()
      else
        @callback 'retry', @message()
        @abort()
        @retries++
        @send()

    @xhr.addEventListener 'load', handler, false
    @xhr.addEventListener 'error', handler, false

    f = @file_obj.file

    if f.slice
      bytes = f.slice(@start_byte, @end_byte)
    else if f.mozSlice
      bytes = f.mozSlice(@start_byte, @end_byte)
    else if f.webkitSlice
      bytes = f.webkitSlice(@start_byte, @end_byte)
    else
      bytes = f.slice(@start_byte, @end_byte)

    url = @part_upload_obj.url

    # Add data from the query options
    data = new FormData()
    data.append 'file_name', f.name
    data.append 'file_size', f.size
    data.append 'start_byte', @start_byte

    file_entity_id = @file_obj.file_entity_id
    data.append('file_entity_id', file_entity_id) if file_entity_id

    data.append 'blob', bytes
    @xhr.open('POST', url) 
    @xhr.send(data)

  progress: (relative) ->
    relative = false if typeof(relative) == 'undefined'
    factor = if relative then (@end_byte - @start_byte) / @file_obj_size else 1
    s = @status()

    switch s
      when 'success', 'error'
        return factor
      when 'pending'
        return 0
      else
        return @loaded / (@end_byte - @start_byte) * factor


window.PartUpload = PartUpload
window.ResumableFile = ResumableFile
window.ResumableChunk = ResumableChunk