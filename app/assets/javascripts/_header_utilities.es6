(($) => {
  const $document = $(document);

  function _preventCrisisLineModalFlickerOnPageLoad() {
    $(document).arrive('header', { existing: true }, () => {
      removeDisplayNoneFromModal('#va-crisis-line-modal');
    });
  }

  function _preventBrowseByLocationsDropdownFlickerOnPageLoad() {
    $(document).arrive('header', { existing: true }, () => {
      $("#browse-by-locations-dropdown").removeClass('display-none');
    });
  }

    function _preventXRNetworkDropdownFlickerOnPageLoad() {
        $(document).arrive('header', { existing: true }, () => {
            $("#xr-network-dropdown").removeClass('display-none');
        });
    }

  function loadHeaderUtilitiesFn() {
    _preventBrowseByLocationsDropdownFlickerOnPageLoad();
    _preventCrisisLineModalFlickerOnPageLoad();
    _preventXRNetworkDropdownFlickerOnPageLoad();
  }

  $document.on('turbolinks:load', loadHeaderUtilitiesFn);
})(window.jQuery);
