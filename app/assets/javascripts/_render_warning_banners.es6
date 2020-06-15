function homeChromeEdgeWarningBanner() {
    return $('header').after(`
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

function pageChromeWarningBanner() {
    return $('#main-content').prepend(`
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