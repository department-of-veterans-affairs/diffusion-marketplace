(($) => {
  const $document = $(document);

  function loadTermsAndConditionsFn() {
    window.addEventListener("load", () => {
      if (forceModal) {
        // display modal on page load if user is logged in and didn't accept terms
        $("#dm-terms-and-conditions-modal").addClass("is-visible");
      }
      // prevent modal from flickering before page is fully rendered
      $("#dm-terms-and-conditions-modal > .usa-modal-overlay .usa-modal").removeClass("display-none");
    });
  }

  $document.on('turbolinks:load', loadTermsAndConditionsFn);
})(window.jQuery);
