(($) => {
    const $document = $(document);

    $document.on('submit', '#marketplaceSearchForm', function (e) {
        e.preventDefault();
        const $searchQuery = $('#practice-search-field').val();
        Turbolinks.visit(`/search?query=${$searchQuery}`);
    });

})(window.jQuery);