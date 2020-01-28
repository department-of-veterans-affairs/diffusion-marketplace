(($) => {
    const $document = $(document);

    function submitPracticeEditorSaveForm() {
        $('#practice-editor-save-button').on('click', () => {
            if ($(".partner-input:checked").length === 0 && window.location.pathname.split('/').slice(-1)[0] == 'overview') {
                console.log(window.location)
                alert("Please choose at least one of the partners listed");
                return false;
            }

            if ($(".department-input:checked").length === 0 && window.location.pathname.split('/').slice(-1)[0] == 'complexity') {
                alert("Please choose at least one of the department options listed");
                return false;
            }

            if ($('#form')[0].checkValidity()) {  
                $('#form').submit();
            } else {
                $('#form')[0].reportValidity();
            }
        });
    }

    $document.on('turbolinks:load', submitPracticeEditorSaveForm);
})(window.jQuery);