// Generic functions for using nested_forms:
// styling li items
// placing the "Add another" in the correct element
// add the "separator" between elements
// See "practice_editor_introduction.html.erb"
// and "practice_editor_introduction.es6"
// for examples on how to use these functions
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

    // I'm not sure why some are broken (I'm looking at you, Practice Awards...),
    // but let's make sure the dataId and the name and id attributes match.
    // Let's only do practice awards for now (liElSelector = .practice-editor-other-awards-li).
    // If others need this code, let's look to fixing the Facility Select section and open to the public.
    if (liElSelector === '.practice-editor-other-awards-li') {
        let badId = null;
        $.each($newEl.find('input:not([type="hidden"]), select, textarea'),
            function (i, formElement) {
                const $formElement = $(formElement);
                const id = $formElement.attr('id');
                const endStringMatch = id.indexOf('_practice_awards_name') > 0 ? '_practice_awards_name' : '_name';
                badId = id.substring(id.lastIndexOf('_attributes_') + 12, id.lastIndexOf(endStringMatch));
                if (+badId !== +dataId) {
                    const newId = id.replace(badId, dataId);

                    $formElement.attr('id', newId);
                    $formElement.attr('name', $formElement.attr('name').replace(badId, dataId));

                    const label = $formElement.siblings('label');
                    label.attr('for', newId);
                }
            });
        // fix the trash can
        const $_destroyEl = $newEl.find('.trash-container input');
        $_destroyEl.attr('name', `practice[practice_awards_attributes][${dataId}][_destroy]`);
        $_destroyEl.attr('id', `practice_practice_awards_attributes_${dataId}__destroy`);

        //fix the hidden id input
        const $hiddenIdEl = $(`#practice_practice_awards_attributes_${badId}_id`);
        if (+dataId === +$hiddenIdEl.val()) {
            $hiddenIdEl.detach().prependTo($newEl);
            $hiddenIdEl.attr('id', `practice_practice_awards_attributes_${dataId}_id`);
            $hiddenIdEl.attr('name', `practice[practice_awards_attributes][${dataId}][id]`);
        }
    }

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