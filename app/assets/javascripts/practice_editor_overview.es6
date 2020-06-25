(($) => {
    const $document = $(document);
    const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';

    const NAME_CHARACTER_COUNT = 50;
    const TAGLINE_CHARACTER_COUNT = 150;
    const SUMMARY_CHARACTER_COUNT = 400;

    function countCharsOnPageLoad() {
        let practiceNameCurrentLength = $('.practice-editor-name-input').val().length;
        // let practiceTaglineCurrentLength = $('.practice-editor-tagline-textarea').val().length;
        let practiceSummaryCurrentLength = $('.practice-editor-summary-textarea').val().length;

        let practiceNameCharacterCounter = `(${practiceNameCurrentLength}/${NAME_CHARACTER_COUNT} characters)`;
        // let practiceTaglineCharacterCounter = `(${practiceTaglineCurrentLength}/${TAGLINE_CHARACTER_COUNT} characters)`;
        let practiceSummaryCharacterCounter = `(${practiceSummaryCurrentLength}/${SUMMARY_CHARACTER_COUNT} characters)`;

        $('#practice-editor-name-character-counter').text(practiceNameCharacterCounter);
        // $('#practice-editor-tagline-character-counter').text(practiceTaglineCharacterCounter);
        $('#practice-editor-summary-character-counter').text(practiceSummaryCharacterCounter);

        if (practiceNameCurrentLength >= NAME_CHARACTER_COUNT) {
            $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
        // if (practiceTaglineCurrentLength >= TAGLINE_CHARACTER_COUNT) {
        //     $('#practice-editor-tagline-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        // }
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

    function loadPracticeEditorFunctions() {
        countCharsOnPageLoad();
        maxCharacters();
        uncheckAllPartnerBoxes();
        uncheckNoneOptionIfAnotherOptionIsChecked();

        // relies on `_facilitySelect.js` utility file to be loaded prior to this file
        debugger
        getFacilitiesByState(facilityData);
        getAdoptionFacilitiesByState(facilityData);
        if(selectedFacility) {
            selectFacility(facilityData, selectedFacility);
        }
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);
