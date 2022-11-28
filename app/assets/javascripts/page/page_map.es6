function initialize(map_id) {
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
            return json;
        });
    }

    handler.buildMap({
            provider: {
                center: {lat: 39.8097343, lng: -98.5556199},
                zoom: 4.2,
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                fullscreenControl: false,
                mapTypeControl: false,
                streetViewControl: false
            },
            internal: {id: map_id},
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
            const componentMapData = mapData[map_id.split('_').pop()].markers;
            markers = handler.addMarkers(componentMapData);
            buildMapMarkers(componentMapData);
        });

    google.maps.event.addListener(handler.getMap(), "idle", function () {
        $(`#${map_id}`).removeClass("display-none");
        $(".dm-facilities-show-map-loading-spinner").addClass("display-none");
    });
}

$(document).on("turbolinks:load", function () {
    // Loop through each 'PageMapComponent' element and create its map
    $('.page_builder_map').each(function() {
        google.maps.event.addDomListener(window, "load", initialize($(this).attr('id')));
    })
});