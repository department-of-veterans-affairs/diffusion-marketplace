function initialize() {
  const STATUSES = statuses;
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
    json.marker.getServiceObject().setIcon({url: icon, scaledSize: new google.maps.Size(31, 44), size: new google.maps.Size(31, 44)});
  }

  function clickCallback(json) {
    if (json.id !== selectedMarker.id) {
      if (selectedMarker.id) {
        const prevSelected = dataMarkers.find(m => m.id === selectedMarker.id);
        setIcon(prevSelected, defaultMarkerIcon);
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

  function closeFiltersAccordion() {
    $('.map-filters-accordion-button').attr('aria-expanded', 'false');
    $('#diffusion-map-filters').attr('hidden', 'true');
    // if there's a modal open, close it
    closeInfoWindow();
    // if there's a map info window open, close it
    $('#map').find('.infoBox').closest('div').empty();
  }

  function buildMapMarkers(data) {
    dataMarkers = _.map(data, function (json, index) {
      json.marker = markers[index];
      const serviceObj = json.marker.getServiceObject();
      let officialStationName = json.facility.official_station_name;
      let commonName = json.facility.common_name;
      let totalAdoptions = json.completed + json.in_progress + json.unsuccessful;
      // Add title and aria-label to each map marker to improve accessibility
      if (officialStationName.includes(commonName)) {
          serviceObj.title = `${officialStationName}, ${totalAdoptions} total adoption${totalAdoptions !== 1 ? 's' : ''}`;
      } else {
          serviceObj.title = `${officialStationName} (${commonName}), ${totalAdoptions} total adoption${totalAdoptions !== 1 ? 's' : ''}`;
      }

      serviceObj.label = {
        color: '#FFFFFF',
        text: `${totalAdoptions}`,
        fontFamily: 'Open Sans'
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

  function closeInfoWindow() {
    if (selectedMarker.id) {
      const json = dataMarkers.find(dm => dm.id === selectedMarker.id);
      if (json.marker.infowindow) {
        json.marker.infowindow.close();
      }
      $(".modal-content").filter(":visible").hide();
      setIcon(json, defaultMarkerIcon);
      selectedMarker = {};
    }
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

  google.maps.event.addListener(handler.getMap(), 'click', function () {
    closeInfoWindow();
  });

  function updateFilterResultsText(result) {
    //update filter results text at the top
    const facilityCount = result.length;
    const practiceCount = _.chain(result.map(r => r.practices)).flatten().uniqBy('id').value().length;

    $('#facility-results-count').text(`${facilityCount} facility match${facilityCount === 1 ? '' : 'es'}`);
    $('#practice-results-count').text(`${practiceCount} innovation${practiceCount === 1 ? '' : 's'}`);
  }

  Gmaps.filter = function (data) {
    selectedMarker = {};

    let result = [...mapData];

    // practices
    if (data["practices"].length > 1) {
      const ids = _.compact(data["practices"].map(id => id.value));
      result = result.filter(function (d) {
        const practices = d.practices.map(p => p.id);
        const anyPractices = ids.filter(function (id) {
          return this.includes(+id);
        }, practices);
        return anyPractices.length;
      });
    }

    // innovation status
    if (data.statuses && data.statuses.length) {
      const statuses = data.statuses.map(s => s.value);
      result = result.filter(function (d) {
        let hasStatus = false;
        statuses.forEach(function (s) {
          if (s === STATUSES[0]) {
            hasStatus = d.completed > 0;
          }
          if (s === STATUSES[1] && !hasStatus) {
            hasStatus = d.in_progress > 0;
          }
          if (s === STATUSES[2] && !hasStatus) {
            hasStatus = d.unsuccessful > 0;
          }
        });
        return hasStatus;
      });
    }

    // visn
    if (data.visns && data.visns.length) {
      const visns = data.visns.map(v => parseInt(v.value));
      result = result.filter(function (d) {
        return visns.includes(d.facility.visn_id);
      });
    }

    // facility station number
    if (data.facility_name && data.facility_name[0].value && $(".usa-combo-box").data('setFacility')) {
      const facilityStationNumber = data.facility_name[0].value;

      result = result.filter(function (d) {
        return facilityStationNumber === d.facility.station_number;
      });
    }

    // facilities
    if (data.facilities && data.facilities.length) {
      const facilities = data.facilities.map(f => f.value);
      result = result.filter(function (d) {
        return facilities.includes(d.id);
      });
    }

    // facility_complexities
    if (data.facility_complexities && data.facility_complexities.length) {
      const facilityComplexities = data.facility_complexities.map(fc => fc.value);
      result = result.filter(function (d) {
        return facilityComplexities.includes(d.complexity);
      });
    }

    // ruralities
    if (data.ruralities && data.ruralities.length) {
      const ruralities = data.ruralities.map(r => r.value);
      const RURALITY_MAP = {
        'H': 'R',
        'R': 'R',
        'I': 'R',
        'U': 'U',
      };
      result = result.filter(function (d) {
        return ruralities.includes(RURALITY_MAP[d.rurality]);
      });
    }

    for (let i = 0; i < markers.length; i++) {
      markers[i].setMap(null);
    }

    handler.removeMarkers(markers);
    markers = [];
    markers = handler.addMarkers(result);
    buildMapMarkers(result);
    handler.bounds.extendWith(markers);
    updateFilterResultsText(result);
    closeInfoWindow();
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
    _clearForm();
    updateFilterResultsText(mapData);
  };

  function setHomeMapEventListener() {
    google.maps.event.addListenerOnce(
      handler.getMap(),
      "bounds_changed",
      function () {
        $(".diffusion-map-container").removeClass("display-none");
        $(".dm-loading-spinner").addClass("display-none");
      }
    );
  }

  setHomeMapEventListener();

  function _clearForm() {
    $("#mapFilters")[0].reset();
    $("#facility_name").val("");
  }

  function attachComboBoxListeners() {
    $(document).on("click", ".usa-combo-box__clear-input", () => {
      $(".usa-combo-box").data("setFacility", false);
      $("#facility_name").val("");
    });

    $(document).on("change", "#facility_name", (e) => {
      $(".usa-combo-box").data("setFacility", false);
      if (e.target.value) {
        $(".usa-combo-box").data("setFacility", true);
      }
    });
  }

  function attachResetFilterListener() {
    $(document).on("click", "#allMarkersButton", () => {
      closeFiltersAccordion();
      Gmaps.allMarkers();
    });
  }

  function attachFilterMapListener() {
    $(document).on("click", ".update-map-results-button", () => {
      closeFiltersAccordion();
      $("#mapFilters").submit();
    });
  }

  function attachFacilityListListener() {
    $(document).on("click", "#facilityListTrigger", () => {
      const $facilityListBtn = $("#facilityListTrigger");
      if ($facilityListBtn.text() === "Hide list of facilities") {
        $facilityListBtn.text("View list of facilities");
      } else {
        $facilityListBtn.text("Hide list of facilities");
      }
      $("#facilityListContainer").toggle();
    });
  }

  function attachLabelListener() {
    $(document).on("click", "label", function (e) {
      e.target.focus({ preventScroll: true });
    });
  }

  function clearFormOnReload() {
    if (!$("#map-of-diffusion").data("resetOnReload")) {
      _clearForm();
      $("#map-of-diffusion").data("resetOnReload", true);
    }
  }

  google.maps.event.addListener(handler.getMap(), 'tilesloaded', function () {
    attachComboBoxListeners();
    attachResetFilterListener();
    attachFacilityListListener();
    attachLabelListener();
    attachFilterMapListener();
    clearFormOnReload();
  });
}

$(document).on("turbolinks:load", function () {
  google.maps.event.addDomListener(window, "load", initialize);
});