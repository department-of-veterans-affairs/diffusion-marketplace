let $document = $(document);

// omit the following functions on the search page:
if (window.location.pathname !== '/search') {
    function showOtherCategoryFields(otherUlSelector, linkToAddSelector, otherCheckboxSelector, otherContainerSelector) {
        if ($(otherUlSelector).children().length === 0) {
            $(linkToAddSelector).click();
        } else if ($(otherUlSelector).children().length > 0) {
            $(otherContainerSelector).removeClass('display-none');
        }

        $document.on('change', otherCheckboxSelector, function () {
            if ($(otherCheckboxSelector).prop('checked')) {
                $(otherContainerSelector).removeClass('display-none');
            } else {
                $(otherContainerSelector).addClass('display-none');
            }
        });
    }

    function attachShowOtherClinicalCategoryFields() {
        observePracticeEditorLiArrival(
            $document,
            '.clinical-li',
            '.practice-editor-clinical-categories-ul',
            '12'
        );
        attachTrashListener(
            $document,
            '#clinical_other_categories_container',
            '.clinical-li'
        );
        showOtherCategoryFields('#clinical', '#link_to_add_link_slug_clinical', '.clinical-other-checkbox', '#clinical_other_categories_container');
    }

    function attachShowOtherOperationalCategoryFields() {
        observePracticeEditorLiArrival(
            $document,
            '.operational-li',
            '.practice-editor-operational-categories-ul',
            '12'
        );
        attachTrashListener(
            $document,
            '#operational_other_categories_container',
            '.operational-li'
        );
        showOtherCategoryFields('#operational', '#link_to_add_link_slug_operational', '.operational-other-checkbox', '#operational_other_categories_container');
    }

    function attachShowOtherStrategicCategoryFields() {
        observePracticeEditorLiArrival(
            $document,
            '.strategic-li',
            '.practice-editor-strategic-categories-ul',
            '12'
        );
        attachTrashListener(
            $document,
            '#strategic_other_categories_container',
            '.strategic-li'
        );
        showOtherCategoryFields('#strategic', '#link_to_add_link_slug_strategic', '.strategic-other-checkbox', '#strategic_other_categories_container');
    }
}

function addAllCheckBoxListener(allCheckboxSelector, standardCheckboxSelector) {
    let allClinicalCheckbox = allCheckboxSelector;
    let clinicalCheckbox = standardCheckboxSelector;

    $document.on('change', allClinicalCheckbox, function() {
        if ($(this).prop('checked')) {
            $(clinicalCheckbox).prop('checked', true);
        }
    });

    $document.on('change', clinicalCheckbox, function() {
        let catCheckboxesCountMinusAllAndOther = $(clinicalCheckbox).length;
        if ($(`input${clinicalCheckbox}:checked`).length === catCheckboxesCountMinusAllAndOther) {
            $(allClinicalCheckbox).prop('checked', true);
        } else {
            $(allClinicalCheckbox).prop('checked', false);
        }
    });
}

function executeOtherCategoryFunctions() {
    // omit the following functions on the search page:
    if (window.location.pathname !== '/search') {
        attachShowOtherClinicalCategoryFields();
        attachShowOtherOperationalCategoryFields();
        attachShowOtherStrategicCategoryFields();
    }
    addAllCheckBoxListener('.all-clinical-checkbox', '.clinical-checkbox');
    addAllCheckBoxListener('.all-operational-checkbox', '.operational-checkbox');
    addAllCheckBoxListener('.all-strategic-checkbox', '.strategic-checkbox');
}

$(executeOtherCategoryFunctions);