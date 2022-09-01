function initialize() {
    const handler = Gmaps.build('Google', {
        markers: {
            clusterer: null
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
                // center: {lat: 95, lng: 37},
                center: {lat: Number(mapData[0].lat), lng: Number(mapData[0].lng)},
                zoom: 4,
                zoomControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                fullscreenControl: false,
                mapTypeControl: false,
                streetViewControl: false
            },
            internal: {id: 'page_builder_map'},
            markers: {
                options: {
                    rich_marker: true
                }
            }
        },
        function () {
            markers = handler.addMarkers(mapData);
            buildMapMarkers(mapData);
        });

    google.maps.event.addListener(handler.getMap(), "idle", function () {
        $("#page_builder_map").removeClass("display-none");
        $(".dm-facilities-show-map-loading-spinner").addClass("display-none");
    });
}

$(document).on("turbolinks:load", function () {
    google.maps.event.addDomListener(window, "load", initialize);
});