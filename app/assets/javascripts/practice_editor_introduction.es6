// (($) => {
//     const $document = $(document);
//     $document.on('turbolinks:load');
// })(window.jQuery);

$( document ).ready(function() {
    const $document = $(document);
    //alert( "ready!" );
    showHidePracticeOriginFields(99);
    sortOutInitiatingFacility();
});

function sortOutInitiatingFacility(){
    if (initiatingFacilityType == "0"){
        document.getElementById('initiating_facility_other').value = "";

    }
    if (initiatingFacilityType == "1"){
        document.getElementById('initiating_facility_other').value = "";
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
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 1){
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "block";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 2){
        document.getElementById("editor_state_dropdown").style.display = "block";
        document.getElementById("editor_facility_dropdown").style.display = "block";
        document.getElementById("editor_office_dropdown").style.display = "block";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "none";
    }
    else if(facility_type == 3){
        document.getElementById("editor_state_dropdown").style.display = "none";
        document.getElementById("editor_facility_dropdown").style.display = "none";
        document.getElementById("editor_office_dropdown").style.display = "none";
        document.getElementById("editor_visn_dropdown").style.display = "none";
        document.getElementById("init_facility_other").style.display = "block";
    }
}

