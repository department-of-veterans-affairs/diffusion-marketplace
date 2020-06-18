function validateForm({form, railsFireEvent}) {
    if (form[0].checkValidity() && railsFireEvent) {
        Rails.fire(form[0], 'submit');
    } else if (form[0].checkValidity() && !railsFireEvent) {
        form.submit();
    } else {
        form[0].reportValidity();
    }
}

function submitPracticeEditorSaveForm() {
    $(document).on('click', '#practice-editor-save-button', () => {
        let form = $('#form');
        validateForm({ form, railsFireEvent: false });
    });
}

function saveEditorProgressOnContinue() {
    $(document).on('click', '.continue-and-save', (event) => {
        event.preventDefault();
        let form = $('#form');

        form.append(`<input type='hidden' name='next' value=true>`);

        validateForm({ form, railsFireEvent: false });
    });
}

function saveEditorProgressOnPublish() {
    $(document).on('click', '#publish-practice-button', (event) => {
        let $form = $('#form');
        let formAction = $('#publish-practice-button').data('form-action')

        // set the action to `practice_publication_validation_path`
        $form.attr('action', formAction)
        $form.attr('data-remote', true)
        event.preventDefault();

        validateForm({ form: $form, railsFireEvent: true })
    });
}

function initSaveProgressFunctions() {
    submitPracticeEditorSaveForm();
    saveEditorProgressOnContinue();
    saveEditorProgressOnPublish();
}

$(initSaveProgressFunctions());
