addEventListener('turbolinks:before-visit', function () {
    window['referrer'] = window.location.href
});

addEventListener('turbolinks:load', function () {
    console.log(document.referrer);
    scrollTo(0, 0)
});