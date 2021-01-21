// search in navbar
addEventListener('turbolinks:load', function () {
    const $searchField = $('#dm-navbar-search-field');
    $searchField.val(''); // clear form
    $('#dm-navbar-search-form').submit(function(e) {
        e.preventDefault();
        var sUrl = `${location.protocol}//${location.host}/search`;
        if(Boolean($searchField.val())){
            sUrl += `?query=${encodeURI($searchField.val())}`;
        }
        window.location = sUrl;
    });
});
