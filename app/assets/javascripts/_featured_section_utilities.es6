function replaceImagePlaceholders() {
    $('.featured-innovation, .featured-topic').each(function() {
        const placeholder = $(this).find('.featured-image-placeholder');
        const featureType = placeholder.attr('data-feature-type')
        const practiceName = placeholder.attr('data-practice-name');
        const imagePath = placeholder.attr('data-featured-image');
        
        
        if (imagePath) {
            fetchSignedResource(imagePath).then(signedUrl => {
                replacePlaceholderWithImage(signedUrl, practiceName, featureType);
            });
        }
    });
}

function replacePlaceholderWithImage(imageUrl, practiceName, featureType) {
    // build image element
    loadImage(imageUrl, function(loadedImageSrc) {
        const imgElement = $('<img>')
            .attr('data-feature-type', featureType)
            .attr('src', imageUrl)
            .attr('alt', ''); // currently not prompting users for image descriptions
        
        // append image
        const imgClass = ".featured-" + featureType + "-image-placeholder";
        $(imgClass).append(imgElement);

        // remove placeholder
        const containerClass = ".homepage-featured-" + featureType + "-image-container"
        $(containerClass).removeClass('bg-base-lightest');
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

$(document).on('turbolinks:load', replaceImagePlaceholders);