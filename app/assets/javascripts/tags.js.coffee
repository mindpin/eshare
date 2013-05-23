jQuery ->
  class PageTags
    constructor: ->
      @$elm = jQuery('.page-tags')

      @$tags = @$elm.find('.shower .tags')
      @$ul = @$elm.find('.inputer ul')

      @setup()

    setup: ->
      @$ul.tagit
        caseSensitive : false

      @$elm.find('a.edit').click =>
        @edit()

      @$elm.find('a.btn.no').click =>
        @sync_to_inputer()
        @show()

      @$elm.find('a.btn.yes').click =>
        @submit()
        @sync_to_shower()
        @show()

    edit: =>
      @$elm.find('.shower').hide()
      @$elm.find('.inputer').show()

    show: =>
      @$elm.find('.shower').show()
      @$elm.find('.inputer').hide()

    sync_to_shower: =>
      @$tags.empty()

      jQuery(@$ul.tagit('assignedTags')).each (index, tag) =>
        @$tags.append @build_tag_elm(tag)

      @$ul.find('.tagit-new input').val('')

    sync_to_inputer: =>
      $new_ul = jQuery("<ul></ul>")

      @$tags.find('.tag').each (index, tagel) =>
        tag = jQuery(tagel).data('name')
        $new_ul.append("<li>#{tag}</li>")

      $new_ul.tagit()

      @$ul.after($new_ul).remove()
      @$ul = $new_ul

    submit: =>
      tagstr = @$ul.tagit('assignedTags').join(',')
      jQuery.ajax
        url : '/tags/set_tags'
        type : 'PUT',
        data :
          tagable_id : @$elm.data('tagable-id')
          tagable_type : @$elm.data('tagable-type')
          tags : tagstr

    build_tag_elm: (tag) =>
      jQuery("<a href='/tags/file/#{tag}' data-name='#{tag}' class='tag'>#{tag}</a>")

  new PageTags()

jQuery ->
  jQuery('.input.page-form-tag-inputer').each ->
    $inputer = jQuery(this)

    $textarea = $inputer.find('textarea')
    $textarea.val $textarea.data('value')

    console.log 111

    $inputer.find('.tags-advice a.tag').on 'click', (evt)->
      tagname = jQuery(this).data('name')

      val = $textarea.val()
      if jQuery.trim(val) == ''
        $textarea.val(tagname)
        return

      if val.indexOf(tagname) < 0
        $textarea.val("#{val}, #{tagname}")

jQuery ->
  class GridTagBox
    constructor: (@$container)->
      @tags = []
      @weight = 0

      @pleft = 0
      @ptop  = 0
      @pwidth  = 100
      @pheight = 100

    add: (tag)->
      @tags.push tag
      @weight = @weight + tag.weight

    split: ()->
      @_create_children()
      @_split_in_two()

      pa = @box_a.weight * 100 / (@box_a.weight + @box_b.weight)
      pb = 100 - pa

      # if @pwidth * @$container.width() >= @pheight * @$container.height() * 2
      if @pwidth >= @pheight
        @box_a.pwidth = @pwidth * pa / 100
        @box_b.pleft = @pleft + @box_a.pwidth
        @box_b.pwidth = @pwidth - @box_a.pwidth
      else
        @box_a.pheight = @pheight * pa / 100
        @box_b.ptop = @ptop + @box_a.pheight
        @box_b.pheight = @pheight - @box_a.pheight



    _create_children: ->
      @box_a = new GridTagBox(@$container)
      @box_a.clone_pos(this)
      
      @box_b = new GridTagBox(@$container)
      @box_b.clone_pos(this)

    _split_in_two: ->
      jQuery.each @tags, (index, tag)=>
        if @box_a.weight <= @box_b.weight
          @box_a.add tag
        else
          @box_b.add tag

    go: ()->
      if @tags.length < 2
        jQuery.each @tags, (j, tag)=>
          tag.ptop = @ptop
          tag.pleft = @pleft
          tag.pwidth = @pwidth
          tag.pheight = @pheight
        return

      else
        @split()
        @box_a.go()
        @box_b.go()


    render: ->
      jQuery.each @tags, (j, tag)->
        tag.render()

    clone_pos: (box)->
      @ptop = box.ptop
      @pleft = box.pleft
      @pwidth = box.pwidth
      @pheight = box.pheight


  class GridTag
    constructor: (@$elm)->
      @weight = @$elm.data('weight')

      @ptop = 0
      @pleft = 0
      @pwidth = 100
      @pheight = 100

    render: ->
      # @$elm.animate
      @$elm.show().animate
        top : "#{@ptop}%"
        left : "#{@pleft}%"
        width : "#{@pwidth}%"
        height : "#{@pheight}%"

  class PopularTagsGrid
    constructor: (@$elm)->
      @box = new GridTagBox(@$elm)

      @$elm.find('.tag').each (index, $tag)=>
        tag = new GridTag(jQuery($tag))
        @box.add tag

    go: ->
      @box.go()
      @box.render()

  jQuery('.page-popular-tags-grid').each ->
    grid = new PopularTagsGrid(jQuery(this))
    grid.go()

    # jQuery(window).resize ->
    #   grid.go()