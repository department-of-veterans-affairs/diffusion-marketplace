function _preventCrisisLineModalFlickerOnPageLoad() {
  $(document).arrive('header', { existing: true }, () => {
    removeDisplayNoneFromModal('#va-crisis-line-modal');
  });
}

function _preventHeaderElementFlickerOnPageLoad(selector) {
  $(document).arrive('header', { existing: true }, () => {
      $(selector).removeClass('display-none');
  });
}


function loadHeaderUtilitiesFn() {
  _preventCrisisLineModalFlickerOnPageLoad();
  _preventHeaderElementFlickerOnPageLoad('#browse-by-locations-dropdown')
  _preventHeaderElementFlickerOnPageLoad('#xr-network-dropdown')
}

$(document).on('turbolinks:load', loadHeaderUtilitiesFn);
