google.maps.event.addDomListener(window, 'load', initialize);

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
    const $span = $(`#${id} .close`)[0];
    const modal = document.getElementById(id);
    modal.style.display = "block";
    $span.focus({preventScroll: true});
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


$(document).on('click', 'label', function (e) {
    e.target.focus({preventScroll: true});
});