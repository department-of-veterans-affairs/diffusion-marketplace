addEventListener('turbolinks:load', function () {
    const $searchField = $('#practice-search-field')
    $searchField.val('') // clear form
    $('#practice-search-form').submit(function(e) {
        e.preventDefault();
        window.location = `${location.protocol}//${location.host}/search?query=${encodeURI($searchField.val())}`;
    });
});
