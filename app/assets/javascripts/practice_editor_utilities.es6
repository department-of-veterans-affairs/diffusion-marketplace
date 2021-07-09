// Generic functions for using nested_forms:
// styling li items
// placing the "Add another" in the correct element
// add the "separator" between elements
// See "practice_editor_introduction.html.erb"
// and "practice_editor_introduction.es6"
// for examples on how to use these functions

function showHideTrashElements(liSelector, attr1, value1, attr2, value2) {
    const corePeopleResourceLi = 'core-people-resource-li';
    const originTrash = '.dm-origin-trash';

    // Removed required attribute from hidden input(s) to avoid 'not focusable' js validation error
    $(`.${corePeopleResourceLi}:not(:visible)`).find('input.practice-input').each(function() {
        $(this).removeAttr('required');
        $(this).removeClass('dm-required-field');
    });

    if (liSelector.hasClass(corePeopleResourceLi)) {
        liSelector.find('.trash-container').css(attr1, value1);
        liSelector.find(originTrash).css(attr2, value2);
    } else {
        liSelector.find(originTrash).css(attr2, value2);
    }
}

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
            // If there is a core people resource li, show the trash container in order to maintain 'Add another' link spacing
            showHideTrashElements($firstOriginFacilityEl, 'display', 'block', 'visibility', 'hidden');
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
                                        link_to_add_button_id = '',
                                        is_published = false) {
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

        if (liElSelector === '.core-people-resource-li') {
            if(is_published) {
                let practiceInput = $(`${liElSelector}:visible`).find('.practice-input')
                practiceInput.attr('required', 'true');
                practiceInput.addClass('dm-required-field');
            }
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
        // If there is a core people resource li, hide the trash container in order prevent a large space in-between separator and bottom of first input
        showHideTrashElements($firstOriginFacilityEl, 'display', 'none', 'visibility', 'visible');

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

        // get file name before form is cleared
        let fileName
        if (sType === 'file') {
            fileName = $(e.target).parent().parent().find('.usa-file-input__input')[0].files[0].name
        }

        const nGuid = createGUID();
        const formToClear = $(`#${formSelector}`);
        const link_form = formToClear.clone(true);
        link_form.attr('id', `${formSelector}_${nGuid}`);
        link_form.attr('class', `margin-bottom-5 grid-col-11`);
        link_form.find('.dm-cancel-add-button-row').remove();

        let area = sArea;
        let resource_type = '';
        if (sArea === 'optional_attachment' || sArea === 'core_attachment' || sArea === 'support_attachment') {
            if (sType === 'file' || sType === 'link') {
                area = 'resources';
                resource_type = '_' + sArea.substr(0, sArea.indexOf('_attachment'));
            }
        }

        const deleteEntryHtml = `
            <div class="grid-col-12 margin-top-2" align="right">
               <input type="hidden" value="false" name="practice[practice_${area}_attributes][${nGuid}_${sType}${resource_type}][_destroy]"/>
               <button type="button" data-area="${sArea}" data-type="${sType}" class="usa-button--unstyled dm-btn-warning line-height-26 remove_nested_fields">
                    Delete entry
               </button>
            </div>
        `;

        link_form.append(deleteEntryHtml);
        $.each(link_form.find('input'), function (i, ele) {
            ele.required = true;
            $(ele).addClass('dm-required-field');
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
                replaceFileInput(sArea, ele)
            } else if (ele.type === 'file' && sType === 'image') {
                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                    <input id="practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_image" class="usa-hint usa-file-input dm-cropper-upload-image" type="file" name="practice[practice_${sArea}_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".jpg,.jpeg,.png" />
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

        // hide file upload so user can't upload a new file once added it is added to save queue
        if (sType === 'file') {
            let $uploadInputLabel = $(`#${container}`).find('.dm-file-upload-label')
            $(`<div>File: ${fileName}</div>`).insertAfter($uploadInputLabel)
            $uploadInputLabel.remove();
            $(`#${container}`).find('.usa-file-input').addClass('display-none');
        }
    });
}

function replaceFileInput(sArea, ele) {
    let area = sArea
    let resource_type = ''

    if (sArea === 'optional_attachment' || sArea === 'core_attachment' || sArea === 'support_attachment') {
        area = 'resources'
        resource_type = sArea.substr(0, sArea.indexOf('_attachment'));
    }

    $(ele)
        .closest('.usa-file-input')
        .replaceWith(`
            <input id="practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_file_${resource_type ? resource_type + '_' : ''}attachment" class="usa-hint usa-file-input" type="file" name="practice[practice_${area}_attributes][RANDOM_NUMBER_OR_SOMETHING_file${resource_type ? '_' + resource_type : ''}][attachment]" accept=".pdf,.docx,.xlxs,.jpg,.jpeg,.png" />
        `);
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
    if (sType === "file") {
        let resource_type = ''
        if (sArea.includes('_attachment')) {
            resource_type = sArea.substr(0, sArea.indexOf('_attachment')) + '_';
        }

        const sAttachment = $(`#practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_file_${resource_type}attachment`)[0]
        const sName = document.getElementById(`practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_file_${resource_type}name`);
        const sDesc = document.getElementById(`practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_file_${resource_type}description`);

        if (sAttachment.value === "") {
            displayAttachmentErrorStyles(sAttachment, 'div.grid-col-12');
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideAttachmentErrorStyles(sAttachment, 'div.grid-col-12');
        }

        if (sName.value === "") {
            displayTextInputErrorStyles(sName, `.${sArea}-input-container`);
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
        }

        if (sDesc.value === "") {
            displayTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
        }

    } else if (sType === 'video') {
        const sLink = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_video_link_url');
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_video_name');

        if (sLink.value === "" || !sLink.value.includes('https://www.youtube.com')) {
            displayTextInputErrorStyles(sLink, `.${sArea}-input-container`);
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sLink, `.${sArea}-input-container`);
        }

        if (sName.value === "") {
            displayTextInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
        }

    } else if (sType === 'link') {
        let resource_type = ''
        if (sArea.includes('_attachment')) {
            resource_type = '_' + sArea.substr(0, sArea.indexOf('_attachment'));
        }

        const sLink = document.getElementById('practice_' + sArea + `_attributes_RANDOM_NUMBER_OR_SOMETHING_link${resource_type}_link_url`);
        const sName = document.getElementById(`practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_link${resource_type}_name`);
        const sDesc = document.getElementById(`practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_link${resource_type}_description`);

        if (sLink.value === "") {
            displayTextInputErrorStyles(sLink, `.${sArea}-input-container`);
            // Hide name error message
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
            // Hide description error message
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sLink, `.${sArea}-input-container`);
        }

        if (sName.value === "") {
            displayTextInputErrorStyles(sName, `.${sArea}-input-container`);
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
        }

        if (sDesc.value === "") {
            displayTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sDesc, `.${sArea}-input-container`);
        }

    } else if (sType === 'image') {
        const sAttachment = document.getElementById(`practice_${sArea}_attributes_RANDOM_NUMBER_OR_SOMETHING_image`);
        const sName = document.getElementById('practice_' + sArea + '_attributes_RANDOM_NUMBER_OR_SOMETHING_image_name');

        if (sAttachment.value === "") {
            displayAttachmentErrorStyles(sAttachment, 'div.margin-y-1');
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideAttachmentErrorStyles(sAttachment, 'div.margin-y-1');
        }

        if (sName.value === "") {
            displayTextInputErrorStyles(sName, `.${sArea}-input-container`);
            return false;
        } else {
            hideTextInputErrorStyles(sName, `.${sArea}-input-container`);
        }
    }
}

function _displayInputErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).closest(inputContainer).addClass('input-error');
    $(inputTitle).parent().find('label').addClass('usa-label--error');
    $(inputTitle).closest(inputContainer).find('.overview_error_msg').css({ display: 'block' })
}

function displayTextInputErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).addClass('text-input-error');
    $(inputTitle).parent().find('label').addClass('usa-label--error');
    _displayInputErrorStyles(inputTitle, inputContainer)
}

function displayAttachmentErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).closest(inputContainer).find('.dm-usa-file-upload-error-text').addClass('display-none');
    $(inputTitle).parent().addClass('attachment-input-target-error');
    $(inputTitle).closest(inputContainer).find('label').addClass('usa-label--error margin-bottom-0');
    _displayInputErrorStyles(inputTitle, inputContainer)
}

function _hideInputErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).closest(inputContainer).removeClass('input-error');
    $(inputTitle).closest(inputContainer).find('.overview_error_msg').css({ display: 'none' });
    $(inputTitle).parent().find('label').removeClass('usa-label--error');
}

function hideTextInputErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).removeClass('text-input-error');
    $(inputTitle).parent().find('label').removeClass('usa-label--error');
    _hideInputErrorStyles(inputTitle, inputContainer)
}

function hideAttachmentErrorStyles(inputTitle, inputContainer) {
    $(inputTitle).closest(inputContainer).find('.dm-usa-file-upload-error-text').addClass('display-none');
    $(inputTitle).parent().removeClass('attachment-input-target-error');
    $(inputTitle).closest(inputContainer).find('label').removeClass('usa-label--error margin-bottom-0');
    _hideInputErrorStyles(inputTitle, inputContainer)
}

function displayAttachmentForm(sArea, sType) {
    $(`#display_${sArea}_form div[id*="_form"]`).hide();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
}
