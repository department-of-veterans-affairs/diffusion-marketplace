(($) => {
    const $document = $(document);
    const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
    
    const NAME_CHARACTER_COUNT = 50;
    const TAGLINE_CHARACTER_COUNT = 150;
    const SUMMARY_CHARACTER_COUNT = 400;

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

    function removePracticeThumbnail() {
        let placeholder = $('#practice-thumbnail-placeholder')
        let thumbnailExists = placeholder.find('img').length
        let defaultThumbnail = "<div class='bg-base-lightest position-relative radius-md' style='height: 300px; width: 350px;'><i class='fas fa-images fa-4x text-base-lighter no-impact-image'></i></div>"

        $('#practice_delete_main_display_image').click((event) => {
            if (thumbnailExists) {
                placeholder.empty()
                placeholder.append(defaultThumbnail)
            }
        })
    }

    function clearPracticeThumbnailRemoval() {
        let thumbnailFileUpload = $('#practice_main_display_image')
        let thumbnailRemoveInput = $('#practice_delete_main_display_image')

        // triggers only on successful image upload
        thumbnailFileUpload.on('change', (event) => {
            thumbnailRemoveInput.val('false')
        })
    }

    function loadPracticeEditorFunctions() {
        getFacilitiesByState();
        countCharsOnPageLoad();
        maxCharacters();
        uncheckAllPartnerBoxes();
        uncheckNoneOptionIfAnotherOptionIsChecked();
        removePracticeThumbnail();
        clearPracticeThumbnailRemoval()

        if(selectedFacility) {
            selectFacility();
        }
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);