(($) => {
    const $document = $(document);

    function execPageBuilderFunctions() {
        replaceImagePlaceholders();
    }

    $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);
