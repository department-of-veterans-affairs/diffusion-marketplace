const FACILITY_SELECT_DISABLED_COLOR = '#a9aeb1';

function enableSelect(select, selectLabel) {
    selectLabel.hasClass('disabled-label') ? selectLabel.removeClass('disabled-label') : selectLabel.addClass('enabled-label');
    select.hasClass('disabled-input') ? select.removeClass('disabled-input') && select.addClass('enabled-input') : select.addClass('enabled-input');
    select.removeAttr('disabled');
}

// select the state and facility if the practice already has one
function selectFacility(facilityData, selectedFacility, facilitySelector = 'editor_facility_select', stateSelector = 'editor_state_select') {
    // based on the facilityData, which is the selected facility?
    const facility = facilityData.find(f => f.StationNumber === String(selectedFacility));

    // select the state and set it in the dropdown
    const state = facility.MailingAddressState;
    const stateSelect = $(`#${stateSelector}`);
    stateSelect.val(state);

    // filter the facilities in the dropdown
    const facilitySelect = $(`#${facilitySelector}`);
    const facilitySelectLabel = $('label[for="' + facilitySelector + '"]');
    filterFacilities(facilityData, facilitySelect, facilitySelectLabel, stateSelector);

    // select the facility and display it in the dropdown
    facilitySelect.val(facility.StationNumber);
}

function getFacilitiesByState(facilityData, facilitySelector = 'editor_facility_select', stateSelector = 'editor_state_select') {
    let facilitySelect = $(`#${facilitySelector}`);
    let facilitySelectLabel = $('label[for="' + facilitySelector + '"]');
    let stateSelect = $(`#${stateSelector}`);
    facilitySelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    facilitySelect.prop('disabled', 'disabled');
    $(stateSelect).on('change', () => {
        filterFacilities(facilityData, facilitySelect, facilitySelectLabel, stateSelector);
    });
}

function filterFacilities(facilityData, facilitySelect, facilitySelectLabel, stateSelector) {
    let selectedState = $(`#${stateSelector} option:selected`).val();
    enableSelect(facilitySelect, facilitySelectLabel);
    facilitySelect.removeAttr('disabled');
    facilitySelect.find('option:not([value=""])').remove();
    facilitySelect.val('');

    let filteredFacilities = facilityData.filter(f => f.MailingAddressState === selectedState);
    filteredFacilities
        .sort((a,b) => a['OfficialStationName'].localeCompare(b['OfficialStationName']))
        .forEach(facility => {
        facilitySelect
            .append($("<option></option>")
                .attr("value", facility.StationNumber)
                .attr("class", 'usa-select')
                .text(assignFacilityName(facility)))
    });
}

function filterFacilitiesOnRadioSelect(facilityData, facilitySelect, facilitySelectLabel, facilitySelector = 'editor_facility_select', stateSelector = 'editor_state_select') {
    $('#initiating_facility_type_facility').on('click', function() {
        let selectedState = $(`#${stateSelector} option:selected`).val();
        let facilitySelect = $(`#${facilitySelector}`);
        let facilitySelectLabel = $('label[for="' + facilitySelector + '"]');
        let selectedFacility = $(`#${facilitySelector} option:selected`).val();
        if (selectedState !== '' && selectedFacility === '') {
            filterFacilities(facilityData, facilitySelect, facilitySelectLabel, stateSelector);
        } else if (selectedState !== '' && selectedFacility !== '') {
            enableSelect(facilitySelect, facilitySelectLabel);
        }
    })
}
