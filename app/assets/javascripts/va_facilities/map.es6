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
      center: {lat: Number(mapData[0].lat), lng: Number(mapData[0].lng)},
      zoom: 7,
      zoomControlOptions: {
        position: google.maps.ControlPosition.TOP_RIGHT
      },
      fullscreenControl: false,
      mapTypeControl: false,
      streetViewControl: false
    },
    internal: {id: 'va_facility_map'},
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
}

$(document).on("turbolinks:load", function () {
  google.maps.event.addDomListener(window, "load", initialize);
});
