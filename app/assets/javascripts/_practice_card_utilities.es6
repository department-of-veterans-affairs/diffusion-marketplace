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

function toggleUnderlineStylingForPracticeCardHeader() {
    const hiddenLinkSelector = '.dm-practice-link-aria-hidden';
    const titleSelector = '.dm-practice-title';
    const underlineClass = 'practice-title-underline';

    $(document).on('mouseenter', hiddenLinkSelector, function() {
        $(this).parent().find(titleSelector).addClass(underlineClass);
    });

    $(document).on('mouseleave', hiddenLinkSelector, function() {
        $(this).parent().find(titleSelector).removeClass(underlineClass);
    });
}

function execPracticeCardFunctions() {
    truncateText();
    toggleUnderlineStylingForPracticeCardHeader();
}

$(document).on('turbolinks:load', execPracticeCardFunctions);
