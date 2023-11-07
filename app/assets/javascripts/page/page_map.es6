function initialize(mapId) {
    const handler = Gmaps.build('Google', {
        markers: {
            clusterer: null
        },
        builders: {
            Marker: PageInfoBoxBuilder
        }
    });
    let markers;
    let dataMarkers;

    function buildMapMarkers(data) {
        dataMarkers = _.map(data, function (json, index) {
            json.marker = markers[index];
            const serviceObj = json.marker.getServiceObject();
            const totalAdoptions = json.total_adoption_count;
            serviceObj.title = buildTitleAndAriaLabelForMapMarker(json, serviceObj, totalAdoptions);
            return json;
        });
    }

    handler.buildMap({
            provider: {
                center: {lat: 38.8097343, lng: -96.5556199},
                zoom: 4.1,
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                fullscreenControl: false,
                mapTypeControl: false,
                streetViewControl: false
            },
            internal: {id: mapId},
            markers: {
                options: {
                    rich_marker: true
                }
            }
        },
        function () {
            /*
            Get the current map component's marker data via its
            id (e.g., 'page_builder_map_1', where '1' is the id of the 'PageMapComponent's ActiveRecord).
            This allows us to build markers for each 'PageMapComponent' on a 'Page'.
            */
            const componentMapData = mapData[mapId.split('_').pop()].markers;
            markers = handler.addMarkers(componentMapData);
            buildMapMarkers(componentMapData);
        });
}

$(document).on("turbolinks:load", function () {
    // Loop through each 'PageMapComponent' element and create its map
    $('.page_builder_map').each(function() {
        google.maps.event.addDomListener(window, "load", initialize($(this).attr('id')));
    })
});
