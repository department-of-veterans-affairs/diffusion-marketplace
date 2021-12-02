const visnSelect = "#facility_visn_select";
const complexitySelect = "#facility_type_select";
const facilitiesComboBox = "#facility_facilities_combo_box";
const loadingSpinner = ".dm-loading-spinner";
const facilitiesIndex = "#dm-va-facilities-index";
const tableRows = ".dm-facilities-table-rows";
const table = "#dm-va-facilities-directory-table";
const facilitySearchResultsContainer = ".facility-search-results-container";
const noResults = ".search-no-results";
const comboBoxClearBtn = ".usa-combo-box__clear-input";
let autoClearClicked = false;
let isFacilityFilter = true;
let visnSelected = false;
let complexitySelected = false;

function attachFacilitiesComboBoxListener() {
  $(facilitiesComboBox).on('change', (e) => {
    _setReloadData(true)
    let facility = parseInt($(e.currentTarget).val());
    if (facility) {
      isFacilityFilter = true;
      _sendAjaxRequest({ facility });
    }
  })
}

function attachVisnSelectListener() {
  $(visnSelect).on('change', () => {
    _setReloadData(true);
    let visn = $(visnSelect).val();
    let complexity = $(complexitySelect).val();
    isFacilityFilter = false;
    visnSelected = true;
    if (visn || complexity) {
      _sendAjaxRequest({ visn, complexity });
    }
  });
}

function attachComplexitySelectListener() {
  $(complexitySelect).on('change', () => {
    _setReloadData(true);
    let visn = $(visnSelect).val();
    let complexity = $(complexitySelect).val();
    isFacilityFilter = false;
    complexitySelected = true;
    if (visn || complexity) {
      _sendAjaxRequest({ visn, complexity });
    }
  });
}

function _sendAjaxRequest(data = null) {
  _toggleSpinners({ displaySpinner: true });
  // disable the filter inputs while the data is loading
  $(visnSelect).attr('disabled', 'true');
  $(complexitySelect).attr('disabled', 'true');
  $(facilitiesComboBox).attr('disabled', 'true');
  if (_getReloadData()) {
    $.ajax({
      type: "GET",
      data: data,
      dataType: "json",
      url: "/facilities/load-facilities-rows",
      success: function (data) {
        $(tableRows).empty();
        if (data.count > 0) {
          $(table).removeClass("display-none");
          $(tableRows).append(data.rowsHtml);
        } else {
          $(noResults).removeClass("display-none");
        }
        // enable the inputs
        $(visnSelect).removeAttr('disabled');
        $(complexitySelect).removeAttr('disabled');
        $(facilitiesComboBox).removeAttr('disabled');
        $(comboBoxClearBtn).removeAttr('disabled');
        // if facility combo box is selected
        if (isFacilityFilter) {
          _clearSelect();
          $(facilitiesComboBox).focus();
        } else {
          autoClearClicked = true;
          $(comboBoxClearBtn).click();
          // if one of the select inputs triggered this function, move focus back to whichever one was previously chosen
          if (visnSelected) {
              $(visnSelect).focus();
          } else if (complexitySelected) {
              $(complexitySelect).focus();
          }
        }
        // reset to defaults
        autoClearClicked = false;
        isFacilityFilter = true;
        visnSelected = false;
        complexitySelected = false;
        _setCounterText(data.count);
        _toggleSpinners({ displaySpinner: false });
        _setReloadData(false);
      },
    });
  }
}

function attachComboBoxClearArrivalListener() {
  $(document).arrive(comboBoxClearBtn, (input) => {
    $(input).on("click", () => {
      _setReloadData(true);
      // makes sure we don't send another request when we automatically cleared the combo box input
      if (!autoClearClicked) {
        _sendAjaxRequest();
      }
    });
  });
}

function _clearSelect() {
  $(visnSelect).val("");
  $(complexitySelect).val("");
}

function _setCounterText(count) {
  let counterText = `Displaying ${count} result${count === 1 ? '' : 's'}:`;
  $('.dm-results-count').text(counterText);
}

function _toggleSpinners({ displaySpinner }) {
  if (displaySpinner) {
    $(loadingSpinner).removeClass("display-none");
    $(facilitySearchResultsContainer).addClass("display-none");
    $(noResults).addClass("display-none");
    $(table).addClass("display-none");
  } else {
    $(loadingSpinner).addClass("display-none");
    $(facilitySearchResultsContainer).removeClass("display-none");
    $(table).removeClass("display-none");
  }
}

function _setReloadData(bool) {
  $(facilitiesIndex).data("reload", bool);
}

function _getReloadData() {
  return $(facilitiesIndex).data("reload");
}

function execFacilitiesIndexFns() {
  // make sure we don't reload the page when we click links on the facilities index page
  if (_getReloadData()) {
    _sendAjaxRequest();
    attachVisnSelectListener();
    attachComplexitySelectListener();
    attachFacilitiesComboBoxListener();
    attachComboBoxClearArrivalListener();
  }
}

document.addEventListener('turbolinks:load', function() {
  execFacilitiesIndexFns();
});
