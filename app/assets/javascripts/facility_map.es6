function initialize() {
    alert('hello');
    // The location of Uluru
    const uluru = { lat: facilityLat, lng: facilityLong };
    // The map, centered at Uluru
    const map = new google.maps.Map(document.getElementById("map"), {
        zoom: 8,
        center: uluru,
    });
    // The marker, positioned at Uluru
    const marker = new google.maps.Marker({
        position: uluru,
        map: map,
    });

}