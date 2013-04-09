$ ->
  $root    = $('.page-content #new_test_question')
  $kind    = $root.find('#test_question_kind')
  $choices = $root.find('.choices')
  $other   = $root.find('.other').remove().clone()
  $true_false = $root.find('.true-false').remove().clone()
  $submit  = $root.find('input[type=submit]')

  $kind.on 'change', ->
    $root.find('.other, .true-false').remove()
    value = $(this).val()
    switch value
      when 'TRUE_FALSE'
        $choices.hide()
        $el = $true_false.clone()
      when 'SINGLE_CHOICE', 'MULTIPLE_CHOICE'
        $choices.show()
        $el = $other.clone()
      when 'FILL'
        $choices.hide()
        $el = $other.clone()

    $submit.before($el.show())