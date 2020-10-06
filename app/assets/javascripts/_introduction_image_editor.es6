(($) => {
  const $document = $(document);
  let cropper;
  let $editBtn;
  let $saveEditBtn;
  let $cancelEditBtn;
  let $deleteInput;
  let $imgsContainer;
  let fileUploadHtml = `<input class="dm-cropper-upload-image usa-file-input" accept="image/*" type="file" name="practice[main_display_image]" id="practice_main_display_image">`;

  function _clearUpload({ target }) {
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer)
    $imgImgsContainer.empty();
    let fileUploadExists = $('.usa-file-input').length > 0;

    if (fileUploadExists) {
      $('.usa-file-input').replaceWith(fileUploadHtml);
    } else {
      $('.dm-image-error-text').after(fileUploadHtml);
    }
    // add event listener again
    _attachUploadEventListener()
  }

  function _toggleDefaultPracticeThumbnail({ visible, target }) {
    let $defaultThumbnail = $(target).closest('.dm-cropper-boundary').find('.cropper-image-placeholder');
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer)

    if (visible) {
      $imgImgsContainer.empty();
      $defaultThumbnail.removeClass('display-none');
    } else {
      $defaultThumbnail.addClass('display-none');
    }
  }

  function _toggleBtnsOnPlaceholderChange({ isUpload, target }) {
    let $deleteBtnLabel = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-delete-image-label');
    let $imgDeleteInput = $(target).closest('.dm-cropper-boundary').find($deleteInput);

    if (isUpload) {
      $deleteBtnLabel.removeClass('display-none');
      $imgDeleteInput.removeClass('display-none');
    } else {
      $deleteBtnLabel.addClass('display-none');
      $imgDeleteInput.addClass('display-none');
    }
  }

  function _toggleThumbnailRemoval({ deleteImg, target }) {
    let $imgDeleteInput = $(target).closest('.dm-cropper-boundary').find($deleteInput)

    if (deleteImg) {
      $imgDeleteInput.val('true');
    } else {
      $imgDeleteInput.val('false');
    }
  }

  function _toggleImageView({ isCrop, target }) {
    let $originalImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');
    let $modifiedImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-modified');

    if (isCrop && $originalImage) {
      $modifiedImage.addClass('display-none');
      $originalImage.removeClass('display-none');
    } else {
      $modifiedImage.removeClass('display-none');
      $originalImage.addClass('display-none');
    }
  }

  function _toggleCropper({ visible, target }) {
    let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

    if (visible) {
      let cropOptions = {
          aspectRatio: 16/9,
          checkCrossOrigin: false,
          checkOrientation: true,
          viewMode: 2,
          minContainerWidth: 100
      }

      // create Cropper instance
      $image.cropper(cropOptions);

      // set Cropper instance
      cropper = $image.data('cropper');
    } else {
      cropper = $image.data('cropper');
      cropper.destroy();
    }
  }

  function _toggleEditBtn({ visible, target }) {
    let $imgEditBtn = $(target).closest('.dm-cropper-boundary').find($editBtn)

    if (visible) {
      $imgEditBtn.removeClass('display-none');
    } else {
      $imgEditBtn.addClass('display-none');
    }
  }

  function _setCropBoxValues({ isCrop, target }) {
    if (isCrop) {
      let cropValues = cropper.getData(true);

      $(target).closest('.dm-cropper-boundary').find("#crop_x").val(cropValues.x);
      $(target).closest('.dm-cropper-boundary').find("#crop_y").val(cropValues.y);
      $(target).closest('.dm-cropper-boundary').find("#crop_w").val(cropValues.width);
      $(target).closest('.dm-cropper-boundary').find("#crop_h").val(cropValues.height);
      _createModifiedImage({ target })
      _toggleCropper({ visible: false, target });
      _toggleCropperBtnView({ visible: false, target });
      _toggleEditBtn({ visible: true, target });
      _toggleDeleteBtn({ visible: true, target });
      _toggleImageView({ isCrop: false, target });
    } else {
      $(target).closest('.dm-cropper-boundary').find("#crop_x").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_y").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_w").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_h").val(null);
    }
  }

  function _createModifiedImage({ target }) {
    let $modifiedImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-modified');
    let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

    if ($modifiedImage.length > 0) {
      $modifiedImage.remove()
    }

    if ($image) {
      $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original').addClass('display-none')
      let croppedCanvas = $image.data('cropper').getCroppedCanvas({ width: 310 })

      $(target).closest('.dm-cropper-boundary').find($imgsContainer).append(croppedCanvas)
      $(target).closest('.dm-cropper-boundary').find('canvas').addClass('dm-cropper-thumbnail-modified')
    }
  }

  function _loadPracticeThumbnail({ uploadedImg, target }) {
    let imgSizeMb = uploadedImg.size * 0.000001 // convert bytes to MB
    let errorContent = {
      dimension: 'Sorry, you cannot upload an image smaller than 768px wide by 432px high.',
      size: 'Sorry, you cannot upload an image larger than 32MB.'
    }
    let $errorText = $('.dm-image-error-text')
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-images-container')

    // check if the image is less than 32 MB
    if (imgSizeMb <= 32) {
      let reader = new FileReader();

      reader.onload = (function() {
        return function(event) {
          let imgOrgElement = `<img src="${event.target.result}" class="dm-cropper-thumbnail-original display-none" alt="temporary practice image"/>`;
          let imgModElement = `<img src="${event.target.result}" class="dm-cropper-thumbnail-modified" alt="temporary practice image"/>`;
          $imgImgsContainer.empty();
          $imgImgsContainer.append(imgOrgElement);
          $imgImgsContainer.append(imgModElement);

          // wait for the image to be loaded
          $('.dm-cropper-thumbnail-modified').on('load', function(event) {
            let imgWidth = $('.dm-cropper-thumbnail-modified')[0].naturalWidth;
            let imgHeight = $('.dm-cropper-thumbnail-modified')[0].naturalHeight;
            // check if image dimensions are acceptable
            if (imgWidth >= 768 && imgHeight >= 432) {
              $errorText.addClass('display-none')
              _successfulImageLoad({ target })
            } else {
              $('.dm-cropper-thumbnail-modified').addClass('display-none')
              $errorText.removeClass('display-none')
              $errorText.find('p').text(errorContent.dimension)
              _failedImageLoad({ target })
            }
          });
        }
      })()

      // Read in the image file as a data URL
      reader.readAsDataURL(uploadedImg);
    } else {
      $imgImgsContainer.empty();
      $errorText.removeClass('display-none')
      $errorText.find('p').text(errorContent.size)
      _failedImageLoad({ target })
    }
  }

  function _failedImageLoad({ target }) {
    _toggleThumbnailRemoval({ deleteImg: false, target });
    _toggleEditBtn({ visible: false, target })
    _toggleBtnsOnPlaceholderChange({ isUpload: false, target });
    _toggleDefaultPracticeThumbnail({ visible: false, target })
    _setCropBoxValues({ isCrop: false, target });
    _toggleCropperBtnView({ visible: false, target });
    _clearUpload({ target })
  }

  function _successfulImageLoad({ target }) {
    _toggleThumbnailRemoval({ deleteImg: false, target });
    _toggleEditBtn({ visible: true, target })
    _toggleBtnsOnPlaceholderChange({ isUpload: true, target });
    _toggleDefaultPracticeThumbnail({ visible: false, target })
    _setCropBoxValues({ isCrop: false, target });
    _toggleCropperBtnView({ visible: false, target });
  }

  function _toggleCropperBtnView({ visible, target}) {
    let $imgSaveEditBtn = $(target).closest('.dm-cropper-boundary').find($saveEditBtn)
    let $imgCancelEditBtn = $(target).closest('.dm-cropper-boundary').find($cancelEditBtn)

    if (visible) {
      $imgSaveEditBtn.removeClass('display-none');
      $imgCancelEditBtn.removeClass('display-none');
    } else {
      $imgSaveEditBtn.addClass('display-none');
      $imgCancelEditBtn.addClass('display-none');
    }
  }

  function _attachUploadEventListener() {
    let $thubmanilInput = $('.dm-cropper-upload-image');

    $thubmanilInput.on('change', (event) => {
      _loadPracticeThumbnail({ uploadedImg: event.target.files[0], target: event.target });
    })
  }

  function _attachDeleteEventListener() {
    $deleteInput.click((event) => {
      _clearUpload({ target: event.target })
      _toggleThumbnailRemoval({ deleteImg: true, target: event.target });
      _toggleDefaultPracticeThumbnail({ visible: true, target: event.target });
      _toggleBtnsOnPlaceholderChange({ isUpload: false, target: event.target });
      _toggleEditBtn({ visible: false, target: event.target });
      _toggleCropperBtnView({ visible: false, target: event.target });
    });
  }

  function _attachEditEventListener() {
    $editBtn.click((event) => {
      _toggleCropper({ visible: true, target: event.target });
      _toggleImageView({ isCrop: true, target: event.target });
      _toggleCropperBtnView({ visible: true, target: event.target });
      _toggleEditBtn({ visible: false, target: event.target });
    });
  }

  function _attachSaveEditEventListener() {
    $saveEditBtn.click((event) => {
      _setCropBoxValues({ isCrop: true, target: event.target });
    });
  }

  function _attachCancelEditEventListener() {
    $cancelEditBtn.click((event) => {
      _toggleCropper({ visible: false, target: event.target });
      _toggleImageView({ isCrop: false, target: event.target })
      _toggleCropperBtnView({ visible: false, target: event.target });
      _toggleEditBtn({ visible: true, target: event.target });
    });
  }

  function attachImgActionsEventListeners() {
    _attachEditEventListener();
    _attachDeleteEventListener();
    _attachSaveEditEventListener();
    _attachCancelEditEventListener();
    _attachUploadEventListener();
  }

  function setImageVars() {
    $editBtn = $('.dm-cropper-edit-mode');
    $deleteInput = $('.dm-cropper-delete-image').find('input');
    $cancelEditBtn = $('.dm-cropper-cancel-edit');
    $saveEditBtn = $('.dm-cropper-save-edit');
    $imgsContainer = $('.dm-cropper-images-container');
  }

  function displayUpload() {
    $('.usa-file-input').ready(() => {
      let imageExists = $('.dm-cropper-thumbnail-modified').length > 0;
      if (imageExists) {
        $('.dm-cropper-boundary').find('.usa-file-input').addClass('display-none');
      }
    });
  }

  function loadCropperFunctions() {
    setImageVars();
    attachImgActionsEventListeners();
    displayUpload();
}

  $document.on('turbolinks:load', loadCropperFunctions);
})(window.jQuery);
