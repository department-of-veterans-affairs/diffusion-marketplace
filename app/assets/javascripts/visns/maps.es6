function initialize() {
  // get the current endpoint
  const endpoint = window.location.href.split("/").pop();
  const isVisnsIndexPage = endpoint === "visns" || endpoint === "";
  const checkboxes = "input.dm-visn-map-filter-checkbox";

  const handler = Gmaps.build("Google", {
    builders: {
      Marker: isVisnsIndexPage ? VisnInfoBoxBuilder : VisnVaFacilityInfoBoxBuilder,
    },
    markers: {
      clusterer: null,
    },
  });

  let markers = null;
  let selectedMarker = {};
  let dataMarkers = null;

  function setIcon(json, icon) {
    json.marker.getServiceObject().setIcon({
      url: icon,
      scaledSize: isVisnsIndexPage ? new google.maps.Size(48, 64) : new google.maps.Size(34, 46),
      size: isVisnsIndexPage ? new google.maps.Size(48, 64) : new google.maps.Size(34, 46),
    });
  }

  function clickCallback(json) {
    if (json.id !== selectedMarker.id) {
      if (selectedMarker.id) {
        const prevSelected = dataMarkers.find(
          (m) => m.id === selectedMarker.id
        );
        setIcon(prevSelected, defaultVisnVaFacilityMarkerIcon);
      }

      selectedMarker = json;
      setIcon(json, selectedVisnVaFacilityMarkerIcon);
    }
  }

  function mouseoverCallback(json) {
    if (json.id !== selectedMarker.id) {
      setIcon(json, hoverVisnVaFacilityMarkerIcon);
    }
  }

  function mouseoutCallback(json) {
    if (json.id !== selectedMarker.id) {
      setIcon(json, defaultVisnVaFacilityMarkerIcon);
    }
  }

  function buildMapMarkers(data) {
    dataMarkers = _.map(data, function (json, index) {
      json.marker = markers[index];
      const serviceObj = json.marker.getServiceObject();

      if (isVisnsIndexPage) {
        serviceObj.label = {
          color: "#FFFFFF",
          text: `${json.number}`,
          fontFamily: "Open Sans",
        };
      }

      google.maps.event.addListener(
        serviceObj,
        "click",
        clickCallback.bind(this, json)
      );
      google.maps.event.addListener(
        serviceObj,
        "mouseover",
        mouseoverCallback.bind(this, json)
      );
      google.maps.event.addListener(
        serviceObj,
        "mouseout",
        mouseoutCallback.bind(this, json)
      );
      return json;
    });
  }

  // if the user clicks on the map, outside of the open modal, close the modal and reset the marker image to default
  function closeInfoWindow() {
    if (selectedMarker.id) {
      const json = dataMarkers.find((dm) => dm.id === selectedMarker.id);
      json.marker.infowindow.close();
      setIcon(json, defaultVisnVaFacilityMarkerIcon);
      selectedMarker = {};
    }
  }

  // When a user clicks on the close button for a marker modal, change the marker icon back to the default color
  function changeMarkerIconOnInfoWindowClose() {
    $(document).arrive(
      "img[src='http://www.google.com/intl/en_us/mapfiles/close.gif']",
      function (newElem) {
        $(newElem).on("click", function () {
          if (selectedMarker.id) {
            const json = dataMarkers.find((dm) => dm.id === selectedMarker.id);
            setIcon(json, defaultVisnVaFacilityMarkerIcon);
            selectedMarker = {};
          }
        });
      }
    );
  }

  function setVisnShowMarkers(defaultFilters = null, checkboxes = null) {
    let checkedFilters = defaultFilters || [];
    let markerData = [];

    if (checkboxes) {
      checkedFilters = $(`${checkboxes}:checked`)
        .map((i, e) => {
          return e.value;
        })
        .toArray();
    }

    if (checkedFilters.length === 0 || checkedFilters.length === 7) {
      markerData = visnVaFacilityMapData;
    } else {
      visnVaFacilityMapData.map((mapData) => {
        if (checkedFilters.some((filter) => filter === mapData["type"])) {
          markerData.push(mapData);
        }
      });
    }

    Gmaps.filter(markerData);
  }

  // build a map for either the visns index or show page, based on the current endpoint
  if (isVisnsIndexPage) {
    handler.buildMap(
      {
        provider: {
          zoom: 4,
          center: { lat: 38.928865, lng: -95.795342 },
          zoomControlOptions: {
            position: google.maps.ControlPosition.TOP_RIGHT,
          },
          fullscreenControl: false,
          mapTypeControl: false,
          streetViewControl: false,
        },
        internal: { id: "visns-index-map" },
        markers: {
          options: {
            rich_marker: true,
          },
        },
      },
      function () {
        markers = handler.addMarkers(visnMapData);

        buildMapMarkers(visnMapData);

        handler.bounds.extendWith(markers);
      }
    );
  } else {
    handler.buildMap(
      {
        provider: {
          zoomControlOptions: {
            position: google.maps.ControlPosition.TOP_RIGHT,
          },
          fullscreenControl: false,
          mapTypeControl: false,
          streetViewControl: false,
        },
        internal: { id: "visns-show-map" },
        markers: {
          options: {
            rich_marker: true,
          },
        },
      },
      function () {
        setVisnShowMarkers(["VA Medical Center (VAMC)"]);
      }
    );
  }

  Gmaps.filter = function (markerData) {
    handler.removeMarkers(markers);
    markers = handler.addMarkers(markerData);
    buildMapMarkers(markerData);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
  };

  function addVisnShowFilterListener() {
    $(checkboxes).map((i, checkbox) => {
      $(checkbox).on("change", () => {
        setVisnShowMarkers(null, checkboxes);
      });
    });
  }

  function setDefaultCheckbox() {
    $(checkboxes).map((i, checkbox) => {
      if ($(checkbox).val() === "VA Medical Center (VAMC)") {
        $(checkbox).prop("checked", true);
      } else {
        $(checkbox).prop("checked", false);
      }
    });
  }

  function setVisnShowMapEventListener() {
    if (!isVisnsIndexPage) {
      google.maps.event.addListenerOnce(handler.getMap(), "bounds_changed", function () {
          $(".dm-visn-show-map").removeClass("display-none");
          $(".dm-loading-spinner").addClass("display-none");
      });
    }
  }

  // zoom in/out when facility type filters are selected/unselected
  function resetMarkerBounds() {
      $(document).on('click', '.facility-type-checkbox-label', function() {
          handler.resetBounds();
      });
  }

  google.maps.event.addListener(handler.getMap(), 'tilesloaded', function () {
      changeMarkerIconOnInfoWindowClose();
  });

  google.maps.event.addListener(handler.getMap(), 'click', function () {
      closeInfoWindow();
  });

  setVisnShowMapEventListener();
  setDefaultCheckbox();
  addVisnShowFilterListener();
  resetMarkerBounds();
}

$(document).on("turbolinks:load", function () {
    google.maps.event.addDomListener(window, "load", initialize);
});
