(($) => {
  const $document = $(document);

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
    _preventHeaderElementFlickerOnPageLoad('#va-immersive-dropdown')
  }

  $document.on('turbolinks:load', loadHeaderUtilitiesFn);
})(window.jQuery);
