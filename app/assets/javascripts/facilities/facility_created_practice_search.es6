const searchBtn = "#dm-created-practice-search-button";
const searchField = "#dm-created-practice-search-field";
const categoriesInput = "#dm-created-practice-categories";
const sortSelect = "#dm-created-practices-sort-option";
const loadMoreBtn = ".dm-load-more-created-practices-btn";
const loadMoreContainer = ".dm-load-more-created-practices-container";
const practiceCardList = "#dm-created-practice-card-list";
const practiceCardSection = ".dm-created-practice-card-section";
const resultsCount = ".dm-created-practice-results-count";
const errorState = ".dm-created-practice-error-state ";
const loadingSpinner = ".dm-created-practices-loading-spinner";
const searchNoResults = ".search-no-results";

function setFacilityCreatedPracticeSearchPage() {
  searchEventListener();
  loadMoreEventListener();
  filterCategoriesEventListener();
  sortEventListener();
}

function sortEventListener() {
  $(sortSelect).on("change", function (e) {
    setDataAndMakeRequest({ isNextPage: false });
  });
}

function loadMoreEventListener() {
  $(loadMoreBtn).on("click", function(e) {
    setDataAndMakeRequest({isNextPage: true});
  })
}

function filterCategoriesEventListener() {
  $(categoriesInput).on("change", function(e) {
    setDataAndMakeRequest({ isNextPage: false });
  })
}

function searchEventListener() {
  $(searchBtn).on("click", function(e) {
    e.preventDefault();
    let searchTerm = $(searchField).val();
    $(searchField).data("search", searchTerm);
    setDataAndMakeRequest({searchTerm: searchTerm});
  })
}

function displaySpinner({ isNextPage }) {
  $(resultsCount).addClass("display-none");
  $(errorState).addClass("display-none");
  $(loadingSpinner).removeClass("display-none");
  $(loadingSpinner).addClass("display-flex");
  $(searchNoResults).addClass("display-none");
  if (isNextPage) {
    $(loadMoreContainer).addClass("display-none");
    $(loadMoreBtn).addClass("display-none");
  } else {
    $(practiceCardSection).addClass("display-none");
  }
}

function hideSpinner() {
  $(loadingSpinner).addClass("display-none");
  $(loadingSpinner).removeClass("display-flex");
  $(practiceCardSection).removeClass("display-none");
  $(loadMoreContainer).removeClass("display-none");
  $(loadMoreBtn).removeClass("display-none");
}

function setDataAndMakeRequest({ isNextPage = false, searchTermInput }) {
  let page = $(loadMoreBtn).data('next') || null;
  let sortOption = $(sortSelect).val() || 'a_to_z';
  let category = $(categoriesInput).parent().find(".usa-select")[0].value
    ? parseInt($(categoriesInput).parent().find(".usa-select")[0].value)
    : null;
  let searchTerm = $(searchField).data('search').length > 0 ? $(searchField).data('search') : null;

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
        $(practiceCardList).empty();
      }

      $(practiceCardList).append(result.practice_cards_html);

      if (result.count === 0) {
        $(searchNoResults).removeClass('display-none');
      }

      if (result.count <= 1) {
        $(sortSelect).parent().addClass('display-none');
      } else {
        $(sortSelect).parent().removeClass("display-none");
      }

      if (result.next != null) {
        $(loadMoreContainer).empty();
        $(loadMoreContainer).append(
          `<button name="button" type="button" class="usa-button--outline dm-btn-base dm-load-more-created-practices-btn" data-next="${result.next}">Load more</button>`
        );
        loadMoreEventListener();
      } else {
        $(loadMoreContainer).empty();
      }
    },
    error: function(result) {
      $(practiceCardList).addClass("display-none");
      $(errorState).removeClass("display-none");
      $(loadMoreContainer).empty();
      $(loadMoreContainer).addClass("display-none");
      countText = "0 results:";
    },
    complete: function(result) {
      $(resultsCount).text(countText);
      $(resultsCount).removeClass("display-none");
      hideSpinner();
    }
  });
}

document.addEventListener('turbolinks:load', function () {
  $(sortSelect).val("a_to_z");
  setFacilityCreatedPracticeSearchPage();
});
