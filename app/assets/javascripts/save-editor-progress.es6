(($) => {
    const $document = $(document);

    function submitPracticeEditorSaveForm() {
        $('#practice-editor-save-button').on('click', () => {
            $('.usa-form').submit();
        });
    }

    $document.on('turbolinks:load', submitPracticeEditorSaveForm);
})(window.jQuery);