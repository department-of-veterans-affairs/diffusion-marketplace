$(document).ready(function(){
    let resultsExist = document.getElementById ("toggle_by_facility");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_facility, false);
    }

    resultsExist = document.getElementById ("toggle_by_common_name");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_common_name, false);
    }

    resultsExist = document.getElementById ("toggle_by_visn");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_visn, false);
    }

    resultsExist = document.getElementById ("toggle_by_type");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_type, false);
    }

    resultsExist = document.getElementById ("toggle_by_practices_created");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_practices_created, false);
    }
    resultsExist = document.getElementById ("toggle_by_adoptions");
    if(resultsExist){
        resultsExist.addEventListener ("click", toggle_by_adoptions, false);
    }
    let loadMoreBtn = document.getElementById ("btn_vamc_directory_load_more");
    if(loadMoreBtn){
        loadMoreBtn.addEventListener ("click", loadMoreRecords, false);
    }

    let loadMorePracticesBtn = document.getElementById ("btn_vamc_show_page_load_more");
    if(loadMorePracticesBtn){
        loadMorePracticesBtn.addEventListener ("click", loadMorePractices, false);
    }


    $("#vamc_directory_select").change (function(e) {
        //set VISN and TYPE filters back to - Select
        document.getElementById('vamc_directory_visn_select').value = '- Select -';
        document.getElementById('vamc_type_select').value = '- Select -';
        let curUrl = window.location.href;
        let vamcId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?vamc=${vamcId}`;
        window.location.href = newUrl;
    });

    $("#vamc_directory_visn_select").change (function(e) {
        //document.getElementById('vamc_directory_select').value = '';
        let type =  document.getElementById('vamc_type_select').value;
        let curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        let isDefault = visnId.length == 0 ? true : false;
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

    $("#vamc_type_select").change (function(e) {
        //document.getElementById('vamc_directory_select').value = '';
        var curUrl = window.location.href;
        let type = this.options[e.target.selectedIndex].text;
        var isDefault = type == "- Select -" ? true : false;
        let visnId =  document.getElementById('vamc_directory_visn_select').value;
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
            var pos1 = s.indexOf("?");
            return s.substring(0, pos1);
        }
        return s;
    }

    function toggle_by_facility(){
        let newUrl = addSortParams() + "facility";
        window.location.href = newUrl;
    }

    function toggle_by_common_name(){
        let newUrl = addSortParams() + "common_name";
        window.location.href = newUrl;
    }

    function toggle_by_visn(){
        let newUrl = addSortParams() + "visn";
        window.location.href = newUrl;
    }

    function toggle_by_type(){
        let newUrl = addSortParams() + "type";
        window.location.href = newUrl;
    }

    function toggle_by_practices_created(){
        let newUrl = addSortParams() + "practices_created";
        window.location.href = newUrl;
    }

    function toggle_by_adoptions(){
        let newUrl = addSortParams() + "adoptions";
        window.location.href = newUrl;
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
            for (var i = params_arr.length - 1; i >= 0; i -= 1) {
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
        let btn = document.getElementById("btn_vamc_directory_load_more");
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
        debugger
        let btn = document.getElementById("btn_vamc_show_page_load_more");
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

