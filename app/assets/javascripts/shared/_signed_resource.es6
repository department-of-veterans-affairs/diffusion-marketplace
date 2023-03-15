// The 'dataAttributeSelector' param can be any selector for the target element(s)
function fetchSignedResource(
    resourcePath,
    resourceUrl = '',
    dataAttributeSelector,
    resourceType = 'image'
) {
    const signedResourceUrl = `/signed_resource?path=${resourcePath}&url=${resourceUrl}`;

    fetch(signedResourceUrl).then(response => {
        response.text().then(signedUrl => {
            const resourceElement = document.querySelector(dataAttributeSelector);

            if (resourceElement) {
                // TODO: Add other resource types here, e.g. 'file'
                switch (resourceType) {
                    case 'image':
                        resourceElement.src = signedUrl;
                        break;
                    case 'file':
                        resourceElement.href = signedUrl;
                        break;
                }
            }
        });
    });
}