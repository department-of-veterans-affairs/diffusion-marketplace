addEventListener('turbolinks:load', function () {
    $('#homepageSearchBar').submit(function(e) {
        e.preventDefault();
        Turbolinks.visit(this.action + '?query=' + encodeURI($('#homepage-search-field').val()))
    });
});