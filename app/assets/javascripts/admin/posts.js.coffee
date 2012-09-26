$ ->
  $('.wysiyg').wysihtml5()

  $('[data-wysihtml5-command="bold"]').html('b')
  $('[data-wysihtml5-command="italic"]').html('i')
  $('[data-wysihtml5-command="underline"]').html('u')

  $('input[name="new_post"]').click ->
    $('#post_status').attr('value', 'published')
    $("form#new_post").submit()
