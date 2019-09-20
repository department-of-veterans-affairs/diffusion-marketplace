$(document).on 'turbolinks:load', (e) ->
  $('.sticky').sticky topSpacing: 45
  $('#dm-practice-nav').sticky {topSpacing: 56, zIndex: 10000, bottomSpacing: 200}

$(document).on 'click', '.scroll-to', (e) ->
  $.scrollTo($(this).data('target'), 500, {offset: {top: -45}})
