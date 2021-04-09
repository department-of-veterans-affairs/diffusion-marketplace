$(document).ready(function(){
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
        let curUrl = window.location.href;
        let facilityId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?facility=${facilityId}`;
        window.location.href = newUrl;
    });

    $("#facility_directory_visn_select").change (function(e) {
        let type =  document.getElementById('facility_type_select').value;
        let curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        let isDefault = visnId.length === 0
        curUrl = stripQsParams(curUrl);
        let newUrl = curUrl;
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
        let curUrl = window.location.href;
        let type = this.options[e.target.selectedIndex].text;
        let isDefault = type === "- Select -"
        let visnId =  document.getElementById('facility_directory_visn_select').value;
        curUrl = stripQsParams(curUrl);
        let newUrl = curUrl;
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
        let curUrl = window.location.href;
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
        let curUrl = window.location.href;
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
        let curUrl = window.location.href;
        let paramMore = getParameterByName("more", newUrl)
        let newUrl = removeParam("more", curUrl);
        newUrl.includes("?") ? newUrl += "&" : newUrl += "?";
        newUrl += `practices=${numPracticeRecs}`;
        window.location.href = newUrl;
    }

});

