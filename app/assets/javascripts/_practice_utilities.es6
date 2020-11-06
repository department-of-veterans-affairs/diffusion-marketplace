function truncateText() {
    $('.practice-title').each(function(index, element) {
        $(element).shave(46);
    });

    $('.practice-card-origin-info').each(function(index, element) {
        $(element).shave(32);
    });
}

$(document).on('turbolinks:load', truncateText);