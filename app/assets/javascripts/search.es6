function executePracticeSearch(formId) {
    $(formId).submit(function(e) {
        e.preventDefault();
        let searchField = $(e.target).find(".usa-input")
        let sUrl = `${location.protocol}//${location.host}/search`;
        if(searchField.val()) {
            sUrl += `?query=${encodeURI(searchField.val())}`;
        }
        searchField.val(''); // clear form
        window.location = sUrl;
    });
}

addEventListener('turbolinks:load', function () {
    // search in navbar
    executePracticeSearch('#dm-navbar-search-desktop-form');
    // search in mobile navbar
    executePracticeSearch('#dm-navbar-search-mobile-form');
    // search on homepage
    executePracticeSearch('#dm-homepage-search-form');
});

