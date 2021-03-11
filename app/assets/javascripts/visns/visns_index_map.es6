function initialize() {
    const handler = Gmaps.build('Google', {
        builders: {
            Marker: VisnInfoBoxBuilder
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
            scaledSize: new google.maps.Size(48, 64),
            size: new google.maps.Size(48, 64)
        });
    }

    function clickCallback(json) {
        if (json.number !== selectedMarker.number) {
            if (selectedMarker.number) {
                const prevSelected = dataMarkers.find(m => m.number === selectedMarker.number);
                setIcon(prevSelected, defaultVisnMarkerIcon);
            }

            selectedMarker = json;
            setIcon(json, selectedVisnMarkerIcon);
        }
    }

    function mouseoverCallback(json) {
        if (json.number !== selectedMarker.number) {
            setIcon(json, hoverVisnMarkerIcon);
        }
    }

    function mouseoutCallback(json) {
        if (json.number !== selectedMarker.number) {
            setIcon(json, defaultVisnMarkerIcon);
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
        if (selectedMarker.number) {
            const json = dataMarkers.find(dm => dm.number === selectedMarker.number);
            json.marker.infowindow.close();
            setIcon(json, defaultVisnMarkerIcon);
            selectedMarker = {};
        }
    }

    function changeMarkerIconOnInfoWindowClose() {
        // When a user clicks on the close button for a marker modal, change the marker icon back to the default color
        $(document).arrive("img[src='http://www.google.com/intl/en_us/mapfiles/close.gif']", function(newElem) {
            $(newElem).on('click', function() {
                if (selectedMarker.number) {
                    const json = dataMarkers.find(dm => dm.number === selectedMarker.number);
                    setIcon(json, defaultVisnMarkerIcon);
                    selectedMarker = {};
                }
            });
        });
    }

    handler.buildMap({
            provider: {
                zoom: 4,
                center: {lat: 38.928865, lng:  -95.795342},
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                fullscreenControl: false,
                mapTypeControl: false,
                streetViewControl: false
            },
            internal: {id: 'visn-index-map'},
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

    google.maps.event.addListener(handler.getMap(), 'tilesloaded', function () {
        changeMarkerIconOnInfoWindowClose();
    });
}