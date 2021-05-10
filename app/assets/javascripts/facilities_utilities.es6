$(document).ready(function(){
    const curUrl = window.location.href
    let sortTypes = ["facility", "common_name", "visn", "type", "practices_created", "adoptions"];
    for(let i=0; i < sortTypes.length; i++){
        let eleId = 'toggle_by_' +  sortTypes[i];
        let resultsExist = document.getElementById (eleId);
        if(resultsExist){
            document.addEventListener('click', function(e){
                if(e.target && e.target.id == eleId){
                    toggleByFieldName(sortTypes[i]);
                }
            })
        }
    }
    function toggleByFieldName(fieldName){
        let newUrl = addSortParams() + fieldName;
        window.location.href = newUrl;
    }

    $("#facility_directory_select").change (function(e) {
        //set VISN and TYPE filters back to - Select
        document.getElementById('facility_directory_visn_select').value = '- Select -';
        document.getElementById('facility_type_select').value = '- Select -';
        let facilityId = e.target.options[e.target.selectedIndex].value;
        if (facilityId != facilityParam) {
          let strippedUrl = stripQsParams(curUrl);
          let newUrl = `${strippedUrl}?facility=${facilityId}`;
          window.location.href = newUrl;
        }
    });

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

    function stripQsParams(s){
        if (s.includes("?")){
            let pos1 = s.indexOf("?");
            return s.substring(0, pos1);
        }
        return s;
    }

    function addSortParams(){
        let paramAsc = getParameterByName("asc", newUrl)
        let newUrl = removeParam("asc", curUrl);
        newUrl = removeParam("sortby", newUrl);
        newUrl.includes("?") ? newUrl += "&" : newUrl += "?";
        newUrl += "asc=";
        if(paramAsc == null){
            newUrl += "false";
        }
        else{
            paramAsc == "true" ? newUrl += "false" : newUrl += "true";
        }
        newUrl += "&sortby=";
        return newUrl;
    }

    function removeParam(key, sourceURL) {
        let rtn = sourceURL.split("?")[0],
            param,
            params_arr = [],
            queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
        if (queryString !== "") {
            params_arr = queryString.split("&");
            for (let i = params_arr.length - 1; i >= 0; i -= 1) {
                param = params_arr[i].split("=")[0];
                if (param === key) {
                    params_arr.splice(i, 1);
                }
            }
            if (params_arr.length) rtn = rtn + "?" + params_arr.join("&");
        }
        return rtn;
    }

    function getParameterByName(name, url = window.location.href) {
        name = name.replace(/[\[\]]/g, '\\$&');
        let regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }

    $("#dm-adopted-practices-search-button").click (function(e) {
        e.preventDefault();
        let selectedCategories = document.getElementsByName("facility_category_select_adoptions");
        let selectedCategory = selectedCategories[0].value;
        let keyWord = document.getElementById("dm-adopted-practices-search-field").value;
        let facilityStationNumber = document.getElementById("facility_station_number").value;
        Rails.ajax({
            type: 'get',
            url: "/update_practices_adopted_at_facility",
            data: jQuery.param({selected_category: selectedCategory, key_word: keyWord, station_number: facilityStationNumber}),
            success: function(result) {
                if(result[1] === "0 results:"){
                    practicesAdoptedAtThisFacilityNoResults(result[1]);
                }
                else{
                    practicesAdoptedAtThisFacilityResults(result[0], result[1]);
                }
            }
        });
    });

    $("#facility_category_select_adoptions").change (function(e) {
        let selectedCategories = document.getElementsByName("facility_category_select_adoptions");
        let selectedCategory = selectedCategories[0].value;
        let keyWord = document.getElementById("dm-adopted-practices-search-field").value;
        let facilityStationNumber = document.getElementById("facility_station_number").value;
        Rails.ajax({
            type: 'get',
            url: "/update_practices_adopted_at_facility",
            data: jQuery.param({selected_category: selectedCategory, key_word: keyWord, station_number: facilityStationNumber}),
            success: function(result) {
                if(result[1] === "0 results:"){
                    practicesAdoptedAtThisFacilityNoResults(result[1]);
                }
                else{
                    practicesAdoptedAtThisFacilityResults(result[0], result[1]);
                }
            }
        });
    });
});

function practicesAdoptedAtThisFacilityNoResults(resultMsg1)
{
    let practicesAdoptedNoResults =  document.getElementById("practices_adopted_no_results");
    let facilityTable = document.getElementById("practices_adopted_at_this_facility_table");
    let practicesAdoptedAtFacilityCount = document.getElementById("practices_adopted_at_facility_count");
    if (practicesAdoptedNoResults){
        practicesAdoptedNoResults.style.display = "block";
    }
    if (facilityTable){
        facilityTable.style.display = "none";
    }
    if (practicesAdoptedAtFacilityCount){
        practicesAdoptedAtFacilityCount.innerHTML = resultMsg1;
    }
    $(".search-no-results").last().removeClass("display-none");
}

function practicesAdoptedAtThisFacilityResults(result0, result1)
{
    document.getElementById("practices_adopted_no_results").style.display = "none";
    document.getElementById("practices_adopted_at_this_facility_table").style.display = "block";
    document.getElementById("practices_adopted_by_facility_dyn").innerHTML = result0;
    document.getElementById("practices_adopted_at_facility_count").innerHTML = result1;
}
