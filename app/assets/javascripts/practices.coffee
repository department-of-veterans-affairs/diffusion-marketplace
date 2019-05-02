# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.dm-tab', (e) ->
  e.preventDefault();
  if !$(this).hasClass('usa-current')
    $(this).parents('ul.dm-tabnav').find('.usa-current').removeClass('usa-current')
    $(this).addClass('usa-current')

    target = $($(this).data('target'))
    target.siblings('.tab-active').removeClass('tab-active').addClass('tab-inactive')
    target.removeClass('tab-inactive').addClass('tab-active')

$(document).on 'click', '.dm-carousel-nav', (e) ->
  e.preventDefault()
  $(this).parents('.dm-carousel').toggle('slide')
  $($(this).data('target')).toggle('slide')

$(document).on 'click', '.practice-form-submit', (e) ->
  $('form.usa-form').submit();

# $(document).on 'turbolinks:load', (e) ->
#   init_papercrop();
