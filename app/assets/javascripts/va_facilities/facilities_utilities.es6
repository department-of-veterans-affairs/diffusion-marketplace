const visnSelect = "#facility_visn_select";
const complexitySelect = "#facility_type_select";
const facilitiesComboBox = "#facility_facilities_combo_box";
const loadingSpinner = ".dm-loading-spinner";
const facilitiesIndex = "#dm-va-facilities-index";
const tableRows = ".dm-facilities-table-rows";
const table = "#dm-va-facilities-directory-table";
const facilitiesIndexView = ".dm-facilities-index-view";
const noResults = ".search-no-results";
const comboBoxClearBtn = ".usa-combo-box__clear-input";
let autoClearClicked = false;
let isFacilityFilter = true;

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
    if (visn || complexity) {
      _sendAjaxRequest({ visn, complexity });
    }
  })
}

function _sendAjaxRequest(data = null) {
  _toggleSpinners({ displaySpinner: true })
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
        // if facility combo box is selected
        if (isFacilityFilter) {
          _clearSelect();
        } else {
          autoClearClicked = true;
          $(comboBoxClearBtn).click();
        }
        // reset to defaults
        autoClearClicked = false;
        isFacilityFilter = true;
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
    $(facilitiesIndexView).addClass("display-none");
    $(noResults).addClass("display-none");
    $(table).addClass("display-none");
  } else {
    $(loadingSpinner).addClass("display-none");
    $(facilitiesIndexView).removeClass("display-none");
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
