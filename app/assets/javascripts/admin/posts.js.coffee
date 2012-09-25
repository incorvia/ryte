$ ->
  $('.wysiyg').wysihtml5({
    "font-styles": true
    "html": true, #Button which allows you to edit the generated HTML. Default false
  })
  $('[data-wysihtml5-command="bold"]').html('b')
  $('[data-wysihtml5-command="italic"]').html('i')
  $('[data-wysihtml5-command="underline"]').html('u')



