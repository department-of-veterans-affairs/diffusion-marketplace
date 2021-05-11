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

function ajaxUpdateSearchResults(){
    let selectedCategory = document.getElementsByName("facility_category_select_adoptions")[0].value;
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
}

function updateSearchResultsOnSearchButtonClick(){
    $("#dm-adopted-practices-search-button").click (function(e) {
        e.preventDefault();
        ajaxUpdateSearchResults();
    });
}

function updateSearchResultsBasedOnCategorySelect(){
    $("#facility_category_select_adoptions").change (function(e) {
        ajaxUpdateSearchResults();
    });
}

document.addEventListener('turbolinks:load', function() {
    updateSearchResultsOnSearchButtonClick();
    updateSearchResultsBasedOnCategorySelect();
});