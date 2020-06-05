function assignFacilityName(facility) {
    let officialName = facility['OfficialStationName'];
    let commonName = facility['CommonName'];

    if(officialName.toLowerCase().includes(commonName.toLowerCase())) {
        return officialName;
    } else {
        return `${officialName} (${commonName})`;
    }
}