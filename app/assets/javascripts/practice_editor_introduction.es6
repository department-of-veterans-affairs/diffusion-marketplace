(($) => {
    const $document = $(document);

    function attachFacilitySelectListener() {

        $document.arrive('.practice-editor-origin-facility-li', (newElem) => {
            let $newEl = $(newElem);
            let dataId = $newEl.data('id');
            styleOriginFacility($newEl, dataId);
            getFacilitiesByState(facilityData, `practice_practice_origin_facilities_attributes_${dataId}_facility_id`, `editor_state_select_${dataId}`)
            $document.unbindArrive('.practice-editor-origin-li', newElem);
        });
    }

    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        showOtherAwardFields();
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

function styleOriginFacility($newEl, dataId){
    $newEl.css('list-style', 'none');
    const $originFacilityElements = $('.practice-editor-origin-facility-li');
    if($originFacilityElements.length > 1){
        $.each($originFacilityElements, (i, el) => {
            if($(el).data('id') !== dataId) {
                $(el).addClass('margin-bottom-4');
            }
        });
    }
}

// $( document ).ready(function() {
//     const $document = $(document);
//     //alert( "ready!" );
//     showHidePracticeOriginFields(99);
//     sortOutInitiatingFacility();
//     debugger
//     disableAndSelectDepartmentOptionValue();
//     filterDepartmentTypeOptionsOnRadioSelect(originData);
//     getStatesByDepartment(originData);
//     getOfficesByState(originData);
//
//     var max_fields = 10;
//     //var otherFacilityWrapper = $(".add_more_facilities");
// });

function addOtherPracticeOriginFacilities(p){
    debugger
    initiatingFacilityCtr++;

    var select = document.createElement("select");
    var stateSelector = "editor_state_select[" + initiatingFacilityCtr + "]";
    select.name = stateSelector;
    select.id = stateSelector;
    select.style.position = "absolute";

    const items = stateData.split(',');
    let option = document.createElement("option");
    option.value = '';
    option.text = "-Select-";
    select.appendChild(option);
    for(let i = 0; i < items.length; i++){
        const splitStr = items[i].split(":");
        option = document.createElement("option");
        option.value = splitStr[0];
        option.text = splitStr[1];
        select.appendChild(option);
    }
debugger
    let label = document.createElement("label");
    label.innerHTML = "<br /><br />State <br />"
    label.htmlFor = stateSelector;
    document.getElementById(p).appendChild(label);
    document.getElementById(p).appendChild(select);
    var facilitySelector = "editor_facility_select[" + initiatingFacilityCtr + "]";
    select = document.createElement("select");
    select.name = facilitySelector;
    select.id = facilitySelector;
    select.style.width = "477px";
    option = document.createElement("option");
    option.value = '';
    option.text = "-Select-";
    select.appendChild(option);
    label = document.createElement("label");
    label.innerHTML = "<br /><br />Facility <br />"
    label.htmlFor = facilitySelector;
    document.getElementById(p).appendChild(label);
    document.getElementById(p).appendChild(select);
    debugger
    getFacilitiesByState(facilityData, facilitySelector, stateSelector);


}

function showOtherAwardFields(){
    if(document.getElementById('awards_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    }
    else{
        document.getElementById('other_awards_container').style.display = 'none';
    }
}

function addSelect(parentId, elementId, html) {
    // Adds an element to the document
    initiatingFacilityCtr++;

    var p = document.getElementById(parentId);
    var newElement = document.createElement('select');
    newElement.setAttribute('id', elementId);
    newElement.innerHTML = html;
    p.appendChild(newElement);
}

function removeElement(elementId) {
    // Removes an element from the document
    var element = document.getElementById(elementId);
    element.parentNode.removeChild(element);
}




function sortOutInitiatingFacility(){
    if (selectedFacilityType == "0"){
        document.getElementById('initiating_facility_other').value = "";
        document.getElementById('initiating_department_office_id').value = "";

    }
    if (selectedFacilityType == "1"){
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
    if (selectedFacilityType == "2"){
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
    if (selectedFacilityType == "3"){
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
    debugger
    if(facility_type == 'facility')
    {
        document.getElementById("editor_facility_select").disabled = false;
        document.getElementById("editor_office_select").disabled = true;
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "block";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "block";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 'visn'){
        document.getElementById("editor_office_select").disabled = true;
        document.getElementById("editor_facility_select").disabled = true;
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "block";
        document.getElementById("init_facility_other").style.display = "none";

    }
    else if(facility_type == 'department'){
        document.getElementById("editor_office_select").disabled = false;
        document.getElementById("editor_facility_select").disabled = true;
        document.getElementById("editor_department_dropdown").style.display = "block";
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "block";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 'other'){
        document.getElementById("editor_office_select").disabled = true;
        document.getElementById("editor_facility_select").disabled = true;
        document.getElementById("editor_department_dropdown").style.display = "none";
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("init_facility_other").style.display = "block";
    }
}
function disableAndSelectDepartmentOptionValue() {
    return $('#editor_department_select option:first').attr({'selected': true, 'disabled': true});}

