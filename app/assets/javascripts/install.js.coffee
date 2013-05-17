jQuery ->
  $import = jQuery('.page-import')
  return false if $import.length == 0

  $info = $import.find('.import-info')
  importurl = $import.data('importurl')

  # faye
  host = window.location.host.split(':')[0]
  faye_server_url = "http://#{host}:8080/faye"
  jQuery.getScript "#{faye_server_url}/client.js",
  =>
    notifier = new Faye.Client(faye_server_url)
    notifier.subscribe "/cmd", (message)=>
      $info.append(message.output)

      count = $info[0].scrollHeight
      $info.animate({
         scrollTop: count 
      }, 50);

  =>
    console.log "无法连接到Faye即时聊天服务器"


  # 点击事件
  $import.find('a.import').on 'click', ->
    $info.show().append("<span style='color:white;'>正在导入....</span><br />")
    $import.find(".import-action").hide()
    jQuery.ajax
      url : importurl
      type : 'POST'
      success : (res)->
        $info.append("<span style='color:white;'>导入完成！</span>")
        $import.find(".submit").show()



