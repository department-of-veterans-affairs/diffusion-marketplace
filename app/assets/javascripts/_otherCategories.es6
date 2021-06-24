let $document = $(document);

function attachShowOtherClinicalCategoryFields() {
    observePracticeEditorLiArrival(
        $document,
        '.clinical-li',
        '.practice-editor-clinical-categories-ul',
        '8'
    );
    $document.on('change', '#clinical_category_other', function() {
        if ($('#clinical').children().length === 0) {
            $('#link_to_add_link_slug_clinical').click();
        }
        showOtherClinicalCategoryFields();
    });

    attachTrashListener(
        $document,
        '#clinical_other_categories_container',
        '.clinical-li'
    );
    showOtherClinicalCategoryFields();
}

function attachShowOtherOperationalCategoryFields() {
    observePracticeEditorLiArrival(
        $document,
        '.operational-li',
        '.practice-editor-operational-categories-ul',
        '8'
    );
    $document.on('change', '#operational_category_other', function() {
        if ($('#operational').children().length === 0) {
            $('#link_to_add_link_slug_operational').click();
        }
        showOtherOperationalCategoryFields();
    });
    attachTrashListener(
        $document,
        '#operational_other_categories_container',
        '.operational-li'
    );
    showOtherOperationalCategoryFields();
}

function attachShowOtherStrategicCategoryFields() {
    observePracticeEditorLiArrival(
        $document,
        '.strategic-li',
        '.practice-editor-strategic-categories-ul',
        '8'
    );
    $document.on('change', '#strategic_category_other', function() {
        if ($('#strategic').children().length === 0) {
            $('#link_to_add_link_slug_strategic').click();
        }
        showOtherStrategicCategoryFields();
    });

    attachTrashListener(
        $document,
        '#strategic_other_categories_container',
        '.strategic-li'
    );
    showOtherStrategicCategoryFields();
}

function showOtherClinicalCategoryFields() {
    if ($('#clinical_category_other').prop('checked')) {
        $('#clinical_other_categories_container').removeClass('display-none');
    } else {
        $('#clinical_other_categories_container').addClass('display-none');
    }
}



function showOtherOperationalCategoryFields() {
    if ($('#operational_category_other').prop('checked')) {
        $('#operational_other_categories_container').removeClass('display-none');
    } else {
        $('#operational_other_categories_container').addClass('display-none');
    }
}

function showOtherStrategicCategoryFields() {
    if ($('#strategic_category_other').prop('checked')) {
        $('#strategic_other_categories_container').removeClass('display-none');
    } else {
        $('#strategic_other_categories_container').addClass('display-none');
    }
}

function executeOtherCategoryFunctions() {
    attachShowOtherClinicalCategoryFields();
    attachShowOtherOperationalCategoryFields();
    attachShowOtherStrategicCategoryFields();
}
$(executeOtherCategoryFunctions);