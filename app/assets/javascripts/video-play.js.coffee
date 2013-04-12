jQuery ->
  class YoukuVideoPlayer
    constructor: (@$elm)->
      @init()
      @start_timer()

      @current_time = 0
      @total = -1
      @current = -1
      @played = 0

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
            @played = @played + 5
            @current_time = @current
            # console.log 'playing'
            @save_read_progress(@played, @total)
      , 5000

    save_read_progress: (read, total)=>
      return if read >= total
      x = Math.round(read * 1000 / total)
      $stat = jQuery('.video-stat')
      $stat.find('.l').html(x)
      course_ware_id = $stat.data('id')

      jQuery.ajax
        url : "/course_wares/#{course_ware_id}/update_read_count"
        type : 'put'
        data :
          read_count : x
        success : (res)=>



  jQuery('.page-video-player.youku').each ->
    new YoukuVideoPlayer jQuery(this)
    