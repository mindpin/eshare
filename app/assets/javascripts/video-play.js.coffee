jQuery ->
  class YoukuVideoPlayer
    constructor: (@$elm)->
      @init()
      @start_timer()

      @current_time = 0
      @total = -1
      @current = -1

      @played = 0 # 这次播放已经累计播放的秒数
      @read_count = parseInt(jQuery('.video-stat').find('.l').html()) # 目前的阅读进度

      @PERIOD = 5 # 5秒保存一次

    init: ->
      html_id = @$elm.attr('id')
      @video_id = html_id.split('-')[1]

      @player = new YKU.Player html_id, {
        vid : @video_id,
        client_id : 'youkuind_'
      }

      # console.log @player
      window.player = @player

    start_timer: =>
      timer = setInterval =>
        try
          @total = parseInt @player.totalTime()
          @current = parseInt @player.currentTime()

        if @total > -1 && @current > -1
          # 先判断是否在播放
          if @current != @current_time
            @played = @played + @PERIOD
            @current_time = @current
            console.log "playing: #{@played}"
            @update_read_count_by(@played, @total)
      , 5000 
      # 这里只能写 5000，不能写表达式，我也不知道为什么。。

    update_read_count_by: (played, total)=>
      return if @read_count == 1000
      
      rc = Math.min 1000, @read_count + Math.round(played * 1000 / total)

      course_ware_id = jQuery('.video-stat')
        .find('.l').html(rc).end()
        .data('id')

      jQuery.ajax
        url : "/course_wares/#{course_ware_id}/update_read_count"
        type : 'put'
        data :
          read_count : rc
        success : (res)=>



  jQuery('.page-video-player.youku').each ->
    new YoukuVideoPlayer jQuery(this)
    