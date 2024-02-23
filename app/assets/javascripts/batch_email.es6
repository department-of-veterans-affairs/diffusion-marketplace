document.addEventListener('DOMContentLoaded', function() {
  let textArea = document.getElementById('emailMessage');
  let editorInitialized = false;

  function initTinyMCE() {
    if (editorInitialized) return;
    tinymce.init({
      selector: 'textarea#emailMessage',
      menubar: false,
      plugins: ["link", "lists"],
      toolbar:
        'undo redo | bold italic | link bullist numlist superscript subscript | removeformat',
      link_title: false,
      link_assume_external_targets: false,
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
    let emailSubject = document.getElementById('emailSubject').value.trim();
    let emailMessageContent = tinymce.get('emailMessage') ? tinymce.get('emailMessage').getContent({format: "text"}).trim() : textArea.value.trim();

    if (!emailSubject || !emailMessageContent) {
      alert('Both subject and message must be provided.');
      return;
    }

    if (editorInitialized) {
      tinymce.remove('#emailMessage');
      editorInitialized = false;
    }

    document.getElementById('previewSubject').textContent = "Subject: " + emailSubject;
    document.getElementById('previewMessage').textContent = emailMessageContent;

    document.getElementById('previewModal').style.display = 'block';
  });

  let previewModal = document.getElementById('previewModal');
  previewModal.querySelector('[data-close-modal]').addEventListener('click', function() {
    previewModal.style.display = 'none';
  });

  window.confirmSendEmail = function() {
    const notUpdatedSince = document.getElementById('notUpdatedSince').value;
    const notEmailedSince = document.getElementById('notEmailedSince').value;

    let confirmationMessage = "This email will be sent to all editors and owners of published Innovations";

    if (notUpdatedSince && notEmailedSince) {
        confirmationMessage += `, restricted to Innovations not updated since ${notUpdatedSince} and not emailed since ${notEmailedSince}`;
    } else if (notUpdatedSince) {
        confirmationMessage += `, restricted to Innovations not updated since ${notUpdatedSince}`;
    } else if (notEmailedSince) {
        confirmationMessage += `, restricted to Innovations not emailed since ${notEmailedSince}`;
    }

    confirmationMessage += ", are you sure?";

    if (confirm(confirmationMessage)) {
        document.getElementById('emailForm').submit();
    }
    previewModal.style.display = 'none';
  };
});
