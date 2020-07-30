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
            '.practice-editor-awards-ul',
            '.add-practice-award-other-link'
        );
        $document.on('change', '#practice_award_other', function() {
            showOtherAwardFields();
        });

        attachTrashListener(
            $document,
            '#other_awards_container',
            '.practice-editor-other-awards-li',
            '.add-practice-award-other-link'
        );
    }

    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        attachShowOtherAwardFields();
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
