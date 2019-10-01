function initialize() {
    const handler = Gmaps.build('Google', {builders: {Marker: InfoBoxBuilder}, markers: {clusterer: null}});

    let markers = null;
    let selectedMarker = {};
    let dataMarkers = null;

    function setIcon(json, icon) {
        json.marker.getServiceObject().setIcon(icon);
    }

    function clickCallback(json) {
        if (json.id !== selectedMarker.id) {
            if (selectedMarker.id) {
                const prevSelected = dataMarkers.find(m => m.id === selectedMarker.id);
                prevSelected.marker.getServiceObject().setIcon(defaultMarkerIcon);
            }
            selectedMarker = json;
            setIcon(json, selectedMarkerIcon);
        }
    }

    function mouseoverCallback(json) {
        if (json.id !== selectedMarker.id) {
            setIcon(json, hoverMarkerIcon);
        }
    }

    function mouseoutCallback(json) {
        if (json.id !== selectedMarker.id) {
            setIcon(json, defaultMarkerIcon);
        }
    }

    function buildMapMarkers(data) {
        dataMarkers = _.map(data, function (json, index) {
            json.marker = markers[index];
            const serviceObj = json.marker.getServiceObject();
            serviceObj.label = {
                color: '#FFFFFF',
                text: `${json.completed + json.in_progress}`,
                fontFamily: '"Source Sans Pro"'
            };

            google.maps.event.addListener(serviceObj, 'click', clickCallback.bind(this, json));
            google.maps.event.addListener(serviceObj, 'mouseover', mouseoverCallback.bind(this, json));
            google.maps.event.addListener(serviceObj, 'mouseout', mouseoutCallback.bind(this, json));
            return json;
        });
    }

    function initializeMarkerModals(data) {
        data.forEach(function (d) {
            $('#map').after(d.modal);
        });
    }

    handler.buildMap({
            provider: {
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
        handler.fitMapToBounds();
        initializeMarkerModals(mapData);
    });

    google.maps.event.addListener(handler.getMap(), 'click', function() {
       if (selectedMarker.id) {
           const json = dataMarkers.find(dm => dm.id === selectedMarker.id);
           json.marker.infowindow.close();
           setIcon(json, defaultMarkerIcon);
           selectedMarker = {};
       }
    });

    Gmaps.filter = function (id) {
        selectedMarker = {};
        const result = mapData.filter(function (m) {
            return m.id === id;
        });
        for (let i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        handler.removeMarkers(markers);
        markers = [];
        markers = handler.addMarkers(result);
        buildMapMarkers(result);
        handler.bounds.extendWith(markers);
    };

    Gmaps.allMarkers = function () {
        for (let i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
        handler.removeMarkers(markers);
        markers = [];
        markers = handler.addMarkers(mapData);
        buildMapMarkers(mapData);
        handler.bounds.extendWith(markers);
    };

}

google.maps.event.addDomListener(window, 'load', initialize);
$(document).on('click', '#filterButton', function (e) {
    Gmaps.filter(document.getElementById('facilityId').value);
});
$(document).on('click', '#allMarkersButton', function (e) {
    Gmaps.allMarkers();
});

// When the user clicks the button, open the modal
$(document).on('click', 'button', function (e) {
    e.preventDefault();
    // Get the <span> element that closes the modal
    const $span = $(".close");
    const modal = document.getElementById(`homeMapMarkerViewMoreModal-${$(e.target).data('marker-id')}`);
    modal.style.display = "block";
    $span.focus();
});

$(document).on('click', '.close', function(e) {
    const modal = $(e.target).closest('.modal');
    modal.hide();
});

$(document).on('keypress', '.close', function (e) {
    if (e.which === 13) {
        const modal = $(e.target).closest('.modal');
        modal.hide();
    }
});

// When the user clicks anywhere outside of the modal, close it
$(window).on('click', function (event) {
    const modal = $(event.target).closest('.modal');
    if (modal.length && $(event.target)[0].id === modal[0].id) {
        modal.hide();
    }
});

// When the user shift tabs to the first element in the modal, close it
$(document).on('focus', '.first_el', function (e) {
    const modal = $(e.target).closest('.modal');
    modal.hide();
});

// When the user focuses on the last element in the modal, close it
$(document).on('focus', '.last_el', function (e) {
    const modal = $(e.target).closest('.modal');
    modal.hide();
});

function openMarkerModal(id) {
    // Get the <span> element that closes the modal
    const $span = $(".close");
    const modal = document.getElementById(id);
    modal.style.display = "block";
    $span.focus();
}