const cp = {
  searchBtn: "#dm-created-practice-search-button",
  searchField: "#dm-created-practice-search-field",
  categoriesInput: "#dm-created-practice-categories",
  sortSelect: "#dm-created-practices-sort-option",
  loadMoreBtn: ".dm-load-more-created-practices-btn",
  loadMoreContainer:".dm-load-more-created-practices-container",
  practiceCardList: "#dm-created-practice-card-list",
  practiceCardSection: ".dm-created-practice-card-section",
  resultsCount: ".dm-created-practice-results-count",
  errorState: ".dm-created-practice-error-state",
  loadingSpinner: ".dm-created-practices-loading-spinner",
  searchNoResults: ".dm-created-practices-no-results"
}

function setFacilityCreatedPracticeSearchPage() {
  $(cp.sortSelect).val("a_to_z");
  searchEventListener();
  loadMoreEventListener();
  filterCategoriesEventListener();
  sortEventListener();
}

function sortEventListener() {
  $(cp.sortSelect).on("change", function (e) {
    setDataAndMakeRequest({ isNextPage: false });
  });
}

function loadMoreEventListener() {
  $(cp.loadMoreBtn).on("click", function(e) {
    setDataAndMakeRequest({isNextPage: true});
  })
}

function updateSelectedCategoriesUsage(sQuery, chosenCategories, category_id){
    Rails.ajax({
        type: 'patch',
        url: "/update_category_usage",
        data: jQuery.param({query: sQuery, chosenCategories: chosenCategories, catId: category_id })
    });
}

function filterCategoriesEventListener() {
  $(cp.categoriesInput).on("change", function(e) {
      var catId = e.target[e.target.selectedIndex].value;
      //update category usage/selected..
      updateSelectedCategoriesUsage(null, null, catId);

    setDataAndMakeRequest({ isNextPage: false });
  })
}

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

function searchEventListener() {
  $(cp.searchBtn).on("click", function(e) {
    e.preventDefault();
    let searchTerm = $(cp.searchField).val();
    updateSelectedCategoriesUsage(searchTerm, null, null);
    $(cp.searchField).data("search", searchTerm);
    trackSearch(searchTerm)
    setDataAndMakeRequest({ searchTerm: searchTerm });
  })
}

function displaySpinner({ isNextPage }) {
  $(cp.resultsCount).addClass("display-none");
  $(cp.errorState).addClass("display-none");
  $(cp.loadingSpinner).removeClass("display-none");
  $(cp.searchNoResults).first().addClass("display-none");
  if (isNextPage) {
    $(cp.loadMoreContainer).addClass("display-none");
    $(cp.loadMoreBtn).addClass("display-none");
  } else {
    $(cp.practiceCardSection).addClass("display-none");
  }
}

function hideSpinner() {
  $(cp.loadingSpinner).addClass("display-none");
  $(cp.practiceCardSection).removeClass("display-none");
  $(cp.loadMoreContainer).removeClass("display-none");
  $(cp.loadMoreBtn).removeClass("display-none");
}

function setDataAndMakeRequest({ isNextPage = false, searchTermInput }) {
  let page = $(cp.loadMoreBtn).data("next") || null;
  let sortOption = $(cp.sortSelect).val() || "a_to_z";
  let category = $(cp.categoriesInput).parent().find(".usa-select")[0].value
    ? parseInt($(cp.categoriesInput).parent().find(".usa-select")[0].value)
    : null;

  let searchTerm =
    $(cp.searchField).data("search").length > 0
      ? $(cp.searchField).data("search")
      : null;
   // sets the search term only when the user clicks search and is less confusing if a user updates the search input but never hits the search button
   $(cp.searchField).val(searchTerm);

  let data = { sort_option: sortOption };

  if (isNextPage && page !== null) {
    data.page = page;
  }

  if ((searchTermInput && searchTermInput.length > 0)) {
    data["search_term"] = searchTermInput;
  } else if (searchTerm) {
    data["search_term"] = searchTerm;
  }

  if (category) {
    data.categories = [category]
  }
  sendAjaxRequest(data);
}

function sendAjaxRequest(data) {
  displaySpinner({ isNextPage: data.page });
  let countText;

  $.ajax({
    type: 'GET',
    dataType: 'json',
    data: data,
    url: `/facilities/${facilitySlug}/created-practices`,
    success: function(result) {
      countText = result.count + ' result' + (result.count == 1 ? ':' : 's:');
      if (data.page == undefined) {
        $(cp.practiceCardList).empty();
      }

      $(cp.practiceCardList).append(result.practice_cards_html);

      if (result.count === 0) {
        $(cp.searchNoResults).first().removeClass("display-none");
      }

      if (result.count <= 1) {
        $(cp.sortSelect).parent().addClass("display-none");
      } else {
        $(cp.sortSelect).parent().removeClass("display-none");
      }

      if (result.next != null) {
        $(cp.loadMoreContainer).empty();
        $(cp.loadMoreContainer).append(
          `<button name="button" type="button" class="dm-button--outline-secondary dm-load-more-created-practices-btn" data-next="${result.next}">Load more</button>`
        );
        loadMoreEventListener();
      } else {
        $(cp.loadMoreContainer).empty();
      }
    },
    error: function(result) {
      $(cp.practiceCardList).addClass("display-none");
      $(cp.errorState).removeClass("display-none");
      $(cp.loadMoreContainer).empty();
      $(cp.loadMoreContainer).addClass("display-none");
      countText = "0 results:";
    },
    complete: function(result) {
      $(cp.resultsCount).text(countText);
      $(cp.resultsCount).removeClass("display-none");
      hideSpinner();
    }
  });
}

document.addEventListener('turbolinks:load', function () {
  setFacilityCreatedPracticeSearchPage();
  sendAjaxRequest({isNexPage: false});
});
