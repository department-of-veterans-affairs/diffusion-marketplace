(($) => {
  const $document = $(document);
  let cropper;
  let $editBtn;
  let $saveEditBtn;
  let $cancelEditBtn;
  let $deleteInput;
  let $imgsContainer;
  let imgType;

  const imgValues = {
    main: {
      class: '',
      alt: 'temporary practice thumbnail'
    },
    contact: {
      class: 'headshot-img',
      alt: 'temporary practice contact avatar'
    },
    user: {
      class: 'avatar-profile-photo',
      alt: 'temporary user profile avatar'
    }
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
    let $uploadBtnLabel = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-upload-image-label');
    let $imgDeleteInput = $(target).closest('.dm-cropper-boundary').find($deleteInput);

    if (isUpload) {
      $uploadBtnLabel.text('Upload new image');
      $uploadBtnLabel.addClass('usa-button--unstyled');
      $uploadBtnLabel.removeClass('usa-button--outline');
      $deleteBtnLabel.removeClass('display-none');
      $imgDeleteInput.removeClass('display-none');
    } else {
      $uploadBtnLabel.text('Upload image');
      $uploadBtnLabel.addClass('usa-button--outline');
      $deleteBtnLabel.addClass('display-none');
      $imgDeleteInput.addClass('display-none');
      $uploadBtnLabel.removeClass('usa-button--unstyled');
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
    } else {
      $(target).closest('.dm-cropper-boundary').find("#crop_x").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_y").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_w").val(null);
      $(target).closest('.dm-cropper-boundary').find("#crop_h").val(null);
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
          let imgOrgElement = `<img src="${event.target.result}" class="dm-cropper-thumbnail-original ${imgValues[imgType].class} display-none" alt="${imgValues[imgType].alt}"/>`;
          let imgModElement = `<img src="${event.target.result}" class="dm-cropper-thumbnail-modified ${imgValues[imgType].class}" alt="${imgValues[imgType].alt}"/>`;
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
    let $imageEditText = $('.dm-image-editor-text')

    if (visible) {
      $imgSaveEditBtn.removeClass('display-none');
      $imgCancelEditBtn.removeClass('display-none');
      $imageEditText.removeClass('display-none')
    } else {
      $imgSaveEditBtn.addClass('display-none');
      $imgCancelEditBtn.addClass('display-none');
      $imageEditText.addClass('display-none')
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
    $deleteInput = $('.dm-cropper-delete-image').find('input');
    $cancelEditBtn = $('.dm-cropper-cancel-edit');
    $saveEditBtn = $('.dm-cropper-save-edit');
    $imgsContainer = $('.dm-cropper-images-container');
    imgType = $('.dm-cropper-boundary').find('.dm-cropper-images-container').data('type')

  }

  function attachNewFieldEventListeners() {
    $document.arrive('.dm-cropper-boundary', (newElem) => {
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
