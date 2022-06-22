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

  function loadHeaderUtilitiesFn() {
    _preventBrowseByLocationsDropdownFlickerOnPageLoad();
    _preventCrisisLineModalFlickerOnPageLoad();
  }

  $document.on('turbolinks:load', loadHeaderUtilitiesFn);
})(window.jQuery);
