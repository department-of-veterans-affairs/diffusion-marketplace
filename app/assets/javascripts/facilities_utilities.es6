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

    let loadMoreBtn = document.getElementById ("btn_facility_directory_load_more");
    if(loadMoreBtn){
        loadMoreBtn.addEventListener ("click", loadMoreRecords, false);
    }

    let loadMorePracticesBtn = document.getElementById ("btn_factility_show_page_load_more");
    if(loadMorePracticesBtn){
        loadMorePracticesBtn.addEventListener ("click", loadMorePractices, false);
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

    function loadMoreRecords(){
        let btn = document.getElementById("btn_facility_directory_load_more");
        let numRecs = parseInt(btn.getAttribute("num_recs"));
        numRecs += 20;
        let paramMore = getParameterByName("more", newUrl)
        let newUrl = removeParam("more", curUrl);
        newUrl.includes("?") ? newUrl += "&" : newUrl += "?";
        newUrl += `more=${numRecs}`;
        window.location.href = newUrl;
    }

    function loadMorePractices(){
        let btn = document.getElementById("btn_facility_show_page_load_more");
        let numPracticeRecs = parseInt(btn.getAttribute("num_practice_recs"));
        numPracticeRecs += 3;
        let paramMore = getParameterByName("more", newUrl)
        let newUrl = removeParam("more", curUrl);
        newUrl.includes("?") ? newUrl += "&" : newUrl += "?";
        newUrl += `practices=${numPracticeRecs}`;
        window.location.href = newUrl;
    }

    $("#dm-adopted-practices-search-button").click (function(e) {
        var result = document.getElementById("dm-adopted-practices-search-field").value
        alert(result);
    });

    $("#facility_category_select_adoptions").change (function(e) {
        let selectedCategory = document.getElementById("facility_category_select_adoptions").value
        let facilityStationNumber = document.getElementById("facility_station_number").value
        //alert(result);
        Rails.ajax({
            type: 'post',
            url: "/update_practices_adopted_at_facility",
            data: jQuery.param({selected_category: selectedCategory, station_number: facilityStationNumber}),
            success: function(result) {
                document.getElementById("va_facility_adoption_results").innerHTML = result[0]
                document.getElementById("practices_adopted_at_facility_count").innerHTML = result[1]
            }
        });
    });
});

