(($) => {
  const $document = $(document);
  let $deleteBtn;
  let $imgsContainer;
  let $placeholderImg;
  // let $editBtn;
  // let $saveEditBtn;
  // let $cancelEditBtn;

  function _toggleDeleteBtn({ visible, target }) {
    let imgDeleteBtn = $(target).closest('.dm-cropper-boundary').find($deleteBtn);
    let hideDeleteBtn = $(target).closest('.dm-cropper-boundary').find($imgsContainer).hasClass('dm-resource-image');

    if (visible && !hideDeleteBtn) {
      imgDeleteBtn.removeClass('hidden');
    } else {
      imgDeleteBtn.addClass('hidden');
    }
  }

  function _clearUpload({ target }) {
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer)
    let area = $(target).closest('.dm-cropper-boundary').data('area')

    $imgImgsContainer.empty()
    $(target)
      .closest('.dm-cropper-boundary').find(".usa-file-input")
      .replaceWith(`
        <input  class="dm-cropper-upload-image usa-hint usa-file-input ${area}-image-attachment" type="file" accept=".jpg,.jpeg,.png" />
      `)
    $('.dm-cropper-upload-image').on('change', (event) => {
      _attachAvatarImg({ uploadedImg: event.target.files[0], target: event.target });
    })
    $placeholderImg.removeClass('display-none')
  }

  function _attachAvatarImg({ uploadedImg, target }) {
    let imgSizeMb = uploadedImg.size * 0.000001; // convert bytes to MB
    let $errorText = $('.dm-image-error-text');
    let $imgImgsContainer = $(target).closest('.dm-cropper-boundary').find($imgsContainer);

    if (imgSizeMb <= 32) {
      let reader = new FileReader();

      reader.onload = function(event) {
        let imgOrgElement = `<img src="${event.target.result}" class="avatar-profile-photo" alt=""/>`;
        $imgImgsContainer.empty();
        $imgImgsContainer.append(imgOrgElement);
        $errorText.addClass('hidden');
        _successfulImageLoad({ target });

        $(target).closest('.dm-cropper-boundary').find('.dm-cropper-delete-image input[type="checkbox"]').prop('checked', false);
      };

      reader.readAsDataURL(uploadedImg);
    } else {
      $imgImgsContainer.empty();
      $errorText.removeClass('hidden');
      $errorText.find('p').text('Sorry, you cannot upload an image larger than 32MB.');
      _failedImageLoad({ target });
    }
  }

  function _failedImageLoad({ target }) {
    _toggleDeleteBtn({ visible: false, target });
    _clearUpload({ target });
    // _toggleEditBtn({ visible: false, target })
    // _setCropBoxValues({ isCrop: false, target });
    // _toggleCropperBtnView({ visible: false, target });
  }

  function _successfulImageLoad({ target }) {
    // _toggleEditBtn({ visible: true, target })
    _toggleDeleteBtn({ visible: true, target });
    // _setCropBoxValues({ isCrop: false, target });
    // _toggleCropperBtnView({ visible: false, target });
  }

  function _attachUploadEventListener() {
    $('.dm-cropper-upload-image').on('change', (event) => {
      _attachAvatarImg({ uploadedImg: event.target.files[0], target: event.target });
      $placeholderImg.addClass('display-none');
    })
  }

  function _attachDeleteEventListener() {
    $deleteBtn.click((event) => {
      _clearUpload({ target: event.target })
      _toggleDeleteBtn({ visible: false, target: event.target });
      // _toggleEditBtn({ visible: false, target: event.target });
      // _toggleCropperBtnView({ visible: false, target: event.target });
      // _setCropBoxValues({ isCrop: false, target: event.target });
    });
  }

  // Photo editing logic, taken from overview_image_editor file, needs adjusting to get working properly:

  // function _attachEditEventListener() {
  //   $editBtn.click((event)  => {
  //     event.preventDefault();
  //     _toggleCropper({ visible: true, target: event.target });
  //     // _toggleDeleteBtn({ visible: false, target: event.target });
  //     _toggleImageView({ isCrop: true, target: event.target });
  //     // _toggleCropperBtnView({ visible: true, target: event.target });
  //     // _toggleEditBtn({ visible: false, target: event.target });
  //   });
  // }

  // function _attachSaveEditEventListener() {
  //   $saveEditBtn.click((event) => {
  //     _setCropBoxValues({ isCrop: true, target: event.target });
  //   });
  // }

  // function _attachCancelEditEventListener() {
  //   $cancelEditBtn.click((event) => {
  //     _toggleImageView({ isCrop: false, target: event.target })
  //     _toggleDeleteBtn({ visible: true, target: event.target });
  //     // _toggleCropper({ visible: false, target: event.target });
  //     // _toggleCropperBtnView({ visible: false, target: event.target });
  //     // _toggleEditBtn({ visible: true, target: event.target });
  //     // _setCropBoxValues({ isCrop: false, target: event.target });
  //   });
  // }

  // function _toggleCropperBtnView({ visible, target}) {
  //   let $imgSaveEditBtn = $(target).closest('.dm-cropper-boundary').find($saveEditBtn)
  //   let $imgCancelEditBtn = $(target).closest('.dm-cropper-boundary').find($cancelEditBtn)

  //   if (visible) {
  //     $imgSaveEditBtn.removeClass('hidden');
  //     $imgCancelEditBtn.removeClass('hidden');
  //   } else {
  //     $imgSaveEditBtn.addClass('hidden');
  //     $imgCancelEditBtn.addClass('hidden');
  //   }
  // }

  // function _createModifiedImage({ target }) {
  //   let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');
  //   let setAsCanvas = $(target).closest('.dm-cropper-boundary').find($imgsContainer).hasClass('dm-resource-image');
  //   if ($image && $image.data('cropper')) {
  //     // Generate the cropped image as a canvas
  //     $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original').addClass('hidden')
  //     let croppedCanvas = $image.data('cropper').getCroppedCanvas({ width: 310 })
  //     if (setAsCanvas) {
  //       croppedCanvas.classList.add('dm-cropper-thumbnail-modified')
  //       $(target).closest('.dm-cropper-boundary').find($imgsContainer).append(croppedCanvas)
  //     } else {
  //       let url = croppedCanvas.toDataURL();
  //       let image = new Image();
  //       image.src = url;
  //       image.classList.add('dm-cropper-thumbnail-modified')
  //       $(target).closest('.dm-cropper-boundary').find($imgsContainer).append(image)
  //     }

  //     // Optionally, toggle other UI elements (e.g., hide Save/Cancel, show Edit)
  //     _toggleCropperBtnView({ visible: false, target });
  //     _toggleEditBtn({ visible: true, target });
  //     _toggleDeleteBtn({ visible: true, target });
  //   }
  // }


  // function _toggleImageView({ isCrop, target }) {
  //   let $originalImage = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');
  //   let $modifiedCanvas = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-modified');

  //   if (isCrop && $originalImage) {
  //     $originalImage.removeClass('hidden');
  //     $modifiedCanvas.addClass('hidden')
  //   } else {
  //     if ($modifiedCanvas.length > 0) {
  //       $originalImage.addClass('hidden');
  //       $modifiedCanvas.removeClass('hidden')
  //     } else {
  //       $originalImage.removeClass('hidden');
  //     }
  //   }
  // }

  // function _toggleCropper({ visible, target }) {
  //   let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

  //   if (visible) {
  //     let cropOptions = {
  //         checkCrossOrigin: false,
  //         checkOrientation: true,
  //         viewMode: 2,
  //         minContainerWidth: 100,
  //         aspectRatio: 1
  //     }

  //     // create Cropper instance
  //     $image.cropper(cropOptions);
  //   } else {
  //     if ($image.data('cropper')) {
  //       $image.data('cropper').destroy();
  //     }
  //   }
  // }

  // function _toggleEditBtn({ visible, target }) {
  //   let $imgEditBtn = $(target).closest('.dm-cropper-boundary').find($editBtn)

  //   if (visible) {
  //     $imgEditBtn.removeClass('hidden');
  //   } else {
  //     $imgEditBtn.addClass('hidden');
  //   }
  // }

  // function _setCropBoxValues({ isCrop, target }) {
  //   let $image = $(target).closest('.dm-cropper-boundary').find('.dm-cropper-thumbnail-original');

  //   if (isCrop && $image.data('cropper')) {
  //     let cropValues = $image.data('cropper').getData(true);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_x").val(cropValues.x);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_y").val(cropValues.y);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_w").val(cropValues.width);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_h").val(cropValues.height);

  //     _createModifiedImage({ target })
  //     _toggleCropper({ visible: false, target });
  //     _toggleCropperBtnView({ visible: false, target });
  //     _toggleEditBtn({ visible: true, target });
  //     _toggleDeleteBtn({ visible: true, target });
  //     _toggleImageView({ isCrop: false, target });
  //   } else {
  //     $(target).closest('.dm-cropper-boundary').find(".crop_x").val(null);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_y").val(null);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_w").val(null);
  //     $(target).closest('.dm-cropper-boundary').find(".crop_h").val(null);
  //   }
  // }

  function attachImgActionsEventListeners() {
    _attachUploadEventListener();
    _attachDeleteEventListener();
    // _attachEditEventListener();
    // _attachSaveEditEventListener();
    // _attachCancelEditEventListener();
  }

  function setImageVars() {
    $deleteBtn = $('.dm-cropper-delete-image');
    $imgsContainer = $('.dm-cropper-images-container');
    $placeholderImg = $('.cropper-image-placeholder');
    // $editBtn = $('.dm-cropper-edit-mode');
    // $cancelEditBtn = $('.dm-cropper-cancel-edit');
    // $saveEditBtn = $('.dm-cropper-save-edit');
  }

  function attachNewFieldEventListeners() {
    $document.arrive('.dm-cropper-boundary', (newElem) => {
      setImageVars();
      _attachUploadEventListener();
      // _attachSaveEditEventListener();
      // _attachCancelEditEventListener();
    })
  }

  function loadCropperFunctions() {
    setImageVars();
    attachImgActionsEventListeners();
    attachNewFieldEventListeners();
}

  $document.on('turbolinks:load', loadCropperFunctions);
})(window.jQuery);
