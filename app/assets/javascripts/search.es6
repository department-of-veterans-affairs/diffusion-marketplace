function executePracticeSearch(inputId, formId) {
    const $searchField = $(inputId);
    $searchField.val(''); // clear form
    $(formId).submit(function(e) {
        e.preventDefault();
        var sUrl = `${location.protocol}//${location.host}/search`;
        if(Boolean($searchField.val())){
            sUrl += `?query=${encodeURI($searchField.val())}`;
        }
        window.location = sUrl;
    });
}

// search in navbar
addEventListener('turbolinks:load', function () {
    // search in navbar
    executePracticeSearch('#dm-navbar-search-field', '#dm-navbar-search-form');
    // search on homepage
    executePracticeSearch('#dm-homepage-search-field', '#dm-homepage-search-form');
});

