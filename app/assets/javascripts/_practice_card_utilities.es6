
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
        $(element).shave(39);
    });
    truncateOnArrive('.dm-practice-card-origin-info', 39);

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

function replaceImagePlaceholders() {
    $('.dm-practice-card').each(function() {
        const placeholder = $(this).find('.practice-card-img-placeholder');
        
        const practiceId = placeholder.attr('data-practice-id');
        const imagePath = placeholder.attr('data-practice-image');
        const practiceName = placeholder.attr('data-practice-name');
        
        if (practiceId && imagePath) {
            fetchSignedResource(imagePath).then(signedUrl => {
                replacePlaceholderWithImage(signedUrl, practiceId, practiceName);
            });
        }
    });
}

function replacePlaceholderWithImage(imageUrl, practiceId, practiceName) {
    loadImage(imageUrl, function(loadedImageSrc) {
        const imgElement = $('<img>')
            .attr('data-resource-id', practiceId)
            .attr('src', loadedImageSrc)
            .attr('alt', practiceName + ' Marketplace Card Image')
            .addClass('grid-row marketplace-card-img radius-top-sm');

        const containerDiv = $('<div>')
            .addClass('dm-practice-card-img-container')
            .append(imgElement);

        $('.practice-card-img-placeholder[data-practice-id="' + practiceId + '"]').empty().append(containerDiv);
    });
}

function loadImage(imageSrc, callback) {
    var img = new Image();
    img.onload = function() {
        callback(imageSrc);
    };
    img.onerror = function() {
        console.error("Error loading image: " + imageSrc);
    };
    img.src = imageSrc;
}

function execPracticeCardFunctions() {
    truncateText();
    toggleFocusStylingForPracticeTitle();
}

$(document).on('turbolinks:load', execPracticeCardFunctions);
