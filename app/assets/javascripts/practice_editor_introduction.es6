(($) => {
    const $document = $(document);

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
            '12'
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
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

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
