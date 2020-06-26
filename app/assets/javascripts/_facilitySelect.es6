const FACILITY_SELECT_DISABLED_COLOR = '#a9aeb1';

// select the state and facility if the practice already has one
function selectFacility(facilityData, selectedFacility, facilitySelector = '#editor_facility_select', stateSelector = '#editor_state_select') {
    // based on the facilityData, which is the selected facility?
    const facility = facilityData.find(f => f.StationNumber === String(selectedFacility));

    // select the state and set it in the dropdown
    const state = facility.MailingAddressState;
    const stateSelect = $(stateSelector);
    stateSelect.val(state);

    // filter the facilities in the dropdown
    const facilitySelect = $(facilitySelector);
    filterFacilities(facilityData, facilitySelect, stateSelector);

    // select the facility and display it in the dropdown
    facilitySelect.val(facility.StationNumber);
}

function getFacilitiesByState(facilityData, facilitySelector = '#editor_facility_select', stateSelector = '#editor_state_select') {
    let facilitySelect = $(facilitySelector);
    let stateSelect = $(stateSelector);
    facilitySelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    facilitySelect.prop('disabled', 'disabled');
    $(stateSelect).on('change', () => {
        filterFacilities(facilityData, facilitySelect, stateSelector);
    });
}

function filterFacilities(facilityData, facilitySelect, stateSelector) {
    let selectedState = $(`${stateSelector}`).val();
    facilitySelect.css('color', 'initial');
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

function filterOffices(originData, stateSelect, officeSelect, departmentSelector, stateSelector) {
    let selectedDepartment = $(`${departmentSelector}`).val();
    stateSelect.css('color', 'initial');
    stateSelect.removeAttr('disabled');
    stateSelect.find('option:not([value=""])').remove();
    stateSelect.val('');
    let department = originData.departments.filter(d => d.name === selectedDepartment);
    let filteredStates = department.offices.forEach(o => o.state);
    filteredStates
        .sort()
        .forEach(state => {
            stateSelect
                .append($("<option></option>")
                    .attr("value", office.name)
                    .attr("class", 'usa-select')
                    .text(state))
        });
    let selectedState = $(`${stateSelector}`).val();
    officeSelect.css('color', 'initial');
    officeSelect.removeAttr('disabled');
    officeSelect.find('option:not([value=""])').remove();
    officeSelect.val('');
    let filteredOffices = department.offices.filter(o => o.state === selectedState);
    filteredOffices
        .sort()
        .forEach(office => {
            officeSelect
                .append($("<option></option>")
                    .attr("value", office.name)
                    .attr("class", 'usa-select')
                    .text(office.name))
        });
}

// select the department, state and office if the practice already has one
function selectOffice(originData, selectedDepartment, selectedOffice, officeSelector = '#editor_office_select', stateSelector = '#editor_office_state_select', departmentSelector = '#editor_department_select') {
    // based on the originData, which is the selected department?
    const department = originData.departments.find(d => d.id === String(selectedDepartment));
    const departmentSelect = $(departmentSelector);
    // select the department and display it in the dropdown
    departmentSelect.val(department.id);

    // filter the states and offices in the dropdown
    const officeSelect = $(officeSelector);
    const stateSelect = $(stateSelector);
    filterOffices(originData, stateSelect, officeSelect, departmentSelector, stateSelector);

    // select the office and display it in the dropdown
    // based on the originData, which is the selected office?
    const office = department.offices.find(o => o.id === String(selectedOffice));
    officeSelect.val(office.id);

    // select the state and set it in the dropdown
    const state = office.state;
    stateSelect.val(state);
}
