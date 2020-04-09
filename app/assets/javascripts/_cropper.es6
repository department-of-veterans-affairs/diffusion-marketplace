(($) => {
  const $document = $(document);
  let cropper;
  let $editBtn;
  let $saveEditBtn;
  let $cancelEditBtn;
  let $deleteInput;
  let $imgsContainer;

  const imgValues = {
    main: {
      class: 'height-mobile radius-md',
      alt: 'temporary practice thumbnail'
    },
    contact: {
      class: 'va-employee-img',
      alt: 'temporary practice contact avatar'
    }
  }

  function _toggleDefaultPracticeThumbnail({ visible, target }) {
    let $defaultThumbnail = $(target).closest('.cropper-boundary').find('.cropper-image-placeholder');
    let $imgImgsContainer = $(target).closest('.cropper-boundary').find($imgsContainer)

    if (visible) {
      $imgImgsContainer.empty();
      $defaultThumbnail.removeClass('hidden');
    } else {
      $defaultThumbnail.addClass('hidden');
    }
  }

  function _toggleBtnsOnPlaceholderChange({ isUpload, target }) {
    let $deleteBtnLabel = $(target).closest('.cropper-boundary').find('.cropper-delete-image-label');
    let $uploadBtnLabel = $(target).closest('.cropper-boundary').find('.cropper-upload-image-label');
    let $imgDeleteInput = $(target).closest('.cropper-boundary').find($deleteInput);

    if (isUpload) {
      $uploadBtnLabel.text('Upload new photo');
      $uploadBtnLabel.removeClass('usa-button');
      $deleteBtnLabel.removeClass('hidden');
      $imgDeleteInput.removeClass('hidden');
    } else {
      $uploadBtnLabel.text('Upload photo');
      $uploadBtnLabel.addClass('usa-button');
      $deleteBtnLabel.addClass('hidden');
      $imgDeleteInput.addClass('hidden');
    }
  }

  function _toggleThumbnailRemoval({ deleteImg, target }) {
    let $imgDeleteInput = $(target).closest('.cropper-boundary').find($deleteInput)
    if (deleteImg) {
      $imgDeleteInput.val('true');
    } else {
      $imgDeleteInput.val('false');
    }
  }

  function _toggleImageView({ isCrop, target }) {
    let $originalImage = $(target).closest('.cropper-boundary').find('.cropper-thumbnail-original');
    let $modifiedImage = $(target).closest('.cropper-boundary').find('.cropper-thumbnail-modified');

    if (isCrop && $originalImage) {
      $modifiedImage.addClass('hidden');
      $originalImage.removeClass('hidden');
    } else {
      $modifiedImage.removeClass('hidden');
      $originalImage.addClass('hidden');
    }
  }

  function _toggleCropper({ visible, target }) {
    let $image = $(target).closest('.cropper-boundary').find('.cropper-thumbnail-original');

    if (visible) {
      let cropOptions = {
          aspectRatio: 1,
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
    let $imgEditBtn = $(target).closest('.cropper-boundary').find($editBtn)
    if (visible) {
      $imgEditBtn.removeClass('hidden');
    } else {
      $imgEditBtn.addClass('hidden');
    }
  }

  function _setCropBoxValues({ isCrop, target }) {
    if (isCrop) {
      let cropValues = cropper.getData(true);

      $(target).closest('.cropper-boundary').find("#crop_x").val(cropValues.x);
      $(target).closest('.cropper-boundary').find("#crop_y").val(cropValues.y);
      $(target).closest('.cropper-boundary').find("#crop_w").val(cropValues.width);
      $(target).closest('.cropper-boundary').find("#crop_h").val(cropValues.height);
    } else {
      $(target).closest('.cropper-boundary').find("#crop_x").val(null);
      $(target).closest('.cropper-boundary').find("#crop_y").val(null);
      $(target).closest('.cropper-boundary').find("#crop_w").val(null);
      $(target).closest('.cropper-boundary').find("#crop_h").val(null);
    }
  }

  function _loadPracticeThumbnail({ uploadedImg, target }) {
    let reader = new FileReader();
    let $imgImgsContainer = $(target).closest('.cropper-boundary').find('.cropper-images-container')

    reader.onload = (function() {
      return function(event) {
        let imgType = $(target).closest('.cropper-boundary').find('.cropper-images-container').data('type')
        let imgOrgElement = `<img src="${event.target.result}" class="cropper-thumbnail-original ${imgValues[imgType].class} hidden" alt="${imgValues[imgType].alt}"/>`;
        let imgModElement = `<img src="${event.target.result}" class="cropper-thumbnail-modified ${imgValues[imgType].class}" alt="${imgValues[imgType].alt}"/>`;
        $imgImgsContainer.empty();
        $imgImgsContainer.append(imgOrgElement);
        $imgImgsContainer.append(imgModElement);
      }
    })()

    // Read in the image file as a data URL
    reader.readAsDataURL(uploadedImg);
  }

  function _toggleCropperBtnView({ visible, target}) {
    let $imgSaveEditBtn = $(target).closest('.cropper-boundary').find($saveEditBtn)
    let $imgCancelEditBtn = $(target).closest('.cropper-boundary').find($cancelEditBtn)

    if (visible) {
      $imgSaveEditBtn.removeClass('hidden');
      $imgCancelEditBtn.removeClass('hidden');
    } else {
      $imgSaveEditBtn.addClass('hidden');
      $imgCancelEditBtn.addClass('hidden');
    }
  }

  function _toggleImageHelpText({ isEdit, target }) {
    let $imageUploadText = $(target).closest('.cropper-boundary').find('.cropper-upload-text')
    let $imageEditText = $(target).closest('.cropper-boundary').find('.cropper-editor-text')

    if (isEdit) {
      $imageUploadText.addClass('hidden')
      $imageEditText.removeClass('hidden')
    } else {
      $imageUploadText.removeClass('hidden')
      $imageEditText.addClass('hidden')
    }
  }

  function _attachUploadEventListener() {
    let $thubmanilInput = $('.cropper-upload-image');

    $thubmanilInput.on('change', (event) => {
      _toggleImageHelpText({ isEdit: false, target: event.target })
      _loadPracticeThumbnail({ uploadedImg: event.target.files[0], target: event.target });
      _toggleThumbnailRemoval({ deleteImg: false, target: event.target });
      _toggleEditBtn({ visible: true, target: event.target})
      _toggleBtnsOnPlaceholderChange({ isUpload: true, target: event.target });
      _toggleDefaultPracticeThumbnail({ visible: false, target: event.target })
      _setCropBoxValues({ isCrop: false, target: event.target });
      _toggleCropperBtnView({ visible: false, target: event.target });
      if (cropper) {
          _toggleCropper({ visible: false, target: event.target });
      }
    })
  }

  function _attachDeleteEventListener() {
    $deleteInput.click((event) => {
      _toggleImageHelpText({ isEdit: false, target: event.target })
      _toggleThumbnailRemoval({ deleteImg: true, target: event.target });
      _toggleDefaultPracticeThumbnail({ visible: true, target: event.target });
      _toggleBtnsOnPlaceholderChange({ isUpload: false, target: event.target });
      _toggleEditBtn({ visible: false, target: event.target });
      _toggleCropperBtnView({ visible: false, target: event.target });
    });
  }

  function _attachEditEventListener() {
    $editBtn.click((event) => {
      _toggleImageHelpText({ isEdit: true, target: event.target });
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
      _toggleImageHelpText({ isEdit: false, target: event.target })
      _toggleCropper({ visible: false, target: event.target });
      _toggleImageView({ isCrop: false, target: event.target })
      _toggleCropperBtnView({ visible: false, target: event.target });
      _toggleEditBtn({ visible: true, target: event.target });
      _setCropBoxValues({ isCrop: false, target: event.target });
    });
  }

  function attachImgActionsEventListeners() {
    _attachEditEventListener();
    _attachUploadEventListener();
    _attachEditEventListener();
    _attachDeleteEventListener();
    _attachSaveEditEventListener();
    _attachCancelEditEventListener();
  }

  function setImageVars() {
    $editBtn = $('.cropper-edit-mode');
    $deleteInput = $('.cropper-delete-image');
    $cancelEditBtn = $('.cropper-cancel-edit');
    $saveEditBtn = $('.cropper-save-edit');
    $imgsContainer = $('.cropper-images-container')
  }

  function attachNewFieldEventListeners() {
    $document.arrive('.cropper-boundary', (newElem) => {
      setImageVars();
      attachImgActionsEventListeners();
    })
  }

  function loadCropperFunctions() {
    setImageVars();
    attachImgActionsEventListeners();
    attachNewFieldEventListeners();
}

  $document.on('turbolinks:load', loadCropperFunctions);
})(window.jQuery);
