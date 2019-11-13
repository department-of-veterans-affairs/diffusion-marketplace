(($) => {
    const $document = $(document);
    const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';

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

        let maxPracticeNamelength = 50;
        let maxPracticeTaglineLength = 150;
        let maxPracticeSummaryLength = 400;

        let practiceNamecharacterCounter = `(${practiceNameCurrentLength}/${maxPracticeNamelength} characters)`;
        let practiceTaglinecharacterCounter = `(${practiceTaglineCurrentLength}/${maxPracticeTaglineLength} characters)`;
        let practiceSummarycharacterCounter = `(${practiceSummaryCurrentLength}/${maxPracticeSummaryLength} characters)`;

        $('#practice-editor-name-character-counter').text(practiceNamecharacterCounter);
        $('#practice-editor-tagline-character-counter').text(practiceTaglinecharacterCounter);
        $('#practice-editor-summary-character-counter').text(practiceSummarycharacterCounter);
        
        

        if (practiceNameCurrentLength >= maxPracticeNamelength) {
            $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
        if (practiceTaglineCurrentLength >= maxPracticeTaglineLength) {
            $('#practice-editor-tagline-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
        if (practiceSummaryCurrentLength >= maxPracticeSummaryLength) {
            $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
        }
    }

    function maxCharacters() {
        $('.practice-editor-name-input').on('input', (e) => {
            const t = e.target
            let maxlength = 50;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_VALID_COLOR);
            $('#practice-editor-name-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
            }
        });

        $('.practice-editor-tagline-textarea').on('input', (e) => {
            const t = e.target
            let maxlength = 150;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-tagline-character-counter').css('color', CHARACTER_COUNTER_VALID_COLOR);
            $('#practice-editor-tagline-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-tagline-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
            }
        });

        $('.practice-editor-summary-textarea').on('input', (e) => {
            const t = e.target
            let maxlength = 400;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_VALID_COLOR);
            $('#practice-editor-summary-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
            }
        });
    }

    function loadPracticeEditorFunctions() {
        getFacilitiesByState();
        countCharsOnPageLoad();
        maxCharacters();

        if(selectedFacility) {
            selectFacility();
        }
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);