(($) => {
  const $document = $(document);

  function _preventTermsAndConditionsFlickerOnPageLoad() {
    $(document).arrive("header", { existing: true }, () => {
      removeDisplayNoneFromModal("#dm-terms-and-conditions-modal");
    });
  }

  function _forceDisplayModal() {
    $(document).arrive("footer", { existing: true }, () => {
      if (forceModal) {
        let $termsModal = $("#dm-terms-and-conditions-modal");
        // display modal on page load if user is logged in and didn't accept terms
        $termsModal.addClass("is-visible");
        $termsModal.removeClass("is-hidden");
      }
    });
  }

  function loadTermsAndConditionsFn() {
    _preventTermsAndConditionsFlickerOnPageLoad();
    _forceDisplayModal();
  }

  $document.on('turbolinks:load', loadTermsAndConditionsFn);
})(window.jQuery);