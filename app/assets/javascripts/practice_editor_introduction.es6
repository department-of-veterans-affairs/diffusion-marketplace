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

function attachTrashListener($document, formSelector = '#facility_select_form', liElSelector = '.practice-editor-origin-facility-li', addAnotherLinkSelector = '.add-practice-originating-facilities-link') {
    $document.on('click', `${formSelector} .origin-trash`, function() {
        const $liEls = $(`${formSelector} ul li${liElSelector}`);

        const $originFacilityElements =
            $liEls
                .not(function(i, el) {
                    return el.style.display === 'none';
                });

        const $firstOriginFacilityEl = $($originFacilityElements.first());

        if ($originFacilityElements.length === 0) {
            $(addAnotherLinkSelector)
                .detach()
                .appendTo(formSelector);
        } else if ($originFacilityElements.length === 1) {
            $firstOriginFacilityEl.find( '.origin-trash').hide();
            removeSeparator($firstOriginFacilityEl, addAnotherLinkSelector);
        } else {
            $firstOriginFacilityEl.find('.origin-trash').show();
            const $lastOriginFacilityEl = $($originFacilityElements.last());
            removeSeparator($lastOriginFacilityEl, addAnotherLinkSelector);
        }
    });
}

function removeSeparator($originFacilityEl, addAnotherLinkSelector = '.add-practice-originating-facilities-link') {
    const $separator = $originFacilityEl.find('.add-another-separator');
    if ($separator.length) {
        $separator.remove();
    }
    $(addAnotherLinkSelector)
        .detach()
        .appendTo($originFacilityEl.find('.trash-container'));
}

function observePracticeEditorLiArrival($document, liElSelector = '.practice-editor-origin-facility-li', ulSelector = '.practice-editor-origin-ul', addAnotherLinkSelector = '.add-practice-originating-facilities-link') {
    $document.arrive(liElSelector, (newElem) => {
        const $newEl = $(newElem);
        const dataId = $newEl.data('id');
        styleOriginFacility($newEl, dataId, liElSelector, ulSelector, addAnotherLinkSelector);
        if (liElSelector === '.practice-editor-origin-facility-li') {
            getFacilitiesByState(facilityData,
                `practice_practice_origin_facilities_attributes_${dataId}_facility_id`,
                `editor_state_select_${dataId}`
            );
        }
        $document.unbindArrive(liElSelector, newElem);
    });
}

function styleOriginFacility($newEl, dataId, liElSelector = '.practice-editor-origin-facility-li', ulSelector = '.practice-editor-origin-ul', addAnotherLinkSelector = '.add-practice-originating-facilities-link') {
    $newEl
        .detach()
        .appendTo(ulSelector);

    $newEl.css('list-style', 'none');

    const $originFacilityElements =
        $(liElSelector)
            .not(function(i, el) {
                return el.style.display === 'none';
            });

    const $firstOriginFacilityEl = $($originFacilityElements.first());

    if ($originFacilityElements.length > 1) {
        $firstOriginFacilityEl.find('.origin-trash').show();
        $.each($originFacilityElements, (i, el) => {
            const $separator = $(el).find('.add-another-separator');
            if ($(el).data('id') !== dataId) {
                if ($separator.length === 0) {
                    const addAnotherSeparatorHtml = '<div class="grid-col-8 border-y-1px border-gray-5 add-another-separator margin-y-2"></div>';
                    $(el).append(addAnotherSeparatorHtml);
                }
            }
        });

        const $lastOriginFacilityEl = $($originFacilityElements.last());
        removeSeparator($lastOriginFacilityEl, addAnotherLinkSelector);
    } else {
        $firstOriginFacilityEl.find('.origin-trash').hide();
        $(addAnotherLinkSelector)
            .detach()
            .prependTo($($newEl.find('.trash-container')));
    }
}

function showOtherAwardFields() {
    if (document.getElementById('practice_award_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    } else {
        document.getElementById('other_awards_container').style.display = 'none';
    }
}
