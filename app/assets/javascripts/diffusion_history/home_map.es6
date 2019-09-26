function initialize() {
    const handler = Gmaps.build('Google', {builders: {Marker: InfoBoxBuilder}, markers: {clusterer: null}});

    let markers = null;
    let selectedMarker = {};
    let dataMarkers = null;

    function setIcon(json, icon) {
        json.marker.getServiceObject().setIcon(icon);
    }

    function clickCallback(json) {
        console.log('click marker', json);
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
        console.log('mouseover marker', json);
        if (json.id !== selectedMarker.id) {
            setIcon(json, hoverMarkerIcon);
        }
    }

    function mouseoutCallback(json) {
        console.log('mouseout marker', json);
        if (json.id !== selectedMarker.id) {
            setIcon(json, defaultMarkerIcon);
        }
    }

    function buildMapMarkers(data) {
        dataMarkers = _.map(data, function (json, index) {
            json.marker = markers[index];
            const serviceObj = json.marker.getServiceObject();
            // serviceObj.label = {
            //     fontFamily: "'Font Awesome 5 Free'",
            //     text: '\uf0f9', //icon code
            //     fontWeight: '900', //careful! some icons in FA5 only exist for specific font weights
            //     color: '#FFFFFF', //color of the text inside marker
            // };
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

    handler.buildMap({provider: {}, internal: {id: 'map'}, markers: {options: {rich_marker: true}}}, function () {
        markers = handler.addMarkers(mapData);

        buildMapMarkers(mapData);

        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
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