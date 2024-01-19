document.addEventListener('DOMContentLoaded', function() {
    let textArea = document.getElementById('emailMessage');
    let editorInitialized = false;

    function initTinyMCE() {
        if (editorInitialized) return;
        tinymce.init({
        selector: 'textarea#emailMessage',
        plugins: 'link code',
        toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | code',
        paste_data_images: false,
        images_upload_url: '',
        automatic_uploads: false,
        file_picker_types: '',
        });
        editorInitialized = true;
    }

    textArea.addEventListener('focus', initTinyMCE);

    document.getElementById('previewEmailButton').addEventListener('click', function(event) {
        event.preventDefault();

        if (editorInitialized) {
            tinymce.remove('#emailMessage');
            editorInitialized = false;
        }

        document.getElementById('previewSubject').innerHTML = "Subject: " + document.getElementById('emailSubject').value
        document.getElementById('previewMessage').innerHTML = textArea.value;

        document.getElementById('previewModal').style.display = 'block';
    });

    let previewModal = document.getElementById('previewModal');
    previewModal.querySelector('[data-close-modal]').addEventListener('click', function() {
        previewModal.style.display = 'none';
    });

    window.confirmSendEmail = function() {
        let sendEmail = confirm("This email will be sent to all Innovation editors, are you sure?");
        if (sendEmail) {
        document.getElementById('emailForm').submit();
        }
        previewModal.style.display = 'none';
    };
});
