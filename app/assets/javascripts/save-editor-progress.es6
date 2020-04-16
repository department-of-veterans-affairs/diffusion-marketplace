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

    function saveEditorProgressOnContinue() {
        $('.continue-and-save').on('click', (event) => {
            event.preventDefault();
            let nextEndpoint = $(this).attr('data-next');
            console.log(nextEndpoint);
            $('#form').append(`<input type='hidden' name='next' value=${nextEndpoint}>`);

            if ($('#form')[0].checkValidity()) {
                $('#form').submit();
            } else {
                $('#form')[0].reportValidity();
            }
        });
    }

    function initSaveProgressFunctions() {
        submitPracticeEditorSaveForm();
        saveEditorProgressOnContinue();
    }

    $document.on('turbolinks:load', initSaveProgressFunctions);
})(window.jQuery);