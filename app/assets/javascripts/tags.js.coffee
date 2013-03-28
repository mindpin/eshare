jQuery ->
  class PageTags
    constructor: ->
      @$elm = jQuery('.page-tags')

      @$tags = @$elm.find('.shower .tags')
      @$ul = @$elm.find('.inputer ul')

      @setup()

    setup: ->
      @$ul.tagit()

      @$elm.find('a.edit').click =>
        @edit()

      @$elm.find('a.btn.no').click =>
        @sync_to_inputer()
        @show()

      @$elm.find('a.btn.yes').click =>
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

    sync_to_inputer: =>
      $new_ul = jQuery("<ul></ul>")

      @$tags.find('.tag').each (index, tagel) =>
        tag = jQuery(tagel).data('name')
        $new_ul.append("<li>#{tag}</li>")

      $new_ul.tagit()

      @$ul.after($new_ul).remove()
      @$ul = $new_ul


    build_tag_elm: (tag) =>
      jQuery("<a href='/tags/file/#{tag}' data-name='#{tag}' class='tag'>#{tag}</a>")


  new PageTags()
