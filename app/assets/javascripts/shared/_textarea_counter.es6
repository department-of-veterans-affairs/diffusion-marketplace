(($) => {
  const $document = $(document);
  const CHARACTER_COUNTER_INVALID_COLOR = "#e52207"; // $dm-color-red-50v
  const CHARACTER_COUNTER_VALID_COLOR = "#a9aeb1"; // $dm-color-gray-cool-30
  const MAX_CHARACTER_COUNT = maxCharCount;
  const TEXTAREA_CLASS = `.${textareaClass}`;
  const COUNTER_CLASS = `.${counterClass}`;

  function characterCounter(e, maxlength) {
    const t = e.target;
    let currentLength = $(t).val().length;
    let counter = $(t).parent().parent().find(COUNTER_CLASS);
    let characterCounter = `(${currentLength}/${maxlength} characters)`;

    $(counter).css("color", CHARACTER_COUNTER_VALID_COLOR);
    $(counter).text(characterCounter);

    if (currentLength >= maxlength) {
      $(counter).css("color", CHARACTER_COUNTER_INVALID_COLOR);
    }
  }

  function countCharsOnPageLoad() {
    let $textareas = $(TEXTAREA_CLASS);

    $textareas.each((k, ta) => {
      _countChars(ta)
    })
  }

  function _countChars(ta) {
    let currentLength = $(ta).val().length;
    if (currentLength > 0) {
      let characterCounter = `(${currentLength}/${MAX_CHARACTER_COUNT} characters)`;
      let counter = $(ta).parent().parent().find(COUNTER_CLASS);
      $(counter).text(characterCounter);
      if (currentLength >= MAX_CHARACTER_COUNT) {
        $(counter).css("color", CHARACTER_COUNTER_INVALID_COLOR);
      }
    }
  }

  function onTextAreaArriveListener() {
    $document.arrive(TEXTAREA_CLASS, (e) => {
      _countChars(e)
      maxCharactersListener();
    });
  }



  function maxCharactersListener() {
    let $textareas = $(TEXTAREA_CLASS);
    $(TEXTAREA_CLASS).off("input")
    $(TEXTAREA_CLASS).on("input", (e) => {
      characterCounter(
        e,
        MAX_CHARACTER_COUNT
      );
    });
  }

  function loadTextareaCounterFns() {
    countCharsOnPageLoad();
    maxCharactersListener();
    onTextAreaArriveListener();
  }

  $document.on("turbolinks:load", loadTextareaCounterFns);
})(window.jQuery);
