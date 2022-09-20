// The 'dataAttributeSelector' param can be any selector for the target element(s)
function fetchSignedResource(
    resourcePath,
    dataAttributeSelector,
    resourceType = 'image'
) {
    const signedImageUrl = `/signed_image?path=${resourcePath}`;
    fetch(signedImageUrl).then(response => {
        response.text().then(signedUrl => {
            const resourceElement = document.querySelector(dataAttributeSelector);
            if (resourceType === 'image') {
                resourceElement.src = signedUrl;
            }
        });
    });
}