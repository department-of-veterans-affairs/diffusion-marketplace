addEventListener('turbolinks:load', function () {
    $('#homepageSearchBar').submit(function(e) {
        e.preventDefault();
        window.location = `${this.action}?query=${encodeURI($('#homepage-search-field').val())}`;
    });
});