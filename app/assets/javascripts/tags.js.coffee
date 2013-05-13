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
