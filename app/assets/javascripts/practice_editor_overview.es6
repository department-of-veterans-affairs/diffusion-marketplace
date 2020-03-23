(($) => {
    const $document = $(document);
    const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';

    const NAME_CHARACTER_COUNT = 50;
    const TAGLINE_CHARACTER_COUNT = 150;
    const SUMMARY_CHARACTER_COUNT = 400;

    let cropper;
    let $editBtn;
    let $saveEditBtn;
    let $cancelEditBtn;
    let $deleteBtn;

    // select the state and facility if the practice already has one
    function selectFacility() {
        // based on the facilityData, which is the selected facility?
        const facility = facilityData.find(f => f.StationNumber === String(selectedFacility) );

        // select the state and set it in the dropdown
        const state = facility.MailingAddressState;
        const stateSelect = $('#editor_state_select');
        stateSelect.val(state);

        // filter the facilities in the dropdown
        const facilitySelect = $('#editor_facility_select');
        filterFacilities(facilitySelect);

        // select the facility and display it in the dropdown
        facilitySelect.val(facility.StationNumber);
    }

    function getFacilitiesByState() {
        let facilitySelect = $('#editor_facility_select');
        facilitySelect.css('color', CHARACTER_COUNTER_VALID_COLOR);
        facilitySelect.prop('disabled', 'disabled');
        $('#editor_state_select').on('change', () => {
            filterFacilities(facilitySelect);
        });
    }

    function filterFacilities(facilitySelect) {
        let selectedState = $('#editor_state_select option:selected').val();
        facilitySelect.css('color', 'initial');
        facilitySelect.removeAttr('disabled');
        facilitySelect.find('option:not(:first)').remove();
        facilitySelect.val('-Select-');

        let filteredFacilites = facilityData.filter(f => f.MailingAddressState === selectedState);
        filteredFacilites.forEach(facility => {
            facilitySelect
                .append($("<option></option>")
                    .attr("value", facility.StationNumber)
                    .attr("class", 'usa-select')
                    .text(facility.OfficialStationName))
        });
    }

    function countCharsOnPageLoad() {
        let practiceNameCurrentLength = $('.practice-editor-name-input').val().length;
        let practiceTaglineCurrentLength = $('.practice-editor-tagline-textarea').val().length;
        let practiceSummaryCurrentLength = $('.practice-editor-summary-textarea').val().length;

        let practiceNameCharacterCounter = `(${practiceNameCurrentLength}/${NAME_CHARACTER_COUNT} characters)`;
        let practiceTaglineCharacterCounter = `(${practiceTaglineCurrentLength}/${TAGLINE_CHARACTER_COUNT} characters)`;
        let practiceSummaryCharacterCounter = `(${practiceSummaryCurrentLength}/${SUMMARY_CHARACTER_COUNT} characters)`;

        $('#practice-editor-name-character-counter').text(practiceNameCharacterCounter);
        $('#practice-editor-tagline-character-counter').text(practiceTaglineCharacterCounter);
        $('#practice-editor-summary-character-counter').text(practiceSummaryCharacterCounter);

        if (practiceNameCurrentLength >= NAME_CHARACTER_COUNT) {
            $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
        if (practiceTaglineCurrentLength >= TAGLINE_CHARACTER_COUNT) {
            $('#practice-editor-tagline-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
        if (practiceSummaryCurrentLength >= SUMMARY_CHARACTER_COUNT) {
            $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
    }

    function characterCounter(e, $element, maxlength) {
        const t = e.target;
        let currentLength = $(t).val().length;

        let characterCounter = `(${currentLength}/${maxlength} characters)`;

        $element.css('color', CHARACTER_COUNTER_VALID_COLOR);
        $element.text(characterCounter);

        if (currentLength >= maxlength) {
            $element.css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
    }

    function maxCharacters() {
        $('.practice-editor-name-input').on('input', (e) => {
            characterCounter(e, $('#practice-editor-name-character-counter'), NAME_CHARACTER_COUNT);
        });

        $('.practice-editor-tagline-textarea').on('input', (e) => {
            characterCounter(e, $('#practice-editor-tagline-character-counter'), TAGLINE_CHARACTER_COUNT);
        });

        $('.practice-editor-summary-textarea').on('input', (e) => {
            characterCounter(e, $('#practice-editor-summary-character-counter'), SUMMARY_CHARACTER_COUNT);
        });
    }

    function uncheckAllPartnerBoxes() {
        $('.no-partner-input').click(function(event) {
            if(this.checked) {
                $('.partner-input').each(function() {
                    this.checked = false;
                });
            }
        });
    }

    function uncheckNoneOptionIfAnotherOptionIsChecked() {
        $('.partner-input').click(function(event) {
            if(this.checked) {
                $('.no-partner-input').prop('checked', false);
            }
        });
    }

    function _setDefaultPracticeThumbnail() {
        let $placeholder = $('#practice-thumbnail-placeholder');
        let thumbnailExists = $placeholder.find('img').length;
        let defaultThumbnail = "<div class='bg-base-lightest position-relative radius-md height-mobile' style='height: 320px; width: 372px;'><i class='fas fa-images fa-4x text-base-lighter no-impact-image'></i></div>";
        if (thumbnailExists) {
            $placeholder.empty();
            $placeholder.append(defaultThumbnail);
        }
    }

    function _toggleBtnsOnPlaceholderChange({ isUpload }) {
        let $deleteBtnLabel = $('.remove-main-display-image-link');
        let $uploadBtnLabel = $('.upload-main-display-image-link');

        if (isUpload) {
            $uploadBtnLabel.text('Upload new photo');
            $uploadBtnLabel.removeClass('usa-button');
            $deleteBtnLabel.removeClass('hidden');
            $deleteBtn.removeClass('hidden');
        } else {
            $uploadBtnLabel.text('Upload photo');
            $uploadBtnLabel.addClass('usa-button');
            $deleteBtnLabel.addClass('hidden');
            $deleteBtn.addClass('hidden');
        }
    }

    function _clearPracticeThumbnailRemoval() {
        let thumbnailRemoveInput = $('#practice_delete_main_display_image');
        thumbnailRemoveInput.val('false');
    }

    function _toggleImageView({ isCrop }) {
        let $originalImage = $('#practice-overview-thumbnail-original');
        let $modifiedImage = $('#practice-overview-thumbnail-modified');
        if (isCrop && $originalImage) {
            $modifiedImage.addClass('hidden');
            $originalImage.removeClass('hidden');
            return $originalImage;
        } else {
            $modifiedImage.removeClass('hidden');
            $originalImage.addClass('hidden');
            return $modifiedImage;
        }
    }

    function _toggleCropper({ visible }) {
        if (visible) {
            let $image = _toggleImageView({ isCrop: true })

            let cropOptions = {
                aspectRatio: 1,
                checkCrossOrigin: false,
                checkOrientation: true,
                viewMode: 2
            }

            // create Cropper instance
            $image.cropper(cropOptions);

            // set Cropper instance
            cropper = $image.data('cropper');
        } else {
            cropper.destroy();
        }
    }

    function _toggleEditBtn({ visible }) {
        if (visible) {
            $editBtn.removeClass('hidden');
        } else {
            $editBtn.addClass('hidden');
        }
    }

    function _setCropBoxValues({ isCrop }) {
        if (isCrop) {
            let cropValues = cropper.getData(true);

            $("#crop_x").val(cropValues.x);
            $("#crop_y").val(cropValues.y);
            $("#crop_w").val(cropValues.width);
            $("#crop_h").val(cropValues.height);
        } else {
            $("#crop_x").val(null);
            $("#crop_y").val(null);
            $("#crop_w").val(null);
            $("#crop_h").val(null);
        }
    }

    function _loadPracticeThumbnail(uploadedImg) {
        let $placeholder = $('#practice-thumbnail-placeholder');
        let reader = new FileReader();

        reader.onload = (function() {
            return function(event) {
                let imgOrgElement = "<img src='" + event.target.result + "' class='height-mobile practice-editor-impact-photo radius-md hidden' id='practice-overview-thumbnail-original' alt='practice thumbnail'/>";
                let imgModElement = "<img src='" + event.target.result + "' class='height-mobile practice-editor-impact-photo radius-md' id='practice-overview-thumbnail-modified' alt='practice thumbnail'/>";

                $placeholder.empty();
                $placeholder.append(imgOrgElement);
                $placeholder.append(imgModElement);
            }
        })()

        // Read in the image file as a data URL
        reader.readAsDataURL(uploadedImg);
    }

    function _toggleCropperBtnView({ visible }) {
        if (visible) {
            $saveEditBtn.removeClass('hidden');
            $cancelEditBtn.removeClass('hidden');
        } else {
            $saveEditBtn.addClass('hidden');
            $cancelEditBtn.addClass('hidden');
        }
    }

    function _attachUploadEventListener() {
        let $thubmanilInput = $('#practice_main_display_image');
        let $placeholder = $('#practice-thumbnail-placeholder');

        $thubmanilInput.on('change', (event) => {
            _loadPracticeThumbnail(event.target.files[0]);
            _clearPracticeThumbnailRemoval();
            _toggleEditBtn({ visible: true })
            _toggleBtnsOnPlaceholderChange({ isUpload: true });
            _setCropBoxValues({ isCrop: false });
            _toggleCropperBtnView({ visible: false });
            if (cropper) {
                _toggleCropper({ visible: false });
            }
        })
    }

    function _attachDeleteEventListener() {
        $deleteBtn.click((event) => {
            _setDefaultPracticeThumbnail();
            _toggleBtnsOnPlaceholderChange({ isUpload: false });
            _toggleEditBtn({ visible: false });
            _toggleCropperBtnView({ visible: false });
        });
    }

    function _attachEditEventListener() {
        $editBtn.click((event) => {
            _toggleCropper({ visible: true });
            _toggleCropperBtnView({ visible: true });
            _toggleEditBtn({ visible: false });
        });
    }

    function _attachSaveEditEventListener() {
        $saveEditBtn.click((event) => {
            _setCropBoxValues({ isCrop: true });
        });
    }

    function _attachCancelEditEventListener() {
        $cancelEditBtn.click((event) => {
            _toggleImageView({ isCrop: false })
            _toggleCropperBtnView({ visible: false });
            _toggleEditBtn({ visible: true });
            _setCropBoxValues({ isCrop: false });
            _toggleCropper({ visible: false });
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
        $editBtn = $('#practice-overview-crop-mode');
        $deleteBtn = $('#practice_delete_main_display_image');
        $cancelEditBtn = $('#practice-overview-cancel-edit');
        $saveEditBtn = $('#practice-overview-save-edit');
    }

    function loadPracticeEditorFunctions() {
        setImageVars();
        getFacilitiesByState();
        countCharsOnPageLoad();
        maxCharacters();
        uncheckAllPartnerBoxes();
        uncheckNoneOptionIfAnotherOptionIsChecked();
        attachImgActionsEventListeners();

        if(selectedFacility) {
            selectFacility();
        }
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);