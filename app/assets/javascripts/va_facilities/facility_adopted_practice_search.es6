function trackSearch(term) {
    if (term !== '') {
        ahoy.track("Facility practice search", { search_term: term });
        if (typeof ga === "function") {
            ga("send", {
                hitType: "event",
                eventCategory: "Facility search",
                eventAction: "Facility search",
                location: `/facilities/${facilitySlug}`
            });
        }
    }
}

function practicesAdoptedAtThisFacilityNoResults()
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
        practicesAdoptedAtFacilityCount.innerHTML = "0 results: ";
    }
    $(".search-no-results").last().removeClass("display-none");
}

function practicesAdoptedAtThisFacilityResults(result)
{
    document.getElementById("practices_adopted_no_results").style.display = "none";
    document.getElementById("practices_adopted_at_this_facility_table").style.display = "block";
    $("#practices_adopted_by_facility_dyn").empty();
    $("#practices_adopted_by_facility_dyn").append(result.adopted_facility_results_html);
    document.getElementById("practices_adopted_at_facility_count").innerHTML = `${result.count} result${result.count != 1 ? 's' : ''}:`;
}

function ajaxUpdateSearchResults(){
    let selectedCategory = document.getElementsByName("facility_category_select_adoptions")[0].value;
    let keyWord = document.getElementById("dm-adopted-practices-search-field").value;
    let facilityStationNumber = document.getElementById("facility_station_number").value;
    Rails.ajax({
        type: 'get',
        dataType: 'json',
        url: `/facilities/${facilitySlug}/update_practices_adopted_at_facility`,
        data: jQuery.param({selected_category: selectedCategory, key_word: keyWord, station_number: facilityStationNumber}),
        success: function(result) {
            if(result.count === 0){
                practicesAdoptedAtThisFacilityNoResults();
            }
            else{
                practicesAdoptedAtThisFacilityResults(result);
            }
        }
    });
}

function updateSearchResultsOnSearchButtonClick(){
    $("#dm-adopted-practices-search-button").click (function(e) {
        e.preventDefault();
        ajaxUpdateSearchResults();
        let keyWord = document.getElementById("dm-adopted-practices-search-field").value;
        trackSearch(keyWord);
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