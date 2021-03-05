$(document).ready(function(){

    //event handlers for LI(s)
    $("#vamc_directory_select").change (function(e) {

        var curUrl = window.location.href;
        let vamcId = $( "#vamc_directory_select" ).val();
        alert(vamcId);

        // if(curUrl.includes("?duration")) {
        //     var pos1 = curUrl.lastIndexOf("?duration");
        //     curUrl = curUrl.substring(0, pos1);
        // }
        // let duration = $( "#metrics_duration" ).val();
        // let newUrl = `${curUrl}?duration=${duration}`;
        // window.location.href = newUrl;
    });
});