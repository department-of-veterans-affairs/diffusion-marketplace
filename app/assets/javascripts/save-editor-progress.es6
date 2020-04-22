function validateForm(form) {
    if (form[0].checkValidity()) {
        form.submit();
    } else {
        form[0].reportValidity();
    }
}

function submitPracticeEditorSaveForm() {
    $(document).on('click', '#practice-editor-save-button', () => {
        let form = $('#form');
        validateForm(form);
    });
}

function saveEditorProgressOnContinue() {
    $(document).on('click', '.continue-and-save', (event) => {
        event.preventDefault();
        let form = $('#form');

        form.append(`<input type='hidden' name='next' value=true>`);

        validateForm(form);
    });
}

function initSaveProgressFunctions() {
    submitPracticeEditorSaveForm();
    saveEditorProgressOnContinue();
}

$(initSaveProgressFunctions());