$(document).ready(function(){
    //event handlers for LI(s)
    $("#vamc_directory_select").change (function(e) {
        //set VISN and TYPE filters back to - Select
        document.getElementById('vamc_directory_visn_select').value = '- Select -';
        document.getElementById('vamc_type_select').value = '- Select -';
        var curUrl = window.location.href;
        let vamcId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?vamc=${vamcId}`;
        window.location.href = newUrl;
    });

    $("#vamc_directory_visn_select").change (function(e) {
        document.getElementById('vamc_directory_select').value = '';
        let type =  document.getElementById('vamc_type_select').value;
        var curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        var isDefault = visnId.length == 0 ? true : false;
        curUrl = stripQsParams(curUrl);
        var newUrl = curUrl;
        if(!isDefault){
            newUrl = `?visn=${visnId}`;
        }
        if (type.length > 0 && type != '- Select -'){
            isDefault ? newUrl += "?" : newUrl += "&";
            newUrl += `type=${type}`;
        }
        window.location.href = newUrl;
    });

    $("#vamc_type_select").change (function(e) {
        document.getElementById('vamc_directory_select').value = '';
        var curUrl = window.location.href;
        let type = this.options[e.target.selectedIndex].text;
        var isDefault = type == "- Select -" ? true : false;
        let visnId =  document.getElementById('vamc_directory_visn_select').value;
        curUrl = stripQsParams(curUrl);
        var newUrl = curUrl;
        if (!isDefault){
            newUrl = `?type=${type}`;
        }
        if(visnId.length > 0 && visnId != '- Select -'){
            isDefault ? newUrl += "?" : newUrl += "&";
            newUrl += `visn=${visnId}`;
        }
        window.location.href = newUrl;
    });

    function stripQsParams(s){
        if (s.includes("?")){
            var pos1 = s.indexOf("?");
            return s.substring(0, pos1);
        }
        return s;
    }
});

