function initialize() {
    const STATUSES = statuses
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
            scaledSize: new google.maps.Size(31, 44),
            size: new google.maps.Size(31, 44)
        });
    }

    function clickCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (selectedMarker.id) {
                const prevSelected = dataMarkers.find(m => m.id === selectedMarker.id);
                if (prevSelected.status === STATUSES[0]) {
                    setIcon(prevSelected, defaultMarkerIcon);
                } else if (prevSelected.status === STATUSES[1]) {
                    setIcon(prevSelected, defaultInProgressMarkerIcon);
                } else {
                    setIcon(prevSelected, defaultUnsuccessfulMarkerIcon);
                }
            }
            selectedMarker = json;

            if (json.status === STATUSES[0]) {
                setIcon(json, selectedMarkerIcon);
            } else if (json.status === STATUSES[1]) {
                setIcon(json, selectedInProgressMarkerIcon);
            } else {
                setIcon(json, selectedUnsuccessfulMarkerIcon);
            }

        }
    }

    function mouseoverCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (json.status === STATUSES[0]) {
                setIcon(json, hoverMarkerIcon);
            } else if (json.status === STATUSES[1]) {
                setIcon(json, hoverInProgressMarkerIcon);
            } else {
                setIcon(json, hoverUnsuccessfulMarkerIcon);
            }
        }
    }

    function mouseoutCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (json.status === STATUSES[0]) {
                setIcon(json, defaultMarkerIcon);
            } else if (json.status === STATUSES[1]) {
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
            if (json.status === STATUSES[0]) {
                setIcon(json, defaultMarkerIcon);
            } else if (json.status === STATUSES[1]) {
                setIcon(json, defaultInProgressMarkerIcon);
            } else {
                setIcon(json, defaultUnsuccessfulMarkerIcon);
            }
            selectedMarker = {};
        }
    }

    handler.buildMap({
            provider: {
                zoom: 3,
                center: {lat: 44.967243, lng:  -103.771556},
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
            markers = handler.addMarkers(mapData);

            buildMapMarkers(mapData);

            handler.bounds.extendWith(markers);
        });

    google.maps.event.addListener(handler.getMap(), 'click', function () {
        closeInfoWindow();
    });

    Gmaps.filter = function (data) {
        selectedMarker = {};

        let result = [...mapData];

        // practice status
        if (data.statuses && data.statuses.length) {
            const statuses = data.statuses.map(s => s.value);
            result = result.filter(function (d) {
                let hasStatus = false;
                statuses.forEach(function (s) {
                    if (!hasStatus) {
                        hasStatus = d.status === s;
                    }
                });
                return hasStatus;
            });
        } else {
            result = [];
        }

        for (let i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }

        handler.removeMarkers(markers);
        markers = [];
        markers = handler.addMarkers(result);
        buildMapMarkers(result);
        handler.bounds.extendWith(markers);
        closeInfoWindow();
    };

    $(document).on('change', 'input[id*="status"]', function (e) {
        // submit the form to get the data
        $('#mapFilters').submit();
    });
}

function _resetCheckboxes() {
    let $checkboxes = $(".practice-map-filters").find(".usa-checkbox__input");
    $checkboxes.each((k, v) => {
        $(v).prop('checked', true);
    })
}

$(document).on("turbolinks:load", function () {
    _resetCheckboxes();
    google.maps.event.addDomListener(window, "load", initialize);
});
