// search in navbar
addEventListener('turbolinks:load', function () {
    const $searchField = $('#dm-navbar-search-field')
    $searchField.val('') // clear form
    $('#dm-navbar-search-form').submit(function(e) {
        e.preventDefault();
        window.location = `${location.protocol}//${location.host}/search?query=${encodeURI($searchField.val())}`;
    });
});
