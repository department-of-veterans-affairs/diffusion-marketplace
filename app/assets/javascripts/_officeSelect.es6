function enableSelect(select, selectLabel) {
    selectLabel.css('color', 'initial');
    select.css('color', 'initial');
    select.css('border-color', 'initial');
    select.removeAttr('disabled');
}

function getDepartment(originData, departmentSelector) {
    let selectedDepartment = $(`#${departmentSelector}`).val();
    return originData.departments.find(d => `${d.id}` === selectedDepartment);
}

// select the department, state and office if the practice already has one
function selectOffice(originData, selectedDepartment, selectedOffice, officeSelector = 'editor_office_select', stateSelector = 'editor_office_state_select', departmentSelector = 'editor_department_select') {
    // based on the originData, which is the selected department
    const department = originData.departments.find(d => `${d.id}` === `${selectedDepartment}`);

    const departmentSelect = $(`#${departmentSelector}`);
    // select the department and display it in the dropdown
    departmentSelect.val(department.id);

    const officeSelect = $(`#${officeSelector}`);
    const officeSelectLabel = $('label[for="' + officeSelector + '"]');
    const stateSelect = $(`#${stateSelector}`);
    const stateSelectLabel = $('label[for="' + stateSelector + '"]');

    // based on the originData, which is the selected office?
    const office = department.offices.find(o => `${o.id}` === String(selectedOffice));
    // filter the states in the dropdown
    filterStatesByDepartment(originData, stateSelect, stateSelectLabel, departmentSelector)
    // select the state and set it in the dropdown
    const state = office.state;
    stateSelect.val(state);
    // filter the offices in the dropdown
    filterOfficesByState(originData, officeSelect, officeSelectLabel, departmentSelector, stateSelector);
    // select the office and display it in the dropdown
    officeSelect.val(office.id);
}

function getStatesByDepartment(originData, departmentSelector = 'editor_department_select', stateSelector = 'editor_office_state_select') {
    let departmentSelect = $(`#${departmentSelector}`);
    let stateSelect = $(`#${stateSelector}`);
    let stateSelectLabel = $('label[for="' + stateSelector + '"]');
    stateSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    stateSelect.prop('disabled', 'disabled');
    $(departmentSelect).on('change', () => {
        filterStatesByDepartment(originData, stateSelect, stateSelectLabel, departmentSelector)
    });
}
function getOfficesByState(originData, stateSelector = 'editor_office_state_select', officeSelector = 'editor_office_select', departmentSelector = 'editor_department_select') {
    let stateSelect = $(`#${stateSelector}`);
    let officeSelect = $(`#${officeSelector}`);
    let officeSelectLabel = $('label[for="' + officeSelector + '"]');
    officeSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    officeSelect.prop('disabled', 'disabled');
    $(stateSelect).on('change', () => {
        filterOfficesByState(originData, officeSelect, officeSelectLabel, departmentSelector, stateSelector);
    });
}
function filterStatesByDepartment(originData, stateSelect, stateSelectLabel, departmentSelector) {
    enableSelect(stateSelect, stateSelectLabel);
    stateSelect.find('option:not([value=""])').remove();
    stateSelect.val('');
    let department = getDepartment(originData, departmentSelector);
    let filteredStates = department.offices.map(o => o.state);
    filteredStates
        .sort()
        .forEach(state => {
            stateSelect
                .append($("<option></option>")
                    .attr("value", state)
                    .attr("class", 'usa-select')
                    .text(state))
        });
}

function filterDepartmentTypeOptionsOnRadioSelect(originData, selectedOffice, stateSelect, stateSelectLabel, departmentSelector = 'editor_department_select', stateSelector = 'editor_office_state_select', officeSelector = 'editor_office_select') {
    $('#initiating_facility_type_department').on('click', function() {
        let selectedDepartment = $(`#${departmentSelector} option:selected`).val();
        let stateSelect = $(`#${stateSelector}`);
        let stateSelectLabel = $('label[for="' + stateSelector + '"]');
        let selectedState = $(`#${stateSelector} option:selected`).val();
        let officeSelect = $(`#${officeSelector}`);
        let officeSelectLabel = $('label[for="' + officeSelector + '"]');
        let selectedOffice = $(`#${officeSelector} option:selected`).val();

        if (selectedDepartment !== '' && selectedState === '') {
            filterStatesByDepartment(originData, stateSelect, stateSelectLabel, departmentSelector);
        }
        else if (selectedState !== '' && selectedDepartment !== '' && selectedOffice === '') {
            enableSelect(stateSelect, stateSelectLabel);
            filterOfficesByState(originData, officeSelect, officeSelectLabel, departmentSelector, stateSelector);
        }
        else if (selectedState !== '' && selectedDepartment !== '' && selectedOffice !== '') {
            enableSelect(stateSelect, stateSelectLabel);
            enableSelect(officeSelect, officeSelectLabel);
        }
    })
}

function filterOfficesByState(originData, officeSelect, officeSelectLabel, departmentSelector, stateSelector) {
    let selectedState = $(`#${stateSelector}`).val();
    enableSelect(officeSelect, officeSelectLabel);
    officeSelect.find('option:not([value=""])').remove();
    officeSelect.val('');

    const department = getDepartment(originData, departmentSelector);
    let filteredOffices = department.offices.filter(o => o.state === selectedState);
    filteredOffices
        .sort()
        .forEach(office => {
            officeSelect
                .append($("<option></option>")
                    .attr("value", office.id)
                    .attr("class", 'usa-select')
                    .text(office.name))
        });
}

function disableAndSelectDepartmentOptionValue() {
    return $('#editor_department_select option:first').attr({'selected': true, 'disabled': true});
}