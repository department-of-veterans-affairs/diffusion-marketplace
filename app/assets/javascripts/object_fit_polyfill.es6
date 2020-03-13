// IE11 CSS object-fit polyfill
(($) => {
    const $document = $(document);

function objectFitCoverForIE() {
    if ( !Modernizr.objectfit ) {
        $('.featured-card-img-container').each(function () {
            let $container = $(this),
                imgUrl = $container.find('img').prop('src');
            if (imgUrl) {
                $container
                    .css('backgroundImage', 'url(' + imgUrl + ')')
                    .addClass('compat-object-fit');
            }
        });

        $('.card-img-container').each(function () {
            let $container = $(this),
                imgUrl = $container.find('img').prop('src');
            if (imgUrl) {
                $container
                    .css('backgroundImage', 'url(' + imgUrl + ')')
                    .addClass('compat-object-fit');
            }
        });
    }
}

    $document.on('turbolinks:load', objectFitCoverForIE);
})(window.jQuery);