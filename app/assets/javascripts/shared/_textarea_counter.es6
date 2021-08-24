(($) => {
  const $document = $(document);
  const CHARACTER_COUNTER_INVALID_COLOR = "#b50909"; // $theme-color-error-dark
  const CHARACTER_COUNTER_VALID_COLOR = "#adadad"; // $theme-color-base-light
  const MAX_CHARACTER_COUNT = maxCharCount;
  const TEXTAREA_CLASS = `.${textareaClass}`;
  const COUNTER_CLASS = `.${counterClass}`;

  function _countChars(textarea) {
    let currentLength = $(textarea).val().length;
    if (currentLength >= 0) {
      let characterCounter = `(${currentLength}/${MAX_CHARACTER_COUNT} character${
        currentLength !== 1 ? "s" : ""
      })`;
      let counter = $(textarea).parent().parent().find(COUNTER_CLASS);
      $(counter).css("color", CHARACTER_COUNTER_VALID_COLOR);
      $(counter).text(characterCounter);
      if (currentLength >= MAX_CHARACTER_COUNT) {
        $(counter).css("color", CHARACTER_COUNTER_INVALID_COLOR);
      }
    }
  }

  function onTextAreaArriveListener() {
    $document.arrive(TEXTAREA_CLASS, (e) => {
      _countChars(e);
      maxCharactersListener(e);
    });
  }

  function maxCharactersListener(textarea) {
    $(textarea).off("input");
    $(textarea).on("input", (e) => {
      _countChars(e.currentTarget);
    });
  }

  function loadTextareaCounterFns() {
    let $textareas = $(TEXTAREA_CLASS);
    $textareas.each((k, ta) => {
      _countChars(ta);
      maxCharactersListener(ta);
    });
    onTextAreaArriveListener();
  }

  $document.on("turbolinks:load", loadTextareaCounterFns);
})(window.jQuery);
