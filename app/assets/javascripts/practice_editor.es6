(($) => {
    const $document = $(document);

    function getFacilitiesByState() {
        let facilitySelect = $('#editor_facility_select');
        facilitySelect.css('color', '#a9aeb1');
        facilitySelect.prop('disabled', 'disabled');
        $('#editor_state_select').on('change', () => {
            let selectedState = $('#editor_state_select option:selected').val();
            facilitySelect.css('color', 'initial');
            facilitySelect.removeAttr('disabled');
            facilitySelect.find('option:not(:first)').remove();

            let filteredFacilites = facilityData.filter(f => f.MailingAddressState === selectedState);
            console.log(filteredFacilites)
            filteredFacilites.forEach(facility => {
                facilitySelect
                    .append($("<option></option>")
                    .attr("value", facility.StationNumber)
                    .attr("class", 'usa-select')
                    .text(facility.OfficialStationName))
           });
        })
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
            $('#practice-editor-name-character-counter').css('color', '#e52207');
        }
        if (practiceTaglineCurrentLength >= maxPracticeTaglineLength) {
            $('#practice-editor-tagline-character-counter').css('color', '#e52207');
        }
        if (practiceSummaryCurrentLength >= maxPracticeSummaryLength) {
            $('#practice-editor-summary-character-counter').css('color', '#e52207');
        }
    };
      
    //   $(document).ready(function() {
    //     countChar();
    //     $('#textBox').change(countChar);
    //   });

    function maxCharacters() {
        $('.practice-editor-name-input').on('input', (e) => {
            const t = e.target
            let maxlength = 50;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-name-character-counter').css('color', '#a9aeb1');
            $('#practice-editor-name-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-name-character-counter').css('color', '#e52207');
            }
        });

        $('.practice-editor-tagline-textarea').on('input', (e) => {
            const t = e.target
            let maxlength = 150;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-tagline-character-counter').css('color', '#a9aeb1');
            $('#practice-editor-tagline-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-tagline-character-counter').css('color', '#e52207');
            }
        });

        $('.practice-editor-summary-textarea').on('input', (e) => {
            const t = e.target
            let maxlength = 400;
            let currentLength = $(t).val().length;

            let characterCounter = `(${currentLength}/${maxlength} characters)`;

            $('#practice-editor-summary-character-counter').css('color', '#a9aeb1');
            $('#practice-editor-summary-character-counter').text(characterCounter);

            if (currentLength >= maxlength) {
                $('#practice-editor-summary-character-counter').css('color', '#e52207');
            }
        });
    }

    function loadPracticeEditorFunctions() {
        getFacilitiesByState();
        countCharsOnPageLoad();
        maxCharacters();
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);