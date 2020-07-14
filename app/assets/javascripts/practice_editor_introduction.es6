(($) => {
    const $document = $(document);


    function attachFacilitySelectListener() {
        $document.arrive('.practice-editor-origin-facility-li', (newElem) => {
            let $newEl = $(newElem);
            let dataId = $newEl.data('id');
            styleOriginFacility($newEl, dataId);
            getFacilitiesByState(facilityData,
                `practice_practice_origin_facilities_attributes_${dataId}_facility_id`,
                `editor_state_select_${dataId}`
            );
            $document.unbindArrive('.practice-editor-origin-facility-li', newElem);
        });

        $document.on('click', '.origin-trash', function() {
            const $originFacilityElements =
                $('#facility_select_form ul li.practice-editor-origin-facility-li')
                    .not(function(i, el) {
                        return el.style.display === 'none';
                    });
            if ($originFacilityElements.length === 0) {
                $('.add-practice-originating-facilities-link').detach().appendTo('#facility_select_form');
            }
        });
    }

    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        showOtherAwardFields();
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

function styleOriginFacility($newEl, dataId) {
    $newEl.detach().appendTo('.practice-editor-origin-ul')
    $newEl.css('list-style', 'none');
    const $originFacilityElements = $('.practice-editor-origin-facility-li');
    if ($originFacilityElements.length > 1) {
        $.each($originFacilityElements, (i, el) => {
            const $separator = $(el).find('.add-another-separator');
            if ($(el).data('id') !== dataId) {
                $(el).addClass('margin-bottom-4');

                if ($separator.length === 0) {
                    $(el).append('<div class="grid-col-8 border-y-1px border-gray-5 add-another-separator"></div>');
                }
            }
            else {
                if ($separator.length === 0) {
                    $separator.remove();
                }
                $('.add-practice-originating-facilities-link').detach().prependTo($($newEl.find('.trash-container')));
            }
        });
    }
    else {
        console.log('last element i hope')
        $('.add-practice-originating-facilities-link').detach().prependTo($($newEl.find('.trash-container')));
    }
}

function showOtherAwardFields() {
    if (document.getElementById('awards_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    } else {
        document.getElementById('other_awards_container').style.display = 'none';
    }
}
