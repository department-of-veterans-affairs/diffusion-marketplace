const CLOSE_ALERT_MESSAGE_ELE = '.close-alert-message';

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

function execAlertMessageFunctions() {
  removeAlertMessage();
  addRightPaddingToAlertMessages();
}

$(document).on("turbolinks:load", execAlertMessageFunctions);