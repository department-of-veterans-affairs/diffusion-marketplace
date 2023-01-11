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

function toggleFocusStylingForPracticeTitle() {
    const cardContainerSelector = '.dm-practice-card-container';
    const titleLinkSelector = '.dm-practice-link';
    const focusClass = 'focus-outline';

    function findCardContainerSelector(targetSelector) {
        return $(targetSelector).closest('.dm-practice-card').find(cardContainerSelector);
    }
    $(document).on('focus', titleLinkSelector, function() {
        findCardContainerSelector($(this)).addClass(focusClass);
    });

    $(document).on('focusout', titleLinkSelector, function() {
        findCardContainerSelector($(this)).removeClass(focusClass);
    });
}

function execPracticeCardFunctions() {
    truncateText();
    toggleFocusStylingForPracticeTitle();
}

$(document).on('turbolinks:load', execPracticeCardFunctions);
