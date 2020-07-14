(($) => {
    const $document = $(document);

    function attachFacilitySelectListener() {
        observePracticeEditorOriginFacilityLiArrival($document);

        $document.on('click', '.origin-trash', function() {
            const $liEls = $('#facility_select_form ul li.practice-editor-origin-facility-li');

            const $originFacilityElements =
                $liEls
                    .not(function(i, el) {
                        return el.style.display === 'none';
                    });

            const $firstOriginFacilityEl = $($originFacilityElements.first());

            if ($originFacilityElements.length === 0) {
                $('.add-practice-originating-facilities-link')
                    .detach()
                    .appendTo('#facility_select_form');
            } else if ($originFacilityElements.length === 1) {
                $firstOriginFacilityEl.find('.origin-trash').hide();
                removeSeparator($firstOriginFacilityEl);
            } else {
                $firstOriginFacilityEl.find('.origin-trash').show();
                const $lastOriginFacilityEl = $($originFacilityElements.last());
                removeSeparator($lastOriginFacilityEl);
            }
        });
    }

    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        showOtherAwardFields();
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

function removeSeparator($originFacilityEl) {
    const $separator = $originFacilityEl.find('.add-another-separator');
    if ($separator.length) {
        $separator.remove();
    }
    $('.add-practice-originating-facilities-link')
        .detach()
        .appendTo($originFacilityEl.find('.trash-container'));
}

function observePracticeEditorOriginFacilityLiArrival($document) {
    $document.arrive('.practice-editor-origin-facility-li', (newElem) => {
        const $newEl = $(newElem);
        const dataId = $newEl.data('id');
        styleOriginFacility($newEl, dataId);
        getFacilitiesByState(facilityData,
            `practice_practice_origin_facilities_attributes_${dataId}_facility_id`,
            `editor_state_select_${dataId}`
        );
        $document.unbindArrive('.practice-editor-origin-facility-li', newElem);
    });
}

function styleOriginFacility($newEl, dataId) {
    $newEl
        .detach()
        .appendTo('.practice-editor-origin-ul');

    $newEl.css('list-style', 'none');

    const $originFacilityElements =
        $('.practice-editor-origin-facility-li')
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
        removeSeparator($lastOriginFacilityEl);
    } else {
        $firstOriginFacilityEl.find('.origin-trash').hide();
        $('.add-practice-originating-facilities-link')
            .detach()
            .prependTo($($newEl.find('.trash-container')));
    }
}

function showOtherAwardFields() {
    if (document.getElementById('awards_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    } else {
        document.getElementById('other_awards_container').style.display = 'none';
    }
}
