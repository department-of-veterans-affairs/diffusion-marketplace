function assignFacilityName(facility) {
    let officialName = facility["official_station_name"] || facility["OfficialStationName"];
    let commonName = facility["common_name"] || facility["CommonName"];

    if (officialName.toLowerCase().includes(commonName.toLowerCase())) {
        return officialName;
    } else {
        return `${officialName} (${commonName})`;
    }
}