function fetchSignedResource(
    resourcePath,
    resourceUrl = '',
) {
    const signedResourceUrl = `/signed_resource?path=${resourcePath}&url=${resourceUrl}`;
    return fetch(signedResourceUrl).then(response => {
        return response.text().then(signedUrl => {
            return signedUrl;
        });
    });
}
