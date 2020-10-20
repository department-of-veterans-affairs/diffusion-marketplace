(($) => {
  const $document = $(document);

  function attachNewFileInputEventListeners() {
    $('.dm-file-form').arrive('.usa-file-input', (newInput) => {
      $(newInput).on('change', (event) => {
        let $input = $(event.target)
        let $inputContainer = $input.closest('.dm-usa-file-input-container')
        let fileSizeMb = $input[0].files[0].size * 0.000001 // convert bytes to MB
        let area = $input.closest('.dm-usa-file-input-container').data('area')
        // check if the file is less than 32 MB
        if (fileSizeMb > 32) {
          hideAttachmentErrorStyles($input, 'div.grid-col-12')
          let $errorDiv = $input.closest('.dm-usa-file-upload-error-text')
          $input.find('.overview_error_msg').clone().after($errorDiv)
          replaceFileInput(area, $input)
          $inputContainer.find('.dm-usa-file-upload-error-text').removeClass('display-none')
        } else {
          $inputContainer.find('.dm-usa-file-upload-error-text').addClass('display-none')
        }
      })
    })
  }

  $document.on('turbolinks:load', attachNewFileInputEventListeners);
})(window.jQuery);
