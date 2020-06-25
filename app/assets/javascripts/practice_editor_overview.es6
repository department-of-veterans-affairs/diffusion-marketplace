(($) => {
    const $document = $(document);
    const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';

    const NAME_CHARACTER_COUNT = 50;
    const TAGLINE_CHARACTER_COUNT = 150;
    const SUMMARY_CHARACTER_COUNT = 400;

    const facilityOption = '#initiating_facility_type_facility';
    const visnOption = '#initiating_facility_type_visn';
    const departmentOption = '#initiating_facility_type_department';

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

    function addDisableAttrAndColor(labelSelector, inputSelector) {
        const disabledColor = '#c9c9c9';
        labelSelector.css('color', disabledColor);
        inputSelector.css('color', disabledColor);
        inputSelector.css('border-color', disabledColor);
        inputSelector.css('background-color', '#FFFFFF');
        inputSelector.prop('disabled', true);
    }

    function disableOtherFacilityInputOptions(otherOptions) {
        otherOptions.split(' ').forEach(oo => {
            addDisableAttrAndColor($('label[for="' + oo + '"]'), $(`#${oo}`));
        })
    }

    function disableOptions() {
        if ($(`${facilityOption}:checked`).length > 0) {
            // console.log('hello facility')
            disableOtherFacilityInputOptions('editor_visn_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
        } else if ($(`${visnOption}:checked`).length > 0) {
            // console.log('hello visn')
            disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
        } else if ($(`${departmentOption}:checked`).length > 0) {
            // console.log('hello department')
            disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select practice_initiating_facility_other')
        } else {
            // console.log('hello other')
            disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select editor_department_select editor_office_state_select editor_office_select')
        }
    }

    function disableInputsOnLoad() {
        disableOptions();
    }

    function addEnableAttrAndColor(labelSelector, inputSelector) {
        const enabledColor = 'initial';
        labelSelector.css('color', `${enabledColor}`);
        inputSelector.css('color', `${enabledColor}`);
        inputSelector.css('border-color', `${enabledColor}`);
        inputSelector.prop('disabled', false);
        console.log('labelSelector', labelSelector);
        console.log('inputSelector', inputSelector);
    }

    function enableCurrentlySelectedOption(currentOptionInputs) {
        console.log('inside enableCurrentlySelected')
        console.log('current option', currentOptionInputs)
        currentOptionInputs.split(' ').forEach(oi => {
            addEnableAttrAndColor($('label[for="' + oi + '"]'), $(`#${oi}`));
        });
    }

    function toggleInputsOnRadioSelect() {
        $(document).on('click', '#initiating_facility_type_facility, #initiating_facility_type_visn, #initiating_facility_type_department, #initiating_facility_type_other', function() {
            disableOptions();

            if ($(`${facilityOption}:checked`).length > 0) {
                // console.log('hello facility');
                enableCurrentlySelectedOption('editor_state_select');
                disableOtherFacilityInputOptions('editor_visn_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
            } else if ($(`${visnOption}:checked`).length > 0) {
                // console.log('hello visn');
                enableCurrentlySelectedOption('editor_visn_select');
                disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
            } else if ($(`${departmentOption}:checked`).length > 0) {
                // console.log('hello department');
                enableCurrentlySelectedOption('editor_department_select');
                disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select practice_initiating_facility_other')
            } else {
                // console.log('hello other')
                enableCurrentlySelectedOption('practice_initiating_facility_other')
                disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select editor_department_select editor_office_state_select editor_office_select')
            }
        })
    }

    function loadPracticeEditorFunctions() {
        countCharsOnPageLoad();
        maxCharacters();
        uncheckAllPartnerBoxes();
        uncheckNoneOptionIfAnotherOptionIsChecked();
        disableInputsOnLoad();
        toggleInputsOnRadioSelect();

        // relies on `_facilitySelect.js` utility file to be loaded prior to this file
        getFacilitiesByState(facilityData);
        if(selectedFacility !== "false" && selectedFacility !== "") {
            console.log('in selectedFacility', selectedFacility)
            selectFacility(facilityData, selectedFacility);
        }

        // relies on `_visnSelect.js` utility file to be loaded prior to this file
        if (selectedVisn !== "false" && selectedVisn !== "") {
            console.log('in selectedVisn', selectedVisn)
            selectVisn(originData, selectedVisn)
        }

        // relies on `_officeSelect.js` utility file to be loaded prior to this file
        getStatesByDepartment(originData);
        getOfficesByState(originData);
        if (selectedOffice !== "false" && selectedDepartment !== "false" && selectedOffice !== "" && selectedDepartment !== "") {
            console.log('in selectedOffice', selectedOffice)
            selectOffice(originData, selectedDepartment, selectedOffice)
        }
    }

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);
