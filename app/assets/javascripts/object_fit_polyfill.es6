// IE11 CSS object-fit polyfill
(($) => {
    const $document = $(document);

    function objectFitCoverForCardsIE(element) {
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
        objectFitCoverForCardsIE('.card-img-container')
    }

    function featuredMarketplaceCardImgIE() {
        objectFitCoverForCardsIE('.featured-card-img-container')
    }

    function objectFitCoverForThumbnailIE(element) {
        if ( !Modernizr.objectfit ) {
            let $container = $(element),
                imgUrl = $container.find('img').prop('src');
            if (imgUrl) {
                $container
                    .css('backgroundImage', 'url(' + imgUrl + ')')
                    .addClass('compat-object-fit');
            }
        }
    }

    function mobileMainDisplayImageIE() {
        objectFitCoverForThumbnailIE('.mobile-main-display-image-container')
    }

    function desktopMainDisplayImageIE() {
        objectFitCoverForThumbnailIE('.desktop-main-display-image-container')
    }

    function initPolyfillFunctions() {
        marketplaceCardImgIE();
        featuredMarketplaceCardImgIE();
        mobileMainDisplayImageIE();
        desktopMainDisplayImageIE();
    }

    $document.on('turbolinks:load', initPolyfillFunctions);
})(window.jQuery);