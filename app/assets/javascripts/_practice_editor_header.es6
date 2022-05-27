(($) => {
  function preventCloseModalFlickerOnPageLoad() {
    $(document).arrive("header", { existing: true }, () => {
      $("#dm-practice-editor-close-modal").find(".usa-modal--lg").removeClass("display-none");
    });
  }

  function initPracticeEditorHeaderFns() {
    preventCloseModalFlickerOnPageLoad();
  }

  $(document).on("turbolinks:load", initPracticeEditorHeaderFns);
})(window.jQuery);
