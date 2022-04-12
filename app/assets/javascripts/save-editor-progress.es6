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

function initSaveProgressFunctions() {
    submitPracticeEditorSaveForm();
    saveEditorProgressOnContinue();
}

$(initSaveProgressFunctions());
