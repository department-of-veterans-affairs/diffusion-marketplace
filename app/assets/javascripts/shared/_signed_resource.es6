// The 'dataAttributeSelector' param can be any selector for the target element(s)
function fetchSignedResource(
    resourcePath,
    dataAttributeSelector,
    resourceType = 'image'
) {
    const signedResourceUrl = `/signed_resource?path=${resourcePath}`;

    fetch(signedResourceUrl).then(response => {
        response.text().then(signedUrl => {
            const resourceElement = document.querySelector(dataAttributeSelector);

            if (resourceType === 'image' && resourceElement) {
                resourceElement.src = signedUrl;
            }
        });
    });
}