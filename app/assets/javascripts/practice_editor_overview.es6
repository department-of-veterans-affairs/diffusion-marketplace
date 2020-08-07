(($) => {


    const $document = $(document);
    // const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
    // const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
    //
    // const NAME_CHARACTER_COUNT = 50;
    // const TAGLINE_CHARACTER_COUNT = 150;
    // const SUMMARY_CHARACTER_COUNT = 400;
    //
    // const facilityOption = '#initiating_facility_type_facility';
    // const visnOption = '#initiating_facility_type_visn';
    // const departmentOption = '#initiating_facility_type_department';
    // const otherOption = '#initiating_facility_type_other';
    //
    // function countCharsOnPageLoad() {
    //     let practiceNameCurrentLength = $('.practice-editor-name-input').val().length;
    //     let practiceSummaryCurrentLength = $('.practice-editor-summary-textarea').val().length;
    //
    //     let practiceNameCharacterCounter = `(${practiceNameCurrentLength}/${NAME_CHARACTER_COUNT} characters)`;
    //     let practiceSummaryCharacterCounter = `(${practiceSummaryCurrentLength}/${SUMMARY_CHARACTER_COUNT} characters)`;
    //
    //     $('#practice-editor-name-character-counter').text(practiceNameCharacterCounter);
    //     $('#practice-editor-summary-character-counter').text(practiceSummaryCharacterCounter);
    //
    //     if (practiceNameCurrentLength >= NAME_CHARACTER_COUNT) {
    //         $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
    //     }
    //
    //     if (practiceSummaryCurrentLength >= SUMMARY_CHARACTER_COUNT) {
    //         $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
    //     }
    // }
    //
    // function characterCounter(e, $element, maxlength) {
    //     const t = e.target;
    //     let currentLength = $(t).val().length;
    //
    //     let characterCounter = `(${currentLength}/${maxlength} characters)`;
    //
    //     $element.css('color', CHARACTER_COUNTER_VALID_COLOR);
    //     $element.text(characterCounter);
    //
    //     if (currentLength >= maxlength) {
    //         $element.css('color', CHARACTER_COUNTER_INVALID_COLOR);
    //     }
    // }
    //
    // function maxCharacters() {
    //     $('.practice-editor-name-input').on('input', (e) => {
    //         characterCounter(e, $('#practice-editor-name-character-counter'), NAME_CHARACTER_COUNT);
    //     });
    //
    //     $('.practice-editor-tagline-textarea').on('input', (e) => {
    //         characterCounter(e, $('#practice-editor-tagline-character-counter'), TAGLINE_CHARACTER_COUNT);
    //     });
    //
    //     $('.practice-editor-summary-textarea').on('input', (e) => {
    //         characterCounter(e, $('#practice-editor-summary-character-counter'), SUMMARY_CHARACTER_COUNT);
    //     });
    // }
    //
    // function uncheckAllPartnerBoxes() {
    //     $('.no-partner-input').click(function(event) {
    //         if(this.checked) {
    //             $('.partner-input').each(function() {
    //                 this.checked = false;
    //             });
    //         }
    //     });
    // }
    //
    // function uncheckNoneOptionIfAnotherOptionIsChecked() {
    //     $('.partner-input').click(function(event) {
    //         if(this.checked) {
    //             $('.no-partner-input').prop('checked', false);
    //         }
    //     });
    // }
    //
    // function addDisableAttrAndColor(labelSelector, inputSelector) {
    //     labelSelector.hasClass('enabled-label') ? labelSelector.removeClass('enabled-label') && labelSelector.addClass('disabled-label') : labelSelector.addClass('disabled-label');
    //     inputSelector.hasClass('enabled-input') ? inputSelector.removeClass('enabled-input') && inputSelector.addClass('disabled-input') : inputSelector.addClass('disabled-input');
    //     inputSelector.prop('disabled', true);
    // }
    //
    // function disableOtherFacilityInputOptions(otherOptions) {
    //     otherOptions.split(' ').forEach(oo => {
    //         addDisableAttrAndColor($('label[for="' + oo + '"]'), $(`#${oo}`));
    //     })
    // }
    //
    // function disableOptions() {
    //     if ($(`${facilityOption}:checked`).length > 0) {
    //         disableOtherFacilityInputOptions('editor_visn_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
    //     } else if ($(`${visnOption}:checked`).length > 0) {
    //         disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
    //     } else if ($(`${departmentOption}:checked`).length > 0) {
    //         disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select practice_initiating_facility_other')
    //     } else if ($(`${otherOption}:checked`).length > 0) {
    //         disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select editor_department_select editor_office_state_select editor_office_select')
    //     } else {
    //         disableOtherFacilityInputOptions('editor_state_select editor_facility_select editor_visn_select editor_department_select editor_office_state_select editor_office_select practice_initiating_facility_other')
    //     }
    // }
    //
    // function addEnableAttrAndColor(labelSelector, inputSelector) {
    //     labelSelector.hasClass('disabled-label') ? labelSelector.removeClass('disabled-label') && labelSelector.addClass('enabled-label') : labelSelector.addClass('enabled-label');
    //     inputSelector.hasClass('disabled-input') ? inputSelector.removeClass('disabled-input') && inputSelector.addClass('enabled-input') : inputSelector.addClass('enabled-input');
    //     inputSelector.prop('disabled', false);
    // }
    //
    // function enableCurrentlySelectedOption(currentOptionInputs) {
    //     currentOptionInputs.split(' ').forEach(oi => {
    //         addEnableAttrAndColor($('label[for="' + oi + '"]'), $(`#${oi}`));
    //     });
    // }
    //
    // function showCurrentlySelectedOptions(currentSelectForm){
    //     $(`#${currentSelectForm}`).show();
    //     $(`#${currentSelectForm} :input`).prop("disabled", false);
    // }
    //
    // function hideOtherSelectForms(formsToHide){
    //     formsToHide.forEach(f => {
    //         $(`#${f}`).hide();
    //         $(`#${f} :input`).prop("disabled", true);
    //     });
    // }
    //
    // function toggleInputsOnRadioSelect() {
    //     $(document).on('click', '#initiating_facility_type_facility, #initiating_facility_type_visn, #initiating_facility_type_department, #initiating_facility_type_other', function() {
    //         //disableOptions();
    //         if ($(`${facilityOption}:checked`).length > 0) {
    //             showCurrentlySelectedOptions('facility_select_form');
    //             showCurrentlySelectedOptions('more_facilities_container');
    //             hideOtherSelectForms(['visn_select_form', 'office_select_form', 'other_select_form' ]);
    //         } else if ($(`${visnOption}:checked`).length > 0) {
    //             showCurrentlySelectedOptions('visn_select_form');
    //             hideOtherSelectForms(['facility_select_form', 'office_select_form', 'other_select_form', 'more_facilities_container' ]);
    //         } else if ($(`${departmentOption}:checked`).length > 0) {
    //             showCurrentlySelectedOptions('office_select_form');
    //             hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'other_select_form', 'more_facilities_container' ]);
    //         } else {
    //             showCurrentlySelectedOptions('other_select_form');
    //             hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'office_select_form', 'more_facilities_container' ]);
    //         }
    //     })
    // }
    //
    // function toggleInputsOnLoad() {
    //     if(selectedFacilityType !== 'other'){
    //         document.getElementById('initiating_facility_other').value = "";
    //     }
    //     if (selectedFacilityType == 'facility') {
    //         showCurrentlySelectedOptions('facility_select_form');
    //         hideOtherSelectForms(['visn_select_form', 'office_select_form', 'other_select_form' ]);
    //     } else if (selectedFacilityType == 'visn') {
    //         showCurrentlySelectedOptions('visn_select_form');
    //         hideOtherSelectForms(['facility_select_form', 'office_select_form', 'other_select_form', 'more_facilities_container' ]);
    //     } else if (selectedFacilityType == 'department') {
    //         showCurrentlySelectedOptions('office_select_form');
    //         hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'other_select_form', 'more_facilities_container' ]);
    //     } else {
    //         showCurrentlySelectedOptions('other_select_form');
    //         hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'office_select_form', 'more_facilities_container' ]);
    //     }
    // }
    //
    //
    //
    // function loadPracticeEditorFunctions() {
    //     countCharsOnPageLoad();
    //     maxCharacters();
    //     uncheckAllPartnerBoxes();
    //     uncheckNoneOptionIfAnotherOptionIsChecked();
    //     toggleInputsOnRadioSelect();
    //     toggleInputsOnLoad();
    //
    //     // relies on `_facilitySelect.js` utility file to be loaded prior to this file
    //     filterFacilitiesOnRadioSelect(facilityData);
    //     getFacilitiesByState(facilityData);
    //
    //     // relies on `_visnSelect.js` utility file to be loaded prior to this file
    //     if (selectedVisn !== "false" && selectedVisn !== "") {
    //         selectVisn(originData, selectedVisn)
    //     }
    //
    //     // relies on `_officeSelect.js` utility file to be loaded prior to this file
    //     disableAndSelectDepartmentOptionValue();
    //     filterDepartmentTypeOptionsOnRadioSelect(originData);
    //     getStatesByDepartment(originData);
    //     getOfficesByState(originData);
    //     if (selectedOffice !== "false" && selectedDepartment !== "false" && selectedOffice !== "" && selectedDepartment !== "") {
    //         selectOffice(originData, selectedDepartment, selectedOffice)
    //     }
    // }

    function hideResources(){
        document.getElementById('problem_image_form').style.display = 'none';
        document.getElementById('problem_video_form').style.display = 'none';
        document.getElementById('problem_file_form').style.display = 'none';
        document.getElementById('problem_link_form').style.display = 'none';

        document.getElementById('solution_image_form').style.display = 'none';
        document.getElementById('solution_video_form').style.display = 'none';
        document.getElementById('solution_file_form').style.display = 'none';
        document.getElementById('solution_link_form').style.display = 'none';
        document.getElementById('solution_resource_video_form').style.display = 'none';
        document.getElementById('solution_resource_file_form').style.display = 'none';
        document.getElementById('solution_resource_image_form').style.display = 'none';
        document.getElementById('solution_resource_link_form').style.display = 'none';


        //document.getElementById('results_image_form').style.display = 'none';
        document.getElementById('results_resource_image_form').style.display = 'none';
        document.getElementById('results_video_form').style.display = 'none';
        document.getElementById('results_file_form').style.display = 'none';
        document.getElementById('results_link_form').style.display = 'none';
        document.getElementById('results_resource_video_form').style.display = 'none';
        document.getElementById('results_resource_file_form').style.display = 'none';
        document.getElementById('results_resource_image_form').style.display = 'none';
        document.getElementById('results_resource_link_form').style.display = 'none';
    }


    $document.on('turbolinks:load', hideResources);
})(window.jQuery);

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#blah').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#imgInp").change(function(){
    readURL(this);
});

function displayResourceForm(sArea, sType){
    var form_container = document.getElementById('display_' + sArea + '_form');
    switch (sType) {
        case 'image':
            document.getElementById(sArea + '_image_form').style.display = 'block';
            document.getElementById(sArea + '_resource_image_form').style.display = 'block';
            document.getElementById('display_' + sArea + '_resources_image').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'video':
            document.getElementById(sArea + '_video_form').style.display = 'block';
            document.getElementById(sArea + '_resource_video_form').style.display = 'block';
            document.getElementById('display_' + sArea + '_resources_video').style.display = 'block';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'file':
            document.getElementById(sArea + '_file_form').style.display = 'block';
            document.getElementById(sArea + '_resource_file_form').style.display = 'block';
            document.getElementById('display_' + sArea + '_resources_file').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'link':
            document.getElementById(sArea + '_link_form').style.display = 'block';
            document.getElementById(sArea + '_resource_link_form').style.display = 'block';
            document.getElementById('display_' + sArea + '_resources_link').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            break;
        default: form_container.innerHTML = "unknown_form";
    }
}

function addImageFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }



    //for (i=0;i<number;i++){
        // Append a node with a random text

        form_container.appendChild(document.createTextNode("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB.  If you want to upload " +
            "an image that features a Veteran you must have FORM 3203.  Waivers must be filled out with the 'External to VA' check box selected."));
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(document.createElement("br"));

        var sGuid = createGUID();

        var input = document.createElement("INPUT");
        input.setAttribute("type", "file");
        form_container.appendChild(input);
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(document.createElement("br"));




        sGuid = createGUID();
        // Create an <input> element, set its type and name attributes
        input = document.createElement("input");
        input.type = "text";
        input.name = sGuid;
        input.id = sGuid;
        input.style.width = "643px";
        input.required = true;
        var label = document.createElement("Label");
        label.htmlFor = sGuid;
        label.innerHTML="Caption";
        form_container.appendChild(label);
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(input);
        form_container.appendChild(document.createElement("br"));
}

function addVideoFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;
    input.placeholder = "https://www.youtube.com/watch?"
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Link (paste the full Youtube address)";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Caption";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));

}

function addLinkFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Link (paste the full address)";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Title";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "309px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();

    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Description";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
}

function addFileFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }

    form_container.appendChild(document.createTextNode("Upload a .pdf, .docx, .xlxs, .jpg, or .png file that is less than 32MB. "));
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "393px";
    input.required = true;
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="File name";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="File description";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
}

function attachAddResourceListener(formSelector, container){
    $(document).on('click', `#${formSelector} .add-resource`, function(e){
        debugger;
        e.preventDefault();
        const link_form = $(`#${formSelector}`).clone();
        const nGuid = createGUID();

        $.each($(`#${formSelector} input`), function(i, ele){
            $(ele).attr('name', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
            $(ele).attr('id', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });

        $.each($(`#${formSelector} label`), function(i, ele){
            $(ele).attr('for', $(ele).attr('for').replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });


        link_form.appendTo(`#${container}`);
        document.getElementById(container).style.display = 'block';
    });
}


