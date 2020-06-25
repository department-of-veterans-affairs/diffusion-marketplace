function getDepartment(originData, departmentSelector) {
    let selectedDepartment = $(`${departmentSelector}`).val();
    return originData.departments.filter(d => `${d.id}` === selectedDepartment);
}

// select the department, state and office if the practice already has one
function selectOffice(originData, selectedDepartment, selectedOffice, officeSelector = '#editor_office_select', stateSelector = '#editor_office_state_select', departmentSelector = '#editor_department_select') {
    // based on the originData, which is the selected department
    const department = originData.departments.find(d => `${d.id}` === `${selectedDepartment}`);

    const departmentSelect = $(departmentSelector);
    // select the department and display it in the dropdown
    departmentSelect.val(department.id);

    const officeSelect = $(officeSelector);
    const stateSelect = $(stateSelector);

    // based on the originData, which is the selected office?
    const office = department.offices.find(o => `${o.id}` === String(selectedOffice));
    // filter the states in the dropdown
    filterStatesByDepartment(originData, stateSelect, departmentSelector)
    // select the state and set it in the dropdown
    const state = office.state;
    stateSelect.val(state);
    // filter the offices in the dropdown
    filterOfficesByState(originData, officeSelect, departmentSelector, stateSelector);
    // select the office and display it in the dropdown
    officeSelect.val(office.id);
}

function getStatesByDepartment(originData, departmentSelector = '#editor_department_select', stateSelector = '#editor_office_state_select') {
    let departmentSelect = $(departmentSelector);
    let stateSelect = $(stateSelector);
    stateSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    stateSelect.prop('disabled', 'disabled');
    $(departmentSelect).on('change', () => {
        filterStatesByDepartment(originData, stateSelect, departmentSelector)
    });
}
function getOfficesByState(originData, stateSelector = '#editor_office_state_select', officeSelector = '#editor_office_select', departmentSelector = '#editor_department_select') {
    let stateSelect = $(stateSelector);
    let officeSelect = $(officeSelector);
    officeSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    officeSelect.prop('disabled', 'disabled');
    $(stateSelect).on('change', () => {
        filterOfficesByState(originData, officeSelect, departmentSelector, stateSelector);
    });
}
function filterStatesByDepartment(originData, stateSelect, departmentSelector) {
    stateSelect.css('color', 'initial');
    stateSelect.removeAttr('disabled');
    stateSelect.find('option:not([value=""])').remove();
    stateSelect.val('');
    let department = getDepartment(originData, departmentSelector);
    let filteredStates = department[0].offices.map(o => o.state);
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
function filterOfficesByState(originData, officeSelect, departmentSelector, stateSelector) {
    let selectedState = $(`${stateSelector}`).val();
    officeSelect.css('color', 'initial');
    officeSelect.removeAttr('disabled');
    officeSelect.find('option:not([value=""])').remove();
    officeSelect.val('');

    const department = getDepartment(originData, departmentSelector);
    let filteredOffices = department[0].offices.filter(o => o.state === selectedState);
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