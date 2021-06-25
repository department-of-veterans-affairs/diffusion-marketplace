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

function attachAllClinicalListener(){
    $document.on('change', '#clinical_category_allclinical', function() {
        let clinicalChkBoxes = $('[id^="clinical_category_"]');
        debugger
        for(let i = 0; i < clinicalChkBoxes.length; i++){
            if(!clinicalChkBoxes[i].id.includes("_other")){
                clinicalChkBoxes[i].checked = this.checked;
            }
        }
    });
}

function attachAllOperationalListener(){
    $document.on('change', '#operational_category_alloperational', function() {
        let operationalChkBoxes = $('[id^="operational_category_"]');
        debugger
        for(let i = 0; i < operationalChkBoxes.length; i++){
            if(!operationalChkBoxes[i].id.includes("_other")){
                operationalChkBoxes[i].checked = this.checked;
            }
        }
    });
}

function attachAllStrategicListener(){
    $document.on('change', '#strategic_category_allstrategic', function() {
        let strategicChkBoxes = $('[id^="strategic_category_"]');
        debugger
        for(let i = 0; i < strategicChkBoxes.length; i++){
            if(!strategicChkBoxes[i].id.includes("_other")){
                strategicChkBoxes[i].checked = this.checked;
            }
        }
    });
}

function executeOtherCategoryFunctions() {
    attachShowOtherClinicalCategoryFields();
    attachShowOtherOperationalCategoryFields();
    attachShowOtherStrategicCategoryFields();
    attachAllClinicalListener();
    attachAllOperationalListener();
    attachAllStrategicListener();
}
$(executeOtherCategoryFunctions);