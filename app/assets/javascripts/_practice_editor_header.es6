(($) => {
  function preventCloseModalFlickerOnPageLoad() {
    $(document).arrive("header", { existing: true }, () => {
      $("#dm-practice-editor-close-modal").find(".usa-modal--lg").removeClass("display-none");
    });
  }

  function preventEditingGuideModalFlickerOnPageLoad() {
    $(document).arrive('header', { existing: true }, () => {
      $('#editing-guide-modal').find('.usa-modal').removeClass('display-none');
    });
  }

  function initPracticeEditorHeaderFns() {
    preventCloseModalFlickerOnPageLoad();
    preventEditingGuideModalFlickerOnPageLoad();
  }

  $(document).on("turbolinks:load", initPracticeEditorHeaderFns);
})(window.jQuery);
