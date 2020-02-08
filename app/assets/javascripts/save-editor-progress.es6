(($) => {
    const $document = $(document);

    function submitPracticeEditorSaveForm() {
        $('#practice-editor-save-button').on('click', () => {
            if ($('#form')[0].checkValidity()) {
                    $('#form').submit();
            } else {
                $('#form')[0].reportValidity();
            }
        });
    }

    function initSaveProgressFunctions() {
        submitPracticeEditorSaveForm();
    }

    $document.on('turbolinks:load', initSaveProgressFunctions);
})(window.jQuery);