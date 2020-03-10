addEventListener('turbolinks:before-visit', function () {
    window['referrer'] = window.location.href;
});

addEventListener('turbolinks:load', function () {
    if (window['referrer'] !== window.location.href) {
        scrollTo(0, 0);
    }
});