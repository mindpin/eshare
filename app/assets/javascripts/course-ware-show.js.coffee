jQuery ->
  class ReadCountUpdater
    constructor: (@$elm)->
      @course_ware_id = @$elm.data('id')
      @$rc = @$elm.find('.rc')

    update: (read_count)=>
      @$rc.html(read_count)

      jQuery.ajax
        url : "/course_wares/#{@course_ware_id}/update_read_count"
        type : 'put'
        data :
          read_count : read_count
        success : (res)=>

    read_count: ->
      parseInt @$rc.html()

  class YoukuVideoPlayer
    constructor: (@$elm)->
      @init()

    init: ->
      html_id = @$elm.attr('id')
      @video_id = html_id.split('-')[1]

      @player = new YKU.Player html_id, {
        vid : @video_id,
        client_id : 'youkuind_'
      }

    total_time: ->
      try
        return parseInt @player.totalTime()
      catch e
        return -1

    current_time: ->
      try
        return parseInt @player.currentTime()
      catch e
        return -1

  class MindpinFlvVideoPlayer
    constructor: (@$elm)->
      @video_url = @$elm.data('url')
      @elm_id = @$elm.attr('id')

      @init()

    init: ->
      flashvars =
        f : @video_url
        p : '0' # 不自动播放
        x : '/' # 必须写成 '/' 才会加载 js 里的配置，为什么不能写成 '' ? 我也不知道为什么
        my_url : encodeURIComponent(window.location.href)
        m : '1'

      params =
        bgcolor : '#FFF'
        allowFullScreen : true
        allowScriptAccess : 'always'

      CKobject.embedSWF('/ckplayer/ckplayer.swf', @elm_id, 'mindpin_ckplayer', '100%', '100%', flashvars, params)
      @player = CKobject.getObjectById('mindpin_ckplayer')

    total_time: ->
      try
        return parseInt @player.ckplayer_getstatus().totaltime
      catch e
        return -1

    current_time: ->
      try
        return parseInt @player.ckplayer_getstatus().time
      catch e
        return -1

  class WebVideoCkPlayer
    constructor: (@$elm)->
      @video_xml_url = "/course_wares/#{@$elm.data('id')}.xml"
      @init()

    init: ->
      flashvars =
        p : '0' # 不自动播放
        x : '/' # 必须写成 '/' 才会加载 js 里的配置，为什么不能写成 '' ? 我也不知道为什么
        my_url : encodeURIComponent(window.location.href)
        f : @video_xml_url
        s : '2'
        m : '1'

      params =
        bgcolor : '#FFF'
        allowFullScreen : true
        allowScriptAccess : 'always'

      CKobject.embedSWF('/ckplayer/ckplayer.swf', @$elm.attr('id'), 'mindpin_ckplayer', '100%', '100%', flashvars, params)
      @player = CKobject.getObjectById('mindpin_ckplayer')

    total_time: ->
      try
        return parseInt @player.ckplayer_getstatus().totaltime
      catch e
        return -1

    current_time: ->
      try
        return parseInt @player.ckplayer_getstatus().time
      catch e
        return -1

  # 此类用来对各种视频源的播放进度记录做一个统一整合
  class MindpinVideoProgressParser
    constructor: (@player, @updater)->
      @start_timer()

      @played_seconds = 0 # 这次播放已经累计播放的秒数
      @current_time   = 0 # 当前播放到的秒数

      @total_time       = -1
      @new_current_time = -1

      @read_count = @updater.read_count()

    start_timer: =>
      timer = setInterval =>
        @total_time   = @player.total_time()
        @new_current_time = @player.current_time()

        # 判断是否在播放
        if @total_time > -1 && @new_current_time > -1 && @new_current_time != @current_time
          @played_seconds += 5
          @current_time = @new_current_time
          # console.log "playing: #{@played}"
          @update_read_count @played_seconds, @total_time
      , 5000 
      # 这里只能写 5000，不能写表达式，我也不知道为什么。。
      # 5000 对应上面的 5

    update_read_count: =>
      return if @read_count >= 1000
      rc = Math.min 1000, @read_count + Math.round(@played_seconds * 1000 / @total_time)

      @updater.update(rc)

# --------------------------

  class PdfWidget
    constructor: (@$elm, @updater)->
      @init()

      @current_page = 1
      @$stat = jQuery('.stat')

      @read_count = @updater.read_count()

      @readed_pages = []

      i = 1
      while i <= @read_count
        @readed_pages.push i
        i++

      console.log @readed_pages

    init: ->
      # 每一张图片大小都一样
      image_height = @$elm.find('.images .image').outerHeight() + 10

      @$elm.on 'scroll', =>
        scrolltop = @$elm.scrollTop()
        mid_top = @$elm.height() / 2

        @current_page = ~~((scrolltop + mid_top) / image_height) + 1

        # console.log scrolltop + mid_top, image_height, @current_page
        # console.log @current_page
        @$stat.find('.page .current').html(@current_page)

      # 每秒检查一次，如果页码有变化，就记录进度
      timer = setInterval =>
        if jQuery.inArray(@current_page, @readed_pages) == -1
          @readed_pages.push @current_page
          if @readed_pages.length > @read_count
            @updater.update(@readed_pages.length)

      , 3000 

  read_count_updater = new ReadCountUpdater jQuery('.widget .stat .read')

  jQuery('.page-video-player').each ->
    elm = jQuery(this)
    if elm.hasClass('web-video')
      player = new WebVideoCkPlayer elm

    if elm.hasClass('flv')
      player = new MindpinFlvVideoPlayer elm

    new MindpinVideoProgressParser player, read_count_updater

  #   player = new YoukuVideoPlayer jQuery(this)
  #   new MindpinVideoProgressParser player

  jQuery('.page-course-ware-show .widget .pages').each ->
    new PdfWidget jQuery(this), read_count_updater