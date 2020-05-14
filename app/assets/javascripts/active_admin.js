//= require rails-ujs
//= require chartkick
//= require Chart.bundle
//= require active_admin/base

(function() {
    var ready;
    console.log('loaded')
    ready = function() {
        console.log('ready')
        $(document).on("change", '.polyselect', function() {
            console.log('showing')
            $('.polyform').hide();
            return $('#' + $(this).val() + '_poly').show();
        });
        return $('.polyform').first().parent('form').on("submit", function(e) {
            return $('.polyform').each((function(_this) {
                return function(index, element) {
                    var $e;
                    $e = $(element);
                    if ($e.css('display') !== 'block') {
                        return $e.remove();
                    }
                };
            })(this));
        });
    };

    $(document).ready(ready);

    $(document).on('turbolinks:load', ready);

}).call(this);