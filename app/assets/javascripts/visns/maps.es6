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

    // get the current endpoint
    let endpoint = window.location.href.split('/').pop()
    console.log(endpoint === '')
    let isVisnsIndexPage = endpoint === 'visns' || endpoint === ''
    console.log(isVisnsIndexPage)

    function setIcon(json, icon) {
        json.marker.getServiceObject().setIcon({
            url: icon,
            scaledSize: isVisnsIndexPage ? new google.maps.Size(48, 64) : new google.maps.Size(34, 46),
            size: isVisnsIndexPage ? new google.maps.Size(48, 64) : new google.maps.Size(34, 46)
        });
    }

    function clickCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (selectedMarker.id) {
                const prevSelected = dataMarkers.find(m => m.id === selectedMarker.id);
                setIcon(prevSelected, defaultVisnMarkerIcon);
            }

            selectedMarker = json;
            setIcon(json, selectedVisnMarkerIcon);
        }
    }

    function mouseoverCallback(json) {
        if (json.id !== selectedMarker.id) {
            setIcon(json, hoverVisnMarkerIcon);
        }
    }

    function mouseoutCallback(json) {
        if (json.id !== selectedMarker.id) {
            setIcon(json, defaultVisnMarkerIcon);
        }
    }

    function buildMapMarkers(data) {
        dataMarkers = _.map(data, function (json, index) {
            json.marker = markers[index];
            const serviceObj = json.marker.getServiceObject();

            if (isVisnsIndexPage) {
                serviceObj.label = {
                    color: '#FFFFFF',
                    text: `${json.number}`,
                    fontFamily: 'Open Sans'
                };
            }

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
            setIcon(json, defaultVisnMarkerIcon);
            selectedMarker = {};
        }
    }

    function changeMarkerIconOnInfoWindowClose() {
        // When a user clicks on the close button for a marker modal, change the marker icon back to the default color
        $(document).arrive("img[src='http://www.google.com/intl/en_us/mapfiles/close.gif']", function(newElem) {
            $(newElem).on('click', function() {
                if (selectedMarker.id) {
                    const json = dataMarkers.find(dm => dm.id === selectedMarker.id);
                    setIcon(json, defaultVisnMarkerIcon);
                    selectedMarker = {};
                }
            });
        });
    }

    // build a map for either the visns index or show page, based on the current endpoint
    if (isVisnsIndexPage) {
        handler.buildMap({
                provider: {
                    zoom: 4,
                    center: {lat: 38.928865, lng: -95.795342},
                    zoomControlOptions: {
                        position: google.maps.ControlPosition.TOP_RIGHT
                    },
                    fullscreenControl: false,
                    mapTypeControl: false,
                    streetViewControl: false
                },
                internal: {id: 'visns-index-map'},
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
    } else {
        handler.buildMap({
                provider: {
                    zoomControlOptions: {
                        position: google.maps.ControlPosition.TOP_RIGHT
                    },
                    fullscreenControl: false,
                    mapTypeControl: false,
                    streetViewControl: false
                },
                internal: {id: 'visns-show-map'},
                markers: {
                    options: {
                        rich_marker: true
                    }
                }
            },
            function () {
                markers = handler.addMarkers(visnVaFacilityMapData);

                buildMapMarkers(visnVaFacilityMapData);

                handler.bounds.extendWith(markers);
                handler.fitMapToBounds();
            });
    }

    google.maps.event.addListener(handler.getMap(), 'click', function () {
        closeInfoWindow();
    });

    google.maps.event.addListener(handler.getMap(), 'tilesloaded', function () {
        changeMarkerIconOnInfoWindowClose();
    });
}