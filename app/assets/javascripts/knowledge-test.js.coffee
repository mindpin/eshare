class KnowledgeTestQuestion
  constructor: ->

  setup: ->
    @code_inputer = ace.edit("code")
    @code_inputer.setTheme("ace/theme/twilight")
    @code_inputer.getSession().setMode("ace/mode/javascript")
    @code_inputer.getSession().setTabSize(2)


jQuery ->
  new KnowledgeTestQuestion().setup()