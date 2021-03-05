$(document).ready(function(){

    //event handlers for LI(s)
    $("#vamc_directory_select").change (function(e) {

        var curUrl = window.location.href;
        let vamcId = e.target.options[e.target.selectedIndex].value;
        //alert(vamcId);

        if(curUrl.includes("?vamc")) {
            var pos1 = curUrl.lastIndexOf("?vamc");
            curUrl = curUrl.substring(0, pos1);
        }
        let newUrl = `${curUrl}?vamc=${vamcId}`;
        window.location.href = newUrl;
    });

    $("#vamc_directory_visn_select").change (function(e) {

        var curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        alert(visnId);

        // if(curUrl.includes("?duration")) {
        //     var pos1 = curUrl.lastIndexOf("?duration");
        //     curUrl = curUrl.substring(0, pos1);
        // }
        // let duration = $( "#metrics_duration" ).val();
        // let newUrl = `${curUrl}?duration=${duration}`;
        // window.location.href = newUrl;
    });

    $("#vamc_type_select").change (function(e) {

        var curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        alert(visnId);

        // if(curUrl.includes("?duration")) {
        //     var pos1 = curUrl.lastIndexOf("?duration");
        //     curUrl = curUrl.substring(0, pos1);
        // }
        // let duration = $( "#metrics_duration" ).val();
        // let newUrl = `${curUrl}?duration=${duration}`;
        // window.location.href = newUrl;
    });
});