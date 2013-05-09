jQuery ->
  class FayeChatBar
    constructor: (@$chatbar)->
      @user_id = @$chatbar.data('user-id')
      @user_name = @$chatbar.data('user-name')

      @init()

    init: ->
      @init_chat_box()
      @init_notifier()

    init_chat_box: ->
      @chatbox = new FayeChatBox(this)
      @chatbox.bind @$chatbar.find('.contacts .user')

      that = this
      jQuery(@$chatbar).on 'click', '.contacts .user', (evt)->
        that.chatbox.bind(jQuery(this))

    init_notifier: ->
      host = window.location.host.split(':')[0]
      faye_server_url = "http://#{host}:8080/faye"

      jQuery.getScript "#{faye_server_url}/client.js",
      =>
        notifier = new FayeNotifier(this, faye_server_url)
        notifier.subscribe (message)=>
          # 在这里处理接收到的聊天信息
          @chatbox.append_chatlog message

      =>
        console.log "无法连接到Faye即时聊天服务器"


  class FayeChatBox
    constructor: (@bar)->
      @$ipt = @bar.$chatbar.find('.inputer textarea.ipt')
      @clear_inputer()

      @$chatlog = @bar.$chatbar.find('.chatlog')

      @bar.$chatbar.on 'click', '.inputer a.send', (evt)=>
        @send_message()
      
    bind: ($user_elm)->
       @contact_user_id = $user_elm.data('id')
       @contact_user_name = $user_elm.data('name')

       @bar.$chatbar.find('.chat-box .headbar .contact .name').html(@contact_user_name)

       @request_chatlog()

    send_message: (content)->
      return if !@contact_user_id

      content = @$ipt.val()

      @append_chatlog {
        sender:
          id: @bar.user_id
          name: @bar.user_name
        content: content

      }

      jQuery.ajax
        url: '/short_messages'
        type: 'post'
        data: 
          contact_user_id: @contact_user_id
          content: content
        success: (res)=>
          console.log(res)
          @clear_inputer()

    clear_inputer: ->
      @$ipt.val('')

    request_chatlog: ->
      jQuery.ajax
        url : '/short_messages/chatlog'
        type: 'get'
        data:
          contact_user_id: @contact_user_id
        success: (res)=>
          @$chatlog.html res

    append_chatlog: (message)->
      sender_id = message.sender.id
      sender_name = message.sender.name
      content = message.content

      $html = jQuery [
        "<div class='message'>",
          "<span class='sender'>#{sender_name}</span>",
          "<span>:</span>",
          "<span class='content'>#{content}</span>",
        "</div>"
      ].join('')

      @$chatlog.find('.messages').append $html


  class FayeNotifier
    constructor: (@bar, faye_server_url)->
      @subscribers = []
      @client = new Faye.Client(faye_server_url)
      @channel = "/users/#{@bar.user_id}"

    subscribe: (callback)->
      @subscribers.push @client.subscribe(@channel, callback)

  # ---------------------------------------------------------

  jQuery('.page-chat-bar').each ->
    new FayeChatBar jQuery(this)