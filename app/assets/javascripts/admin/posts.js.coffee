$ ->
  $('.wysiyg').wysihtml5()

  $('[data-wysihtml5-command="bold"]').html('b')
  $('[data-wysihtml5-command="italic"]').html('i')
  $('[data-wysihtml5-command="underline"]').html('u')
