// (($) => {
//     const $document = $(document);
//     $document.on('turbolinks:load');
// })(window.jQuery);

$( document ).ready(function() {
    const $document = $(document);
    //alert( "ready!" );
    showHidePracticeOriginFields(99);
});

function chooseState(chosen) {
    alert(chosen);
    let element = document.getElementById('editor_state_select');
    alert(element.value);
    element.value = 'CO';
    //$('#editor_state_select').val = '1';
    // var tData = JSON.parse('../../../../lib/assets/practice_origin_office_lookup');
    // alert(tData);
    // let request = new XMLHttpRequest();
    // request.open("GET", "<%= practice_assets_path> + /practice_origin_office_lookup.json", false);
    // request.overrideMimeType("application/json");
    // request.send(null);
    // var jsonData = JSON.parse(request.responseText);
    // console.log(jsonData);
}


function showHidePracticeOriginFields(facility_type){
    if(facility_type == 99){
        facility_type = document.getElementById("_init_facility_type").value;
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

