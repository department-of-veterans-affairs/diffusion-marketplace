const curUrl = window.location.href
function stripQsParams(s){
    if (s.includes("?")){
        let pos1 = s.indexOf("?");
        return s.substring(0, pos1);
    }
    return s;
}

function updateResultsBasedOnFacilityComboSelect(){
    $("#facility_directory_select").change (function(e) {
        //set VISN and TYPE filters back to - Select
        document.getElementById('facility_directory_visn_select').value = '- Select -';
        document.getElementById('facility_type_select').value = '- Select -';
        let strippedUrl = stripQsParams(curUrl);
        if($(this).val() == null){
            window.location.href = strippedUrl;
        }
        else if ($(this).val() != facilityParam) {
            let newUrl = `${strippedUrl}?facility=${$(this).val()}`;
            window.location.href = newUrl;
        }

    });
}


function updateResultsBasedOnVisnSelect() {
    $("#facility_directory_visn_select").change (function(e) {
        let type =  document.getElementById('facility_type_select').value;
        let visnId = e.target.options[e.target.selectedIndex].value;
        let isDefault = visnId.length === 0
        let strippedUrl = stripQsParams(curUrl);
        let newUrl = strippedUrl;
        if(!isDefault){
            newUrl = `?visn=${visnId}`;
        }
        if (type.length > 0 && type != '- Select -'){
            isDefault ? newUrl += "?" : newUrl += "&";
            newUrl += `type=${type}`;
        }
        window.location.href = newUrl;
    });
}

function updateResultsBasedOnComplexitySelect() {
    $("#facility_type_select").change (function(e) {
        let type = this.options[e.target.selectedIndex].text;
        let isDefault = type === "- Select -"
        let visnId =  document.getElementById('facility_directory_visn_select').value;
        let strippedUrl = stripQsParams(curUrl);
        let newUrl = strippedUrl;
        if (!isDefault){
            newUrl = `?type=${type}`;
        }
        if(visnId.length > 0 && visnId != '- Select -'){
            isDefault ? newUrl += "?" : newUrl += "&";
            newUrl += `visn=${visnId}`;
        }
        window.location.href = newUrl;
    });
}


function execAdoptedSearchFunctions(){
    updateResultsBasedOnFacilityComboSelect();
    updateResultsBasedOnComplexitySelect();
    updateResultsBasedOnVisnSelect();
}

document.addEventListener('turbolinks:load', function() {
    execAdoptedSearchFunctions();
});
