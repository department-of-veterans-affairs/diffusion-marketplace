const ap = {
  loadingSpinner: ".dm-adopted-practices-loading-spinner",
  searchField: "#dm-adopted-practices-search-field",
  noResults: ".dm-adopted-practices-no-results",
  table: "#practices_adopted_at_this_facility_table",
  counter: "#practices_adopted_at_facility_count",
  tableRows: "#practices_adopted_by_facility_dyn",
};

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

function ajaxUpdateSearchResults(updateCat = true) {
  _displaySpinner({ display: true })
  let selectedCategory = $('select[name="facility_category_select_adoptions"]').val();
  let keyWord = $(ap.searchField).data("search").length > 0 ? $(ap.searchField).data("search") : null;

  //updates selected category for usage stats..... dm-2800
    if(updateCat) {
        updateSelectedCategoriesUsage({
            category_id: selectedCategory
        });
    }
  // sets the search term only when the user clicks search and is less confusing if a user updates the search input but never hits the search button
  $(ap.searchField).val(keyWord);

  Rails.ajax({
    type: 'get',
    dataType: 'json',
    url: `/facilities/${facilitySlug}/update_practices_adopted_at_facility`,
    data: jQuery.param({ selected_category: selectedCategory, key_word: keyWord }),
    success: function(result) {
      _setResultCount({ count: result.count })
      if (result.count === 0) {
        $(ap.noResults).removeClass('display-none');
      }
      else {
        $(ap.table).removeClass("display-none");
        $(ap.tableRows).removeClass('display-none');
        $(ap.tableRows).empty();
        $(ap.tableRows).append(result.adopted_facility_results_html);
      }
      _displaySpinner({ display: false })
    }
  });
}

function _displaySpinner({ display }) {
  if (display) {
    $(ap.noResults).addClass("display-none");
    $(ap.counter).addClass('display-none');
    $(ap.table).addClass('display-none');
    $(ap.loadingSpinner).removeClass('display-none');
  } else {
    $(ap.counter).removeClass("display-none");
    $(ap.loadingSpinner).addClass("display-none")
  }
}

function _setResultCount({ count }) {
  let text = `${count} result${count != 1 ? "s" : ""}:`;
  $(ap.counter).text(text);
}

function attachSearchButtonClickListener() {
  $("#dm-adopted-practices-search-button").click (function(e) {
    e.preventDefault();
    let keyWord = $(ap.searchField).val();
    if(keyWord.length == 0){
        return;
    }
    updateSelectedCategoriesUsage({
        sQuery: keyWord
    });
    $(ap.searchField).data("search", keyWord);
    trackSearch(keyWord);
    ajaxUpdateSearchResults(false);
  });
}

function attachCategorySelectListener() {
  $("#facility_category_select_adoptions").change (function() {
    ajaxUpdateSearchResults();
  });
}

document.addEventListener('turbolinks:load', function() {
  attachSearchButtonClickListener();
  attachCategorySelectListener();
  ajaxUpdateSearchResults();
});
