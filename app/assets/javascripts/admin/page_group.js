$(document).ready(function() {
  $('#current_pages').sortable({
    items: 'li',
    handle: '.handle',
    update: function(event, ui) {
      $('#current_pages li').each(function(index) {
        $(this).find('input[name*="[position]"]').val(index + 1);
      });
    }
  });
});
