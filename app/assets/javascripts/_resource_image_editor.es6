(($) => {
  const $document = $(document);
  let $editBtn;
  let $saveEditBtn;
  let $cancelEditBtn;
  let $deleteBtn;
  let $imgsContainer;
  let $thumbnailInput;

  function _toggleDeleteBtn({ visible, target }) {
    let $imgDeleteBtn = $(target).closest('.dm-cropper-boundary').find($deleteBtn);
    let hideDeleteBtn = $(target).closest('.dm-cropper-boundary').find($imgsContainer).hasClass('dm-resource-image');

    if (visible && !hideDeleteBtn) {
      $imgDeleteBtn.removeClass('display-none');
    } else {
      $imgDeleteBtn.addClass('display-none');
    }
  }

  function _toggleImageView({ isCrop, target }) {
    let $originalImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');
    let $modifiedCanvas = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-modified');

    if (isCrop && $originalImage) {
      $originalImage.removeClass('display-none');
      $modifiedCanvas.addClass('display-none')
    } else {
      if ($modifiedCanvas.length > 0) {
        $originalImage.addClass('display-none');
        $modifiedCanvas.removeClass('display-none')
      } else {
        $originalImage.removeClass('display-none');
      }
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
    } else {
      if ($image.data('cropper')) {
        $image.data('cropper').destroy();
      }
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
    let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

    if (isCrop && $image.data('cropper')) {
      let cropValues = $image.data('cropper').getData(true);
      $(target).closest('.dm-cropper-boundary').find(".crop_x").val(cropValues.x);
      $(target).closest('.dm-cropper-boundary').find(".crop_y").val(cropValues.y);
      $(target).closest('.dm-cropper-boundary').find(".crop_w").val(cropValues.width);
      $(target).closest('.dm-cropper-boundary').find(".crop_h").val(cropValues.height);

      _createModifiedImage({ target })
      _toggleCropper({ visible: false, target });
      _toggleCropperBtnView({ visible: false, target });
      _toggleEditBtn({ visible: true, target });
      _toggleDeleteBtn({ visible: true, target });
      _toggleImageView({ isCrop: false, target });
    } else {
      $(target).closest('.dm-cropper-boundary').find(".crop_x").val(null);
      $(target).closest('.dm-cropper-boundary').find(".crop_y").val(null);
      $(target).closest('.dm-cropper-boundary').find(".crop_w").val(null);
      $(target).closest('.dm-cropper-boundary').find(".crop_h").val(null);
    }
  }

  function _clearUpload({ target }) {
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer)
    let area = $(target).closest('.dm-cropper-boundary').data('area')
    let type = $(target).closest('.dm-cropper-boundary').data('type')

    $imgImgsContainer.empty()
    $(target)
      .closest('.dm-cropper-boundary').find(".usa-file-input")
      .replaceWith(`
        <input id="practice_${area}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="dm-cropper-upload-image usa-hint usa-file-input" type="file" name="practice[practice_${area}_resources_attributes][RANDOM_NUMBER_OR_SOMETHING_${type}][attachment]" accept=".jpg,.jpeg,.png" aria-describedby="input-single-hint" />
      `)
    // add event listener again
    $('.dm-cropper-upload-image').on('change', (event) => {
      _loadPracticeThumbnail({ uploadedImg: event.target.files[0], target: event.target });
    })
  }

  function _loadPracticeThumbnail({ uploadedImg, target }) {
    let imgSizeMb = uploadedImg.size * 0.000001 // convert bytes to MB
    let $errorText = $('.dm-image-error-text')
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer)

    // check if the image is less than 32 MB
    if (imgSizeMb <= 32) {
      let reader = new FileReader();

      reader.onload = (function() {
        return function(event) {
          let imgOrgElement = `<img src="${event.target.result}" class="dm-cropper-thumbnail-original" alt=""/>`;
          $imgImgsContainer.empty();
          $imgImgsContainer.append(imgOrgElement);
          $errorText.addClass('display-none')
          _successfulImageLoad({ target })
        }
      })()

      // Read in the image file as a data URL
      reader.readAsDataURL(uploadedImg);
    } else {
      $imgImgsContainer.empty();
      $errorText.removeClass('display-none')
      $errorText.find('p').text('Sorry, you cannot upload an image larger than 32MB.')
      _failedImageLoad({ target })
    }
  }

  function _failedImageLoad({ target }) {
    _toggleEditBtn({ visible: false, target })
    _toggleDeleteBtn({ visible: false, target });
    _setCropBoxValues({ isCrop: false, target });
    _toggleCropperBtnView({ visible: false, target });
    _clearUpload({ target });
  }

  function _successfulImageLoad({ target }) {
    _toggleEditBtn({ visible: true, target })
    _toggleDeleteBtn({ visible: true, target });
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

  function _createModifiedImage({ target }) {
    let $modifiedImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-modified');
    let setAsCanvas = $(target).closest('.dm-cropper-boundary').find($imgsContainer).hasClass('dm-resource-image');
    let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

    if ($modifiedImage.length > 0) {
      $modifiedImage.remove()
    }

    if ($image) {
      $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original').addClass('display-none')
      let croppedCanvas = $image.data('cropper').getCroppedCanvas({ width: 310 })
      if (setAsCanvas) {
        croppedCanvas.classList.add('dm-cropper-thumbnail-modified')
        $(target).closest('.dm-cropper-boundary').find($imgsContainer).append(croppedCanvas)
      } else {
        let url = croppedCanvas.toDataURL();
        let image = new Image();
        image.src = url;
        image.classList.add('dm-cropper-thumbnail-modified')
        $(target).closest('.dm-cropper-boundary').find($imgsContainer).append(image)
      }
    }
  }

  function _attachUploadEventListener() {
    $thumbnailInput.on('change', (event) => {
      _loadPracticeThumbnail({ uploadedImg: event.target.files[0], target: event.target });
    })
  }

  function _attachDeleteEventListener() {
    $deleteBtn.click((event) => {
      _clearUpload({ target: event.target })
      _toggleDeleteBtn({ visible: false, target: event.target });
      _toggleEditBtn({ visible: false, target: event.target });
      _toggleCropperBtnView({ visible: false, target: event.target });
    });
  }

  function _attachEditEventListener() {
    $editBtn.click((event)  => {
      _toggleCropper({ visible: true, target: event.target });
      _toggleDeleteBtn({ visible: false, target: event.target });
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
      _toggleImageView({ isCrop: false, target: event.target })
      _toggleDeleteBtn({ visible: true, target: event.target });
      _toggleCropper({ visible: false, target: event.target });
      _toggleCropperBtnView({ visible: false, target: event.target });
      _toggleEditBtn({ visible: true, target: event.target });
      _setCropBoxValues({ isCrop: false, target: event.target });
    });
  }

  function attachImgActionsEventListeners() {
    _attachUploadEventListener();
    _attachEditEventListener();
    _attachDeleteEventListener();
    _attachSaveEditEventListener();
    _attachCancelEditEventListener();
  }

  function setImageVars() {
    $editBtn = $('.dm-cropper-edit-mode');
    $deleteBtn = $('.dm-cropper-delete-image');
    $cancelEditBtn = $('.dm-cropper-cancel-edit');
    $saveEditBtn = $('.dm-cropper-save-edit');
    $imgsContainer = $('.dm-cropper-images-container');
    $thumbnailInput = $('.dm-cropper-upload-image');
  }

  function attachNewFieldEventListeners() {
    $document.arrive('.dm-cropper-boundary', (newElem) => {
      setImageVars();
      _attachUploadEventListener();
      _attachSaveEditEventListener();
      _attachCancelEditEventListener();
    })
  }

  function loadCropperFunctions() {
    setImageVars();
    attachImgActionsEventListeners();
    attachNewFieldEventListeners();
}

  $document.on('turbolinks:load', loadCropperFunctions);
})(window.jQuery);
