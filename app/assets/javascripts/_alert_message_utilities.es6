const CLOSE_ALERT_MESSAGE_ELE = '.close-alert-message';

(($) => {
  const $document = $(document);

  function removeAlertMessage() {
    $(CLOSE_ALERT_MESSAGE_ELE).on("click", function () {
      $(this).closest(".usa-alert").remove();
    });
  }

  function addRightPaddingToAlertMessages() {
    $(CLOSE_ALERT_MESSAGE_ELE)
      .closest(".usa-alert__body")
      .css("padding-right", "3.83333rem");
  }

  function attachScrollToTopListener() {
    $document.arrive(".js-publication-validation--alert", { existing: true }, () => {
        window.scrollTo(0, 0);
      }
    );
  }

  function execAlertMessageFunctions() {
    removeAlertMessage();
    addRightPaddingToAlertMessages();
    attachScrollToTopListener();
  }

  $document.on("turbolinks:load", execAlertMessageFunctions);
})(window.jQuery);