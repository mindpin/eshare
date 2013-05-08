$ ->
  faye_server = "http://#{window.location.host}:8080/faye"

  class Notifier
    constructor: ->
      jQuery.get "/faye_auth", (data)=>
        @user_id = data.user_id
        @subscribers = []

    get_client: ->
      @client ?= new Faye.Client(faye_server)

    get_channel: ->
      "/users/#{@user_id}"

    subscribe: (callback)->
      @subscribers.push @get_client().subscribe(@get_channel(), callback)

  jQuery.getScript(
    "#{faye_server}/client.js",

    (->
      notifier = new Notifier
      notifier.subscribe (message)->
        console.log(message)),

    (-> console.log "无法连接到faye服务器")) 
