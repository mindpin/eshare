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

  class VideoMarker
    constructor: (@player)->
      @$inputer = jQuery('.widget .video .mark-inputer')
      @$send = @$inputer.find('a.send')
      @$input = @$inputer.find('input')
      @$marks = jQuery('.widget .video .marks')

      @bind_send_event()
      @set_timer()

    bind_send_event: ->
      @$input.keydown (evt)=>
        if evt.keyCode == 13
          @send_mark()

      @$send.on 'click', @send_mark


    send_mark: =>
      content = jQuery.trim @$input.val()
      position = @player.current_time()

      if content
        course_ware_id = @$send.data('id')

        @$input.prop('disabled', true)
        jQuery.ajax
          url : "/course_wares/#{course_ware_id}/add_video_mark"
          type : 'post'
          data :
            content : content
            position : position
          success : (res)=>
            content = res.content
            user_name = res.user_name
            position = res.position
            avatar_url = res.avatar_url

            $mk = jQuery "<div class='mark' data-position=#{position}>" +
                           "<div class='avatar'>" +
                             "<img class='page-avatar small' src='#{avatar_url}' />" +
                           "</div>" +
                           "<div class='ct'>#{user_name} : #{content}</div>" +
                         "</div>"
            @append_mark($mk)

            @$input.prop('disabled', false).val('')

    set_timer: ->
      last_position = -1
      markstimer = setInterval =>
        position = @player.current_time()
        if position != last_position
          last_position = position

          # 隐藏该隐藏的
          @hide_marks(position)


          # 显示该显示的
          @get_marks_of(position).each (index, elm)=>
            $mk = jQuery(elm)
            @append_mark($mk)
      , 500

    append_mark: ($mk)->
      top = @get_fit_top()

      @$marks.append(
        $mk.show().attr('data-top', top).css
          position : 'absolute'
          top : top
      )

    hide_marks: (current_position)->
      return if current_position < 0

      jQuery(@$marks.find('.mark')).each ->
        $m = jQuery(this)
        mark_position = parseInt $m.data('position')
        $m.fadeOut(500) if current_position < mark_position
        $m.fadeOut(500) if current_position > mark_position + 5

    get_marks_of: (position)->
      return @$marks.find(".mark[data-position=#{position}]")

    get_fit_top: ->
      top = 0
      $visible_marks = @$marks.find('.mark:visible')

      loop
        $showing_mark = @$marks.find(".mark:visible[data-top=#{top}]")
        top = top + 40
        break if $showing_mark.length == 0

      top = top - 40
      top = 360 if top > 360

      return top

  class WebVideoCkPlayer
    constructor: (@$elm)->
      @video_xml_url = "/course_wares/#{@$elm.data('id')}.xml"
      @init()

    init: ->
      flashvars =
        p : '0' # 不自动播放
        x : null # 5月23日之前这里必须写成 '/'，而之后必须写成 '' 或 null，待观察。 
        my_url : encodeURIComponent(window.location.href)
        f : @video_xml_url
        s : '2'
        m : '1'

      params =
        bgcolor : '#FFF'
        allowFullScreen : true
        allowScriptAccess : 'always'
        wmode : 'opaque'

      CKobject.embedSWF('/ckplayer/ckplayer.swf', @$elm.attr('id'), 'mindpin_ckplayer', '100%', '100%', flashvars, params)
      @player = CKobject.getObjectById('mindpin_ckplayer')

      new VideoMarker(this)

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

    init_marks_inputer: ->


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

    if elm.hasClass('local-video')
      player = new WebVideoCkPlayer elm

    new MindpinVideoProgressParser(player, read_count_updater)

  jQuery('.page-course-ware-show .widget .pages').each ->
    new PdfWidget jQuery(this), read_count_updater