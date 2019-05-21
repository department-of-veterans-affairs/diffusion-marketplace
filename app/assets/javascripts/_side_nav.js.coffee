$(document).on 'turbolinks:load', (e) ->
  $('.sticky').sticky topSpacing: 45
  $('#dm-practice-nav').sticky topSpacing: 45

$(document).on 'click', '.scroll-to', (e) ->
  $.scrollTo($(this).data('target'), 500, {offset: {top: -45}})
