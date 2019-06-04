function detectIE() {
    return /MSIE|Trident/.test(window.navigator.userAgent);
}

(($) => {
    const $document = $(document);

    function browseHappy() {
        if (detectIE()) {
        $('#beta-banner').after(`
                <div class="grid-container">
                    <div class="usa-alert usa-alert--warning x1-bottom">
                      <div class="usa-alert__body">
                        <p class="browsehappy">You are using an <strong>outdated</strong> browser. Some features may not be available.
                          To have the best experience, please use <strong>Microsoft Edge</strong>, <strong>Google Chrome</strong>, or <strong>Mozilla Firefox</strong> to browse the Diffusion Marketplace.</p>
                      </div>
                    </div>
                </div>
            `);
        }

    }

    function replaceIcons() {
        // TODO: detect if font awesome is supported?
        if (detectIE()) {
            $('.fa-dollar-sign').text('$');
            $('.fa-wrench').text('Y');
        }
    }

    $document.on('turbolinks:load', browseHappy);
    $document.on('turbolinks:load', replaceIcons);
})(window.jQuery);
