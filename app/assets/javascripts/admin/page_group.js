$(document).ready(function() {
  $('#current-pages').sortable({
    items: 'li',
    handle: '.handle',
    axis: 'x',
    update: function(event, ui) {
      $('#current-pages li').each(function(index) {
        $(this).find('input[name*="[position]"]').val(index + 1);
      });
    }
  });
});
