// (($) => {
//     const $document = $(document);
//     $document.on('turbolinks:load');
// })(window.jQuery);

$( document ).ready(function() {
    const $document = $(document);
    //alert( "ready!" );
    showHidePracticeOriginFields(99);
    sortOutInitiatingFacility();

    getOfficesByState(originData);

    var max_fields = 10;
    //var otherFacilityWrapper = $(".add_more_facilities");
});

function addOtherPracticeOriginFacilities(){
    debugger
    initiatingFacilityCtr++;

    var select = document.createElement("select");
    var stateSelector = "editor_state_select_other[" + initiatingFacilityCtr + "]";
    select.name = stateSelector;
    select.id = stateSelector;
    select.style.position = "absolute";

    var items = stateData.split(',');
    var ctr = 0;
    var option = document.createElement("option");
    option.value = '';
    option.text = "-Select-";
    select.appendChild(option);
    for(var i = 0; i < items.length; i++){
        var splitStr = items[i].split(":");
        var option = document.createElement("option");
        option.value = splitStr[0];
        option.text = splitStr[1];
        select.appendChild(option);
    }
debugger
    var label = document.createElement("label");
    label.innerHTML = "<br /><br />State <br />"
    label.htmlFor = stateSelector;
    //stateSelector = "#" + stateSelector;

    var facilitySelector = "editor_facility_select_other[" + initiatingFacilityCtr + "]";
    //var facilitySelect = $(facilitySelector);
    //select.onchange = function(){filterFacilities(facilityData, "#" +  facilitySelect, "#" +  stateSelector)};


    document.getElementById("container").appendChild(label);
    document.getElementById("container").appendChild(select);

    select = document.createElement("select");

    select.name = facilitySelector;
    select.id = facilitySelector;
    select.style.width = "477px";

    option = document.createElement("option");
    option.value = '';
    option.text = "-Select-";
    select.appendChild(option);
    ctr = 0;

    label = document.createElement("label");
    label.innerHTML = "<br /><br />Facility <br />"
    label.htmlFor = facilitySelector;
    facilitySelector = "#" + facilitySelector;
    stateSelector = "#" + stateSelector;
    document.getElementById("container").appendChild(label);
    document.getElementById("container").appendChild(select);
    debugger
    getFacilitiesByState(facilityData, facilitySelector, stateSelector);


}




function sortOutInitiatingFacility(){
    if (initiatingFacilityType == "0"){
        document.getElementById('initiating_facility_other').value = "";
        document.getElementById('initiating_department_office_id').value = "";

    }
    if (initiatingFacilityType == "1"){
        document.getElementById('initiating_facility_other').value = "";
        //TODO: get initiating VISN data
        // debugger
        // var objVisns = JSON.parse(visnData);
        // let visnSelect =  document.getElementById('editor_visn_select');
        // debugger
        // for(let visn in objVisns){
        //     var obj = objVisns[visn];
        //     if(obj.name == selectedFacility){
        //         visnSelect.value = obj.id;
        //         break;
        //     }
        // }

    }
    if (initiatingFacilityType == "2"){
        document.getElementById('initiating_facility_other').value = "";
        let officeSelect = document.getElementById('initiating_department_office_id')
        var objOffices = JSON.parse(officeData);
        for( let prop in objOffices ){
            var obj = objOffices[prop];

            if(obj.id == initiatingDepartmentOfficeId){
                officeSelect.value = obj.id;
                break;
            }
        }
    }
    if (initiatingFacilityType == "3"){
        document.getElementById('initiating_department_office_id').value = "";

    }

}


function chooseStateAndFacility(chosen) {
    let element = document.getElementById('editor_state_select');
    var objOffices = JSON.parse(officeData);
    for( let prop in objOffices ){
        var obj = objOffices[prop];
        if(obj.id == chosen){
            element.value = obj.state;
            //element.disabled = true;
            $("#editor_state_select").trigger('change');
            break;
        }
    }
    //console.log($(element).closest('form').serialize());
}
function showHidePracticeOriginFields(facility_type){
    //var bReset = false;
    if(facility_type == 99){
        facility_type = initiatingFacilityType; // document.getElementById("_init_facility_type").value;
    }
    //alert(facility_type)
    if(facility_type == 0)
    {
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "block";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "block";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 1){
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "block";
        document.getElementById("init_facility_other").style.display = "none";

    }
    else if(facility_type == 2){
        document.getElementById("editor_department_dropdown").style.display = "block";
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "block";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 3){
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("init_facility_other").style.display = "block";
    }
}
//_oFficeSelect.es6 from legacy PE functions///////////////////////////////////////////////////////////////////////////
function getDepartment(originData, departmentSelector) {
    debugger;
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

function getStatesByDepartment(originData, departmentSelector = 'initiating_department_office_id', stateSelector = 'editor_state_select') {
    let departmentSelect = $(`#${departmentSelector}`);
    let stateSelect = $(`#${stateSelector}`);
    let stateSelectLabel = $('label[for="' + stateSelector + '"]');
    // stateSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    // stateSelect.prop('disabled', 'disabled');
    $(departmentSelect).on('change', () => {
        filterStatesByDepartment(originData, stateSelect, stateSelectLabel, departmentSelector)
    });
}
function getOfficesByState(originData, stateSelector = 'editor_state_select', officeSelector = 'editor_office_select', departmentSelector = 'initiating_department_office_id') {
    debugger
    let stateSelect = $(`#${stateSelector}`);
    let officeSelect = $(`#${officeSelector}`);
    let officeSelectLabel = $('label[for="' + officeSelector + '"]');
    //officeSelect.css('color', FACILITY_SELECT_DISABLED_COLOR);
    //officeSelect.prop('disabled', 'disabled');
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
    let uniqueStates = [...new Set(filteredStates)];
    uniqueStates
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
    //let officeSelectObj = document.getElementById(officeSelect);
    //enableSelect(officeSelectObj, officeSelectLabel);
    //officeSelectObj.find('option:not([value=""])').remove();
    officeSelect.val('');
    debugger;
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
    return $('#editor_department_select option:first').attr({'selected': true, 'disabled': true});}

