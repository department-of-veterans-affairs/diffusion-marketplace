function fetchSignedResource(
    resourcePath,
    resourceUrl = '',
) {
    const signedResourceUrl = `/signed_resource?path=${resourcePath}&url=${resourceUrl}`;
    return fetch(resourcePath).then(response => {
        return response.text().then(signedUrl => {
            return signedUrl;
        });
    });
}
