function initialize() {
    const handler = Gmaps.build('Google', {
        builders: {
            Marker: InfoBoxBuilder
        }, markers: {
            clusterer: null
        }
    });

    let markers = null;
    let selectedMarker = {};
    let dataMarkers = null;

    function setIcon(json, icon) {
        json.marker.getServiceObject().setIcon({
            url: icon,
            scaledSize: new google.maps.Size(31, 54),
            size: new google.maps.Size(31, 44)
        });
    }

    function clickCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (selectedMarker.id) {
                const prevSelected = dataMarkers.find(m => m.id === selectedMarker.id);
                if (prevSelected.status.toLowerCase() === 'complete') {
                    setIcon(prevSelected, defaultMarkerIcon);
                } else if (prevSelected.status.toLowerCase() === 'in progress') {
                    setIcon(prevSelected, defaultInProgressMarkerIcon);
                } else {
                    setIcon(prevSelected, defaultUnsuccessfulMarkerIcon);
                }
            }
            selectedMarker = json;

            if (json.status.toLowerCase() === 'complete') {
                setIcon(json, selectedMarkerIcon);
            } else if (json.status.toLowerCase() === 'in progress') {
                setIcon(json, selectedInProgressMarkerIcon);
            } else {
                setIcon(json, selectedUnsuccessfulMarkerIcon);
            }

            $('#filterResultsTrigger').show();
            $('#filterResults').hide();
        }
    }

    function mouseoverCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (json.status.toLowerCase() === 'complete') {
                setIcon(json, hoverMarkerIcon);
            } else if (json.status.toLowerCase() === 'in progress') {
                setIcon(json, hoverInProgressMarkerIcon);
            } else {
                setIcon(json, hoverUnsuccessfulMarkerIcon);
            }
        }
    }

    function mouseoutCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (json.status.toLowerCase() === 'complete') {
                setIcon(json, defaultMarkerIcon);
            } else if (json.status.toLowerCase() === 'in progress') {
                setIcon(json, defaultInProgressMarkerIcon);
            } else {
                setIcon(json, defaultUnsuccessfulMarkerIcon);
            }
        }
    }

    function buildMapMarkers(data) {
        dataMarkers = _.map(data, function (json, index) {
            json.marker = markers[index];
            const serviceObj = json.marker.getServiceObject();

            google.maps.event.addListener(serviceObj, 'click', clickCallback.bind(this, json));
            google.maps.event.addListener(serviceObj, 'mouseover', mouseoverCallback.bind(this, json));
            google.maps.event.addListener(serviceObj, 'mouseout', mouseoutCallback.bind(this, json));
            return json;
        });
    }

    function closeInfoWindow() {
        if (selectedMarker.id) {
            const json = dataMarkers.find(dm => dm.id === selectedMarker.id);
            json.marker.infowindow.close();
            if (json.status.toLowerCase() === 'complete') {
                setIcon(json, defaultMarkerIcon);
            } else if (json.status.toLowerCase() === 'in progress') {
                setIcon(json, defaultInProgressMarkerIcon);
            } else {
                setIcon(json, defaultUnsuccessfulMarkerIcon);
            }
            selectedMarker = {};
        }
    }

    handler.buildMap({
            provider: {
                zoom: 4.45,
                center: {lat: 38.928865, lng:  -95.795342},
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                fullscreenControl: false,
                mapTypeControl: false,
                streetViewControl: false
            },
            internal: {id: 'map'},
            markers: {
                options: {
                    rich_marker: true
                }
            }
        },
        function () {
            markers = handler.addMarkers(visnMapData);

            buildMapMarkers(visnMapData);

            handler.bounds.extendWith(markers);
        });

    google.maps.event.addListener(handler.getMap(), 'click', function () {
        closeInfoWindow();
    });
}