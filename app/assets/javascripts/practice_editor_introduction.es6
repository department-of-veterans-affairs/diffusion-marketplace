(($) => {
    const $document = $(document);

    function showHidePracticeOriginFields(){

        var facility_type = document.getElementById("_init_facility").value;


        alert(facility_type);

        if(facility_type == 1 || facility_type == 3) {
            if(facility_type == 1){
                document.getElementById("editor_department_dropdown").style.display = "block";
            }
            else{
                document.getElementById("editor_department_dropdown").style.display = "none";
            }
            if(facility_type == 3) {
                alert('was up');
                document.getElementById("init_facility_other").style.display = "block";
            }
            else{
                document.getElementById("init_facility_other").style.display = "none";
            }
            document.getElementById("editor_state_dropdown").style.display = "none";
            document.getElementById("editor_facility_dropdown").style.display = "none";
        }
        else{
            document.getElementById("editor_state_dropdown").style.display = "block";
            document.getElementById("editor_facility_dropdown").style.display = "block";
            document.getElementById("editor_department_dropdown").style.display = "none";
            document.getElementById("init_facility_other").style.display = "none";
        }
    }


    $document.on('turbolinks:load', showHidePracticeOriginFields());
})(window.jQuery);
