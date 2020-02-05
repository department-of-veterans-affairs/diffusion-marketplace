(($) => {
    const $document = $(document);

    function submitPracticeEditorSaveForm() {
        $('#practice-editor-save-button').on('click', () => {
            if ($('#form')[0].checkValidity()) {  
                if ($(".department-input:checked").length === 0 && $(".no-department-input").prop('checked') == false && window.location.pathname.split('/').slice(-1)[0] == 'complexity') {
                    alert("Please choose at least one of the department options listed");
                    return false;
                } else if ($(".partner-input:checked").length === 0 && $(".no-partner-input").prop('checked') == false && window.location.pathname.split('/').slice(-1)[0] == 'overview') {
                    alert("Please choose at least one of the partners listed");
                    return false;
                } else {
                    $('#form').submit();
                }
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