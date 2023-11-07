(($) => {
  const $document = $(document);

  function displayStatusDefinitionModalListener() {
    $document.arrive("body", { existing: true }, () => {
      let $statusModal = $("#facility-status-modal");
      $statusModal.find(".usa-modal").removeClass("display-none");
    });
  }

  function loadFacilityStatusDefinitionsModalFns() {
    displayStatusDefinitionModalListener();
  }

  $document.on("turbolinks:load", loadFacilityStatusDefinitionsModalFns);
})(window.jQuery);
