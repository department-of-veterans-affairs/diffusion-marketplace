(($) => {
    const $document = $(document);

    function submitPracticeEditorSaveForm() {
        $('#practice-editor-save-button').on('click', () => {
            let $form = $('#form');
            if ($form[0].checkValidity()) {
                    $form.submit();
            } else {
                $form[0].reportValidity();
            }
        });
    }

    function saveEditorProgressOnContinue() {
        let currentEndpoint = window.location.href.split('/').pop();
        if (currentEndpoint != 'adoptions') {
            $('.continue-and-save').on('click', (event) => {
                event.preventDefault();
                let $form = $('#form');
                let nextEndpoint = $(event.target).data('next');

                $form.append(`<input type='hidden' name='next' value=${nextEndpoint}>`);

                if ($form[0].checkValidity()) {
                    $form.submit();
                } else {
                    $form[0].reportValidity();
                }
            });
        }
    }

    function initSaveProgressFunctions() {
        submitPracticeEditorSaveForm();
        saveEditorProgressOnContinue();
    }

    $document.on('turbolinks:load', initSaveProgressFunctions);
})(window.jQuery);