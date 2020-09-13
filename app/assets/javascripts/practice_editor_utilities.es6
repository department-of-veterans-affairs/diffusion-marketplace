// Generic functions for using nested_forms:
// styling li items
// placing the "Add another" in the correct element
// add the "separator" between elements
// See "practice_editor_introduction.html.erb"
// and "practice_editor_introduction.es6"
// for examples on how to use these functions
function attachTrashListener($document,
                             formSelector = '#facility_select_form',
                             liElSelector = '.practice-editor-origin-facility-li') {
    $document.on('click', `${formSelector} .dm-origin-trash`, function() {
        const $liEls = $(`${formSelector} ul li${liElSelector}`);

        const $originFacilityElements =
            $liEls
                .not(function(i, el) {
                    return el.style.display === 'none';
                });

        const $firstOriginFacilityEl = $($originFacilityElements.first());

        if ($originFacilityElements.length === 1) {
            $firstOriginFacilityEl.find('.dm-origin-trash').css('visibility','hidden');
            removeSeparator($firstOriginFacilityEl);
        } else {
            $firstOriginFacilityEl.find('.dm-origin-trash').css('visibility','visible');
            const $lastOriginFacilityEl = $($originFacilityElements.last());
            removeSeparator($lastOriginFacilityEl);
        }
    });
}

function removeSeparator($originFacilityEl) {
    const $separator = $originFacilityEl.find('.add-another-separator');
    if ($separator.length) {
        $separator.remove();
    }
}

function observePracticeEditorLiArrival($document,
                                        liElSelector = '.practice-editor-origin-facility-li',
                                        ulSelector = '.practice-editor-origin-ul',
                                        separatorCols = '8') {
    $document.arrive(liElSelector, (newElem) => {
        const $newEl = $(newElem);
        const dataId = $newEl.data('id');
        styleOriginFacility(
            $newEl,
            dataId,
            liElSelector,
            ulSelector,
            separatorCols
        );
        if (liElSelector === '.practice-editor-origin-facility-li') {
            getFacilitiesByState(
                facilityData,
                `practice_practice_origin_facilities_attributes_${dataId}_facility_id`,
                `editor_state_select_${dataId}`
            );
        }
        $document.unbindArrive(liElSelector, newElem);
    });
}

function styleOriginFacility($newEl,
                             dataId,
                             liElSelector = '.practice-editor-origin-facility-li',
                             ulSelector = '.practice-editor-origin-ul',
                             separatorCols = '8') {
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
        $firstOriginFacilityEl.find('.dm-origin-trash').css('visibility','visible');
        $.each($originFacilityElements, (i, el) => {
            const $separator = $(el).find('.add-another-separator');
            if ($(el).data('id') !== dataId) {
                if ($separator.length === 0) {
                    const addAnotherSeparatorHtml = `<div class="grid-col-${separatorCols} border-y-1px border-gray-5 add-another-separator margin-y-2"></div>`;
                    $(el).append(addAnotherSeparatorHtml);
                }
            }
        });

        const $lastOriginFacilityEl = $($originFacilityElements.last());
        removeSeparator($lastOriginFacilityEl);
    } else {
        console.log('hello')
        $firstOriginFacilityEl.find('.dm-origin-trash').css('visibility','hidden');
    }
}

function createGUID() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}