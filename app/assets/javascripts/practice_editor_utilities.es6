// Generic functions for using nested_forms:
// styling li items
// placing the "Add another" in the correct element
// add the "separator" between elements
// See "practice_editor_introduction.html.erb"
// and "practice_editor_introduction.es6"
// for examples on how to use these functions
function attachTrashListener($document,
                             formSelector = '#facility_select_form',
                             liElSelector = '.practice-editor-origin-facility-li',
                             link_to_add_link_id = '',
                             link_to_add_button_id = '') {
    $document.on('click', `${formSelector} .dm-origin-trash`, function(e) {
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
        toggleLinkToAddButtonVsLink(link_to_add_link_id, link_to_add_button_id, $originFacilityElements.length);

        if(liElSelector === '.dm-practice-editor-department-li') {
            $(e.target).closest('.trash-container').find('input').val('true')
        }
    });
}

function toggleLinkToAddButtonVsLink(link_to_add_link_id, link_to_add_button_id, elementLength){
    if(link_to_add_link_id && link_to_add_button_id){
        if (elementLength > 0) {
            $(`#${link_to_add_link_id}`).show();
            $(`#${link_to_add_button_id}`).hide();
        }
        else{
            $(`#${link_to_add_link_id}`).hide();
            $(`#${link_to_add_button_id}`).show();
        }
    }
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
                                        separatorCols = '8',
                                        link_to_add_link_id = '',
                                        link_to_add_button_id = '') {
    $document.arrive(liElSelector, (newElem) => {
        const $newEl = $(newElem);
        const dataId = $newEl.data('id');
        console.log($newEl);
        styleOriginFacility(
            $newEl,
            dataId,
            liElSelector,
            ulSelector,
            separatorCols,
            link_to_add_link_id,
            link_to_add_button_id
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
                             separatorCols = '8',
                             link_to_add_link_id = '',
                             link_to_add_button_id = '') {
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
        $firstOriginFacilityEl.find('.dm-origin-trash').css('visibility','hidden');
    }

    toggleLinkToAddButtonVsLink(link_to_add_link_id, link_to_add_button_id, $originFacilityElements.length);
}

function createGUID() {
    return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

function displayAttachmentForm(sArea, sType) {
    // sArea: core, optional, support
    // type: file, link
    debugger
    // document.getElementById("display_core_attachment_form").style.display = 'none';
    //
    // document.getElementById("display_core_attachment_form").style.display = 'block';
    // if(sType == 'file'){
    //     document.getElementById("core_attachment_link_form").style.display = 'none';
    // }
    // else if(sType == 'link'){
    //     document.getElementById("core_attachment_file_form").style.display = 'none';
    // }
    debugger
    $(`#display_${sArea}_form div[id*="_form"]`).show();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
}