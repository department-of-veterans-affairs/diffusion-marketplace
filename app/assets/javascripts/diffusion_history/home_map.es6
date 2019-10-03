function initialize() {
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
            $('#filterResultsTrigger').show();
            $('#filterResults').hide();
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

    function closeInfoWindow() {
        if (selectedMarker.id) {
            const json = dataMarkers.find(dm => dm.id === selectedMarker.id);
            json.marker.infowindow.close();
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

        $('#facility-results-count').text(facilityCount);
        $('#practice-results-count').text(practiceCount);
    }

    Gmaps.filter = function (data) {
        console.log(data);
        selectedMarker = {};

        let result = [...mapData];

        // practice ids
        if (data["practice[ids][]"].length > 1) {
            const ids = _.compact(data["practice[ids][]"].map(id => id.value));
            result = result.filter(function (d) {
                const practices = d.practices.map(p => p.id);
                const anyPractices = ids.filter(function (id) {
                    return this.includes(+id);
                }, practices);
                return anyPractices.length;
            });
        }

        // practice status
        if (data.statuses && data.statuses.length) {
            const statuses = data.statuses.map(s => s.value);
            result = result.filter(function (d) {
                let hasStatus = false;
                statuses.forEach(function (s) {
                    if (s === 'Complete') {
                        hasStatus = d.completed > 0;
                    }

                    if (s === 'In progress' && !hasStatus) {
                        hasStatus = d.in_progress > 0;
                    }

                    if (s === 'Unsuccessful' && !hasStatus) {
                        hasStatus = d.unsuccessful > 0;
                    }
                });
                return hasStatus;
            });
        }

        // practice complexity
        if (data.complexities && data.complexities.length) {
            const complexities = data.complexities.map(c => c.value);
            result = result.filter(function (d) {
                const practicesComplexities = d.practices
                    .map(p => Math.max(...[p.difficulty_aggregate || 0, p.sustainability_aggregate || 0, p.number_departments || 0]));
                const anyComplexities = complexities.filter(function (c) {
                    return this.includes(+c);
                }, practicesComplexities);
                return anyComplexities.length;
            });
        }

        // practice cost
        if (data.costs && data.costs.length) {
            const costs = data.costs.map(c => c.value);
            result = result.filter(function (d) {
                const practicesCosts = d.practices.map(p => p.cost_to_implement_aggregate);
                console.log(practicesCosts);
                const anyCosts = costs.filter(function (c) {
                    return this.includes(+c);
                }, practicesCosts);
                return anyCosts.length;
            });
        }

        // visn
        if (data.visns && data.visns.length) {
            const visns = data.visns.map(v => v.value);
            result = result.filter(function (d) {
                return visns.includes(d.visn);
            });
        }

        // facility name
        if (data.facility_name && data.facility_name.length) {
            const facilityName = data.facility_name[0].value;
            result = result.filter(function (d) {
                return d.facility.OfficialStationName.toLowerCase().includes(facilityName.toLowerCase());
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
        // reset the filter form
        $('#mapFilters')[0].reset();

        updateFilterResultsText(mapData);
    };

    $(document).on('click', '#filterResultsTrigger', function () {
        $('#filterResultsTrigger').hide();
        $('#filterResults').show();
        $('#filterClose').focus();
        closeInfoWindow();
    });

}

google.maps.event.addDomListener(window, 'load', initialize);
$(document).on('click', '#filterButton', function (e) {
    Gmaps.filter(document.getElementById('facilityId').value);
});
$(document).on('click', '#allMarkersButton', function (e) {
    Gmaps.allMarkers();
});

$(document).on('click', '.close', function (e) {
    const modal = $(e.target).closest('.modal');
    modal.hide();
});

$(document).on('keypress', '.close', function (e) {
    if (e.which === 13) {
        const modal = $(e.target).closest('.modal');
        modal.hide();
    }
});

$(document).on('keypress', '#filterClose', function (e) {
    if (e.which === 13) {
        $('#filterResultsTrigger').show();
        $('#filterResults').hide();
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

$(document).on('submit', '#mapFilters', function (e) {
    e.preventDefault();
    // Gather filter data
    const data = _.groupBy($('#mapFilters').serializeArray(), 'name');
    Gmaps.filter(data);
});

$(document).on('click', '#filterClose', function () {
    $('#filterResultsTrigger').show();
    $('#filterResults').hide();
});

$(document).on('click', '#practiceListTrigger', function () {
    if ($(this).text() === 'Hide list of facilities') {
        $(this).text('View list of facilities')
    } else {
        $(this).text('Hide list of facilities');
    }
    $('#practiceListContainer').toggle();
});