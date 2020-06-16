function detectIE() {
    return /MSIE|Trident/.test(window.navigator.userAgent);
}
(($) => {
    const $document = $(document);
    function browseHappy() {
        if (detectIE() && !$('.browsehappy').length && window.location.href.split('/').pop() == '') {
            homeChromeEdgeWarningBanner();
        }
    }
    function browseSharkTankHappy() {
        let locationArray = window.location.href.split('/');
        if (detectIE() && !$('.browsehappy').length && locationArray.length === 5 && locationArray[3] === 'competitions' && locationArray[4] === 'shark-tank' ) {
            pageChromeWarningBanner();
        }
    }
    function loadAlerts() {
        browseHappy();
        browseSharkTankHappy();
    }
    $document.on('turbolinks:load', loadAlerts);
})(window.jQuery);
