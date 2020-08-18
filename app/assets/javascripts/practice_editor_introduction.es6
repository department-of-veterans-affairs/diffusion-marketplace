(($) => {
    const $document = $(document);

    const facilityOption = '#initiating_facility_type_facility';
    const visnOption = '#initiating_facility_type_visn';
    const departmentOption = '#initiating_facility_type_department';
    const otherOption = '#initiating_facility_type_other';

    function showCurrentlySelectedOptions(currentSelectForm){
        $(`#${currentSelectForm}`).show();
        $(`#${currentSelectForm} :input`).prop("disabled", false);
    }
    function hideOtherSelectForms(formsToHide){
        formsToHide.forEach(f => {
            $(`#${f}`).hide();
            $(`#${f} :input`).prop("disabled", true);
        });
    }
    function toggleInputsOnRadioSelect() {
        $(document).on('click', '#initiating_facility_type_facility, #initiating_facility_type_visn, #initiating_facility_type_department, #initiating_facility_type_other', function() {
            //disableOptions();
            if ($(`${facilityOption}:checked`).length > 0) {
                showCurrentlySelectedOptions('facility_select_form');
                showCurrentlySelectedOptions('more_facilities_container');
                hideOtherSelectForms(['visn_select_form', 'office_select_form', 'other_select_form' ]);
            } else if ($(`${visnOption}:checked`).length > 0) {
                showCurrentlySelectedOptions('visn_select_form');
                hideOtherSelectForms(['facility_select_form', 'office_select_form', 'other_select_form', 'more_facilities_container' ]);
            } else if ($(`${departmentOption}:checked`).length > 0) {
                showCurrentlySelectedOptions('office_select_form');
                hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'other_select_form', 'more_facilities_container' ]);
            } else {
                showCurrentlySelectedOptions('other_select_form');
                hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'office_select_form', 'more_facilities_container' ]);
            }
        })
    }
    function toggleInputsOnLoad() {
        if(selectedFacilityType !== 'other'){
            document.getElementById('initiating_facility_other').value = "";
        }
        if (selectedFacilityType == 'facility') {
            showCurrentlySelectedOptions('facility_select_form');
            hideOtherSelectForms(['visn_select_form', 'office_select_form', 'other_select_form' ]);
        } else if (selectedFacilityType == 'visn') {
            showCurrentlySelectedOptions('visn_select_form');
            hideOtherSelectForms(['facility_select_form', 'office_select_form', 'other_select_form', 'more_facilities_container' ]);
        } else if (selectedFacilityType == 'department') {
            showCurrentlySelectedOptions('office_select_form');
            hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'other_select_form', 'more_facilities_container' ]);
        } else {
            showCurrentlySelectedOptions('other_select_form');
            hideOtherSelectForms(['facility_select_form', 'visn_select_form', 'office_select_form', 'more_facilities_container' ]);
        }
    }



    function attachFacilitySelectListener() {
        observePracticeEditorLiArrival($document);
        attachTrashListener($document);
    }

    function attachShowOtherAwardFields() {
        observePracticeEditorLiArrival(
            $document,
            '.practice-editor-other-awards-li',
            '.practice-editor-awards-ul'
        );
        $document.on('change', '#practice_award_other', function() {
            showOtherAwardFields();
        });

        attachTrashListener(
            $document,
            '#other_awards_container',
            '.practice-editor-other-awards-li'
        );
    }

    function attachShowOtherCategoryFields() {
        observePracticeEditorLiArrival(
            $document,
            '.practice-editor-category-li',
            '.practice-editor-categories-ul',
            '8'
        );
        $document.on('change', '#category_other', function() {
            showOtherCategoryFields();
        });

        attachTrashListener(
            $document,
            '#other_categories_container',
            '.practice-editor-category-li'
        );
    }


    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        attachShowOtherAwardFields();
        attachShowOtherCategoryFields();
        toggleInputsOnRadioSelect();
        toggleInputsOnLoad();
        // relies on `_facilitySelect.js` utility file to be loaded prior to this file
        filterFacilitiesOnRadioSelect(facilityData);
        getFacilitiesByState(facilityData);
        // relies on `_visnSelect.js` utility file to be loaded prior to this file
        if (selectedVisn !== "false" && selectedVisn !== "") {
            selectVisn(originData, selectedVisn)
        }
        // relies on `_officeSelect.js` utility file to be loaded prior to this file
        disableAndSelectDepartmentOptionValue();
        filterDepartmentTypeOptionsOnRadioSelect(originData);
        getStatesByDepartment(originData);
        getOfficesByState(originData);
        if (selectedOffice !== "false" && selectedDepartment !== "false" && selectedOffice !== "" && selectedDepartment !== "") {
            selectOffice(originData, selectedDepartment, selectedOffice)
        }
        uncheckAllPartnerBoxes();
        uncheckNoneOptionIfAnotherOptionIsChecked();
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

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

function showOtherAwardFields() {
    if (document.getElementById('practice_award_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    } else {
        document.getElementById('other_awards_container').style.display = 'none';
    }
}

function showOtherCategoryFields() {
    if (document.getElementById('category_other').checked) {
        document.getElementById('other_categories_container').style.display = 'block';
    } else {
        document.getElementById('other_categories_container').style.display = 'none';
    }
}
