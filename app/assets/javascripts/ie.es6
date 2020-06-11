function detectIE() {
    return /MSIE|Trident/.test(window.navigator.userAgent);
}

(($) => {
    const $document = $(document);

    function browseHappy() {
        if (detectIE() && !$('.browsehappy').length && window.location.href.split('/').pop() == '') {
            $('header').after(`
                <div class="grid-container">
                    <div class="usa-alert usa-alert--warning">
                      <div class="usa-alert__body">
                        <p class="browsehappy">
                            Diffusion Marketplace is not optimized for this browser.
                            Some features may not be available. For the best experience, please use the latest versions of
                            Microsoft Edge or Google Chrome.
                        </p>
                      </div>
                    </div>
                </div>
            `);
        }
    }

    function browseSharkTankHappy() {
        let locationArray = window.location.href.split('/')
        if (detectIE() && !$('.browsehappy').length && locationArray.length === 5 && locationArray[3] === 'competitions' && locationArray[4] === 'shark-tank' ) {
            $('#main-content').prepend(`
                <div class="grid-container grid-row justify-center">
                    <div class="grid-col-12 usa-alert usa-alert--error">
                      <div class="usa-alert__body">
                        <p class="browsehappy">
                            Some links or actions on this page are not supported or optimal on this browser.
                            Please switch to Google Chrome for optimal experience.
                        </p>
                      </div>
                    </div>
                </div>
            `);
        }
    }

    function loadAlerts() {
        browseHappy()
        browseSharkTankHappy()
    }

    $document.on('turbolinks:load', loadAlerts);
})(window.jQuery);
