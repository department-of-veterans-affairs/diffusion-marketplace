function truncateOnArrive(arrivingEle, shaveHeight) {
    $(document).arrive(arrivingEle, function(newElem) {
        $(newElem).shave(shaveHeight);
    });
}

function truncateText() {
    $('.dm-practice-title').each(function(index, element) {
        $(element).shave(55);
    });
    truncateOnArrive('.dm-practice-title', 55);

    $('.dm-practice-card-origin-info').each(function(index, element) {
        $(element).shave(35);
    });
    truncateOnArrive('.dm-practice-card-origin-info', 35);

    $('.practice-card-tagline').each(function(index, element) {
        $(element).shave(120)
    });
    truncateOnArrive('.practice-card-tagline', 120);
}

$(document).on('turbolinks:load', truncateText);
