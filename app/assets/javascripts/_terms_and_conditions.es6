(($) => {
  const $document = $(document);

  function loadTermsAndConditionsFn() {
    let $termsModal = $("#dm-terms-and-conditions-modal");

    $(document).arrive('body', { existing: true }, () => {
      $termsModal.removeClass("display-none");

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
