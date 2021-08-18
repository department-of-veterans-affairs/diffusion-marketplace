# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.es6.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.practice-form-submit', (e) ->
  $('form.usa-form').submit();

$(document).on 'turbolinks:load', (e) ->
  $('.tooltip').tooltip();
