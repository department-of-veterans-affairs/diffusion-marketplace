//= require rails-ujs
//= require chartkick
//= require Chart.bundle
//= require active_admin/base

(function() {
    var loadComponents = function() {
        var selects = $('.polyform').parent().siblings('li.select.input').find('.polyselect');
        $.each(selects, function(index, select) {
            return $('#' + $(select).val() + '_poly_' + $(select).data('component-id')).show();
        });
    };

    var ready = function() {
        loadComponents();

        // switches out polymorphic forms in page component
        $(document).on("change", '.polyselect', function() {
            $('.polyform.component-' + $(this).data('component-id')).hide();
            return $('#' + $(this).val() + '_poly_' + $(this).data('component-id')).show();
        });

        // when form is submitted, purges any page component form that is not used on the page
        return $(document).on("submit", 'form', function(e) {
            return $('.polyform').each((function(_this) {
                return function(index, element) {
                    var $e = $(element);
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