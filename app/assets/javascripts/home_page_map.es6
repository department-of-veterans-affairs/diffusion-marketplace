(($) => {
    const $document = $(document);



    $document.on('turbolinks:load', homePageMap);
})(window.jQuery);

function homePageMap(markers) {
    if (location.pathname !== '/') return;



}
