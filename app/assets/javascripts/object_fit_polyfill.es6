// IE11 CSS object-fit polyfill
(($) => {
    const $document = $(document);

    function objectFitCoverForIE(element) {
        if ( !Modernizr.objectfit ) {
            $(element).each(function () {
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

    function marketplaceCardImgIE() {
        objectFitCoverForIE('.card-img-container')
    }

    function featuredMarketplaceCardImgIE() {
        objectFitCoverForIE('.featured-card-img-container')
    }

    function mainDisplayImageIE() {
        objectFitCoverForIE('.mobile-main-display-image-container')
    }

    function initPolyfillFunctions() {
        marketplaceCardImgIE();
        featuredMarketplaceCardImgIE();
        mainDisplayImageIE();
    }

    $document.on('turbolinks:load', initPolyfillFunctions);
})(window.jQuery);