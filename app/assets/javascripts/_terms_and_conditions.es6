(($) => {
  const $document = $(document);

  function loadTermsAndConditionsFn() {
    $(document).arrive("footer", { existing: true }, () => {
      if (forceModal) {
        let $termsModal = $("#dm-terms-and-conditions-modal");
        // display modal on page load if user is logged in and didn't accept terms
        $termsModal.addClass("is-visible");
        $termsModal.removeClass("is-hidden");
      }
    });
  }

  $document.on('turbolinks:load', loadTermsAndConditionsFn);
})(window.jQuery);
