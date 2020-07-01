// (($) => {
//     const $document = $(document);
//     $document.on('turbolinks:load');
// })(window.jQuery);

$( document ).ready(function() {
    const $document = $(document);
    //alert( "ready!" );
    showHidePracticeOriginFields(99);
    sortOutInitiatingFacility();
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
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "block";
        document.getElementById("add_more_facilities").style.display = "block";
        document.getElementById("editor_office_dropdown").style.display = "none";
        // document.getElementById("editor_office_dropdown").hidden = true;
        // document.getElementById("initiating_department_office_id").disabled = true;

        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 1){
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "block";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 2){
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "block";
        document.getElementById("editor_office_dropdown").style.display = "block";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 3){
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("add_more_facilities").style.display = "none";
        document.getElementById("init_facility_other").style.display = "block";
    }
}

