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

function attachAddResourceListener(formSelector, container, sArea, sType) {
    $(document).on('click', `#${formSelector} .add-resource`, function (e) {
        e.preventDefault();
        if (validateFormFields(formSelector, sArea, sType, event.target) === false) {
            return false;
        }
        const nGuid = createGUID();
        const formToClear = $(`#${formSelector}`);
        const link_form = formToClear.clone(true);
        link_form.attr('id', `${formSelector}_${nGuid}`);
        link_form.attr('class', `margin-bottom-5`);
        link_form.find('.dm-cancel-add-button-row').remove();

        const deleteEntryHtml = `
            <div class="grid-col-12 margin-top-2" align="right">
               <input type="hidden" value="false" name="practice[practice_${sArea}_attributes][${nGuid}_${sType}][_destroy]"/>
               <button type="button" data-area="${sArea}" data-type="${sType}" class="usa-button--unstyled dm-btn-warning line-height-26 remove_nested_fields">
                    Delete entry
               </button>
            </div>
        `;

        link_form.append(deleteEntryHtml);
        $.each(link_form.find('input'), function (i, ele) {
            ele.required = true;
            $(ele).attr('name', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
            $(ele).attr('id', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });
        $.each(link_form.find('label'), function (i, ele) {
            $(ele).attr('for', $(ele).attr('for').replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });

        if ($(`#${container}`).children().length === 0) {
            let title = `${sType}s`
            let titleHTML = `<h5 id="${sArea}_${sType}_section_text" class="text-bold font-sans-3xs margin-bottom-2 margin-top-0 text-ls-1 line-height-15px" >${title.toUpperCase()}:</h5>`
            $(`#${container}`).append(titleHTML)
        }
        link_form.appendTo(`#${container}`);
        document.getElementById(container).style.display = 'block';

        //clear form_inputs
        $.each(formToClear.find('input:not([type="hidden"])'), function (i, ele) {
            $(ele).val(null);
            if (ele.type === 'file' && sType === 'file') {
                let area = sArea
                if (sArea === 'optional_attachment' || 'core_attachment' || 'support_attachment') {
                    area = 'resources'
                }

                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                        <input id="practice_${area}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input" type="file" name="practice[practice_${area}_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".pdf,.docx,.xlxs,.jpg,.jpeg,.png" aria-describedby="practice_${area}-input-single_RANDOM_NUMBER_OR_SOMETHING-hint" />
                    `);
            } else if (ele.type === 'file' && sType === 'image') {
                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                    <input id="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input dm-cropper-upload-image" type="file" name="practice[practice_${sArea}_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".jpg,.jpeg,.png" />
                `);
            }
        });

        if (sType === 'image') {
            formToClear.find('.dm-cropper-images-container').empty();
            formToClear.find('.dm-cropper-edit-mode').addClass('display-none');
            formToClear.find('.dm-cropper-delete-image').addClass('display-none');
            formToClear.find('.dm-cropper-cancel-edit').addClass('display-none');
            formToClear.find('.dm-cropper-save-edit').addClass('display-none');
            $(`#${container}`).find('.dm-file-upload-label').remove();
            $(`#${container}`).find('.dm-cropper-delete-image').remove();
            $(`#${container}`).find('.usa-file-input').addClass('display-none');
            // remove event listeners
            $(`#${container}`).find('.dm-cropper-cancel-edit').off();
            $(`#${container}`).find('.dm-cropper-save-edit').off();
        }
        let elementId = sArea + '_' + sType + '_section_text';
        let newEle = document.getElementById(elementId);
        if(newEle != null) {
            newEle.style.display = 'block';
        }

    });
}

function attachDeleteResourceListener() {
    $(document).on('click', '.remove_nested_fields', function (e) {
        const destroyInput = $(e.target).siblings('input');
        destroyInput.val(true);
        let area = $(e.target).data('area');
        let type = $(e.target).data('type');
        $(e.target).parents('div[id*=' + area + '_' + type + '_form]').hide();

        let visibleChildDivs = $(e.target).closest(`#display_${area}_${type}`).find($('div.margin-bottom-5:visible'));
        // remove title of section if there are no items
        if (visibleChildDivs.length === 0) {
            let elementId = area + '_' + type + '_section_text';
            let newEle = document.getElementById(elementId);
            if(newEle != null) {
                newEle.style.display = 'none';
            }
        }
    });
}

function validateFormFields(formSelector, sArea, sType, target) {
    clearErrorDivs(sArea, sType, target);
    let errDiv = null;
    if (sType === "file") {
        const sAttachment = document.getElementsByClassName(sArea + '-file-attachment');
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_file_name');
        const sDesc = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_file_description');

        if (sAttachment[0].value === "") {
            errDiv = document.getElementById(sArea + '_file_err_message_attachment');
            errDiv.style.display = "block";
            $(sAttachment).closest('.usa-file-input').prepend($(errDiv));
            displayAttachmentErrorStyles(sAttachment, '.usa-file-input__target', 'div.grid-col-12');
            displayInputErrorStyles(sAttachment, '.grid-col-12');
            return false;
        } else {
            hideAttachmentErrorStyles(sAttachment, '.usa-file-input__target', 'div.grid-col-12');
            hideInputErrorStyles(sAttachment, '.grid-col-12');
        }

        if (sName.value === "") {
            errDiv = document.getElementById(sArea + '_file_err_message_name');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sName);
            displayInputErrorStyles(sName, `.${sArea}-input-container`);
            // Hide name error message
            hideTextInputErrorStyles(sDesc);
            hideInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
        }

        if (sDesc.value === "") {
            errDiv = document.getElementById(sArea + '_file_err_message_description');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sDesc);
            displayInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sDesc);
            hideInputErrorStyles(sDesc, `.${sArea}-input-container`);
        }
    } else if (sType === 'video') {
        const sLink = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_video_link_url');
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_video_name');

        if (sLink.value === "" || !sLink.value.includes('https://www.youtube.com')) {
            errDiv = document.getElementById(sArea + '_video_err_message_link_url');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sLink);
            displayInputErrorStyles(sLink, `.${sArea}-input-container`);
            // Hide name error message
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sLink);
            hideInputErrorStyles(sLink, `.${sArea}-input-container`);
        }

        if (sName.value === "") {
            errDiv = document.getElementById(sArea + '_video_err_message_name');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sName);
            displayInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
        }
    } else if (sType === 'link') {
        const sLink = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_link_link_url');
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_link_name');
        const sDesc = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_link_description');

        if (sLink.value === "") {
            errDiv = document.getElementById(sArea + '_link_err_message_link_url');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sLink);
            displayInputErrorStyles(sLink, `.${sArea}-input-container`);
            // Hide name error message
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
            // Hide description error message
            hideTextInputErrorStyles(sDesc);
            hideInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sLink);
            hideInputErrorStyles(sLink, `.${sArea}-input-container`);
        }

        if (sName.value === "") {
            errDiv = document.getElementById(sArea + '_link_err_message_name');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sName);
            displayInputErrorStyles(sName, `.${sArea}-input-container`);
            // Hide description error message
            hideTextInputErrorStyles(sDesc);
            hideInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
        }

        if (sDesc.value === "") {
            errDiv = document.getElementById(sArea + '_link_err_message_description');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sDesc);
            displayInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sDesc);
            hideInputErrorStyles(sDesc, `.${sArea}-input-container`);
        }
    } else if (sType === 'image') {
        const sAttachment = document.getElementsByClassName(sArea + '-image-attachment');
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_image_name');

        if (sAttachment[0].value === "") {
            errDiv = document.getElementById(sArea + '_image_err_message_attachment');
            errDiv.style.display = "block";
            $(sAttachment).closest('.usa-file-input').prepend($(errDiv));
            displayAttachmentErrorStyles(sAttachment, '.usa-file-input__target', 'div.margin-y-1');
            displayInputErrorStyles(sAttachment, '.margin-y-1');
            // Hide name error message
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideAttachmentErrorStyles(sAttachment, '.usa-file-input__target', 'div.margin-y-1');
            hideInputErrorStyles(sAttachment, '.margin-y-1');
        }

        if (sName.value === "") {
            errDiv = document.getElementById(sArea + '_image_err_message_name');
            errDiv.style.display = "block";
            displayTextInputErrorStyles(sName);
            displayInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName);
            hideInputErrorStyles(sName, `.${sArea}-input-container`);
        }
    }
}

function clearErrorDivs(sArea, sType, target) {
    // FILE
    if (sType === 'file') {
        document.getElementById(sArea + '_file_err_message_name').style.display = "none";
        document.getElementById(sArea + '_file_err_message_description').style.display = "none";
        document.getElementById(sArea + '_file_err_message_attachment').style.display = "none";
    }

    // VIDEO
    if (sType === 'video') {
        document.getElementById(sArea + '_video_err_message_name').style.display = "none";
        document.getElementById(sArea + '_video_err_message_link_url').style.display = "none";
    }

    // LINK
    if (sType === 'link') {
        document.getElementById(sArea + '_link_err_message_link_url').style.display = "none";
        document.getElementById(sArea + '_link_err_message_name').style.display = "none";
        document.getElementById(sArea + '_link_err_message_description').style.display = "none";
    }

    // IMAGE
    if (sType === 'image') {
        $(`#${sArea}_image_err_message_attachment`).css('display', 'none')
        $(`#${sArea}_image_err_message_name`).css('display', 'none')
    }
}

function displayInputErrorStyles(inputTitle, elem) {
    $(inputTitle).closest(elem).addClass('overview-input-error');
    $(inputTitle).parent().find('label').addClass('usa-label--error');
}

function hideInputErrorStyles(inputTitle, elem) {
    $(inputTitle).closest(elem).removeClass('overview-input-error');
    $(inputTitle).parent().find('label').removeClass('usa-label--error');
}

function displayTextInputErrorStyles(inputTitle) {
    $(inputTitle).addClass('overview-text-input-error');
    $(inputTitle).parent().find('label').addClass('usa-label--error');
}

function hideTextInputErrorStyles(inputTitle) {
    $(inputTitle).removeClass('overview-text-input-error');
    $(inputTitle).parent().find('label').removeClass('usa-label--error');
}

function displayAttachmentErrorStyles(inputTitle, elem1, elem2) {
    $(inputTitle).closest(elem1).addClass('overview-attachment-input-target-error');
    $(inputTitle).closest(elem2).find('label').addClass('usa-label--error margin-bottom-0');
}

function hideAttachmentErrorStyles(inputTitle, elem1, elem2) {
    $(inputTitle).closest(elem1).removeClass('overview-attachment-input-target-error');
    $(inputTitle).closest(elem2).find('label').removeClass('usa-label--error margin-bottom-0');
}

function displayAttachmentForm(sArea, sType) {
    $(`#display_${sArea}_form div[id*="_form"]`).hide();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
}

