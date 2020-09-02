(($) => {
    const $document = $(document);

    function initializeOverviewForm() {
        hideResources();
        attachDeleteResourceListener()
        //links
        attachAddResourceListener('problem_resources_link_form', 'display_problem_resources_link', 'problem_resources', 'link');
        attachAddResourceListener('solution_resources_link_form', 'display_solution_resources_link', 'solution_resources', 'link');
        attachAddResourceListener('results_resources_link_form', 'display_results_resources_link', 'results_resources', 'link');

        //Videos
        attachAddResourceListener('problem_resources_video_form', 'display_problem_resources_video', 'problem_resources', 'video');
        attachAddResourceListener('solution_resources_video_form', 'display_solution_resources_video', 'solution_resources', 'video');
        attachAddResourceListener('results_resources_video_form', 'display_results_resources_video', 'results_resources', 'video');
        attachAddResourceListener('multimedia_video_form', 'display_multimedia_video', 'multimedia', 'video');

        //Files
        attachAddResourceListener('problem_resources_file_form', 'display_problem_resources_file', 'problem_resources', 'file');
        attachAddResourceListener('solution_resources_file_form', 'display_solution_resources_file', 'solution_resources', 'file');
        attachAddResourceListener('results_resources_file_form', 'display_results_resources_file', 'results_resources', 'file');

        //Images
        attachAddResourceListener('problem_resources_image_form', 'display_problem_resources_image', 'problem_resources', 'image');
        attachAddResourceListener('solution_resources_image_form', 'display_solution_resources_image', 'solution_resources', 'image');
        attachAddResourceListener('results_resources_image_form', 'display_results_resources_image', 'results_resources', 'image');
        attachAddResourceListener('multimedia_image_form', 'display_multimedia_image', 'multimedia', 'image');

        //PROBLEM
        $(document).on('click', '#cancel_problem_resources_image', function (e) {
            e.preventDefault();
            document.getElementById('practice_problem_image').checked = false;
            document.getElementById('problem_resources_image_form').style.display = 'none';
        });


        $(document).on('click', '#cancel_problem_resources_link', function (e) {
            e.preventDefault();
            document.getElementById('practice_problem_link').checked = false;
            document.getElementById('problem_resources_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_problem_resources_video', function (e) {
            e.preventDefault();
            document.getElementById('practice_problem_video').checked = false;
            document.getElementById('problem_resources_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_problem_resources_file', function (e) {
            e.preventDefault();
            document.getElementById('practice_problem_file').checked = false;
            document.getElementById('problem_resources_file_form').style.display = 'none';
        });

        //SOLUTION
        $(document).on('click', '#cancel_solution_resources_image', function (e) {
            e.preventDefault();
            document.getElementById('practice_solution_image').checked = false;
            document.getElementById('solution_resources_image_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_solution_resources_link', function (e) {
            e.preventDefault();
            document.getElementById('practice_solution_link').checked = false;
            document.getElementById('solution_resources_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_solution_resources_video', function (e) {
            e.preventDefault();
            document.getElementById('practice_solution_video').checked = false;
            document.getElementById('solution_resources_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_solution_resources_file', function (e) {
            e.preventDefault();
            document.getElementById('practice_solution_file').checked = false;
            document.getElementById('solution_resources_file_form').style.display = 'none';
        });

        //RESULTS
        $(document).on('click', '#cancel_results_resources_image', function (e) {
            e.preventDefault();
            document.getElementById('practice_results_image').checked = false;
            document.getElementById('results_resources_image_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_results_resources_link', function (e) {
            e.preventDefault();
            document.getElementById('practice_results_link').checked = false;
            document.getElementById('results_resources_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_results_resources_video', function (e) {
            e.preventDefault();
            document.getElementById('practice_results_video').checked = false;
            document.getElementById('results_resources_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_results_resources_file', function (e) {
            e.preventDefault();
            document.getElementById('practice_results_file').checked = false;
            document.getElementById('results_resources_file_form').style.display = 'none';
        });

        //MULTIMEDIA
        $(document).on('click', '#cancel_multimedia_image', function (e) {
            e.preventDefault();
            document.getElementById("multimedia_image_form").style.display = 'none';
            document.getElementById('practice_multimedia_image').checked = false;
        });

        $(document).on('click', '#cancel_multimedia_video', function (e) {
            e.preventDefault();
            document.getElementById("multimedia_video_form").style.display = 'none';
            document.getElementById('practice_multimedia_video').checked = false;
        });
    }

    function showCurrentlySelectedOptions(currentSelectForm) {
        $(`#${currentSelectForm}`).show();
    }

    function hideOtherSelectForms(formsToHide) {
        formsToHide.forEach(f => {
            $(`#${f}`).hide();
        });
    }

    function attachDeleteResourceListener() {
        $document.on('click', '.remove_nested_fields', function (e) {
            const destroyInput = $(e.target).siblings('input');
            destroyInput.val(true);
            let area = $(e.target).data('area');
            let type = $(e.target).data('type');
            $(e.target).parents('div[id*=' + area + '_' + type + '_form]').hide();

            let visibleChildDivs = $(e.target).closest(`#display_${area}_${type}`).find('div:visible');
            // remove title of section if there are no items
            if (visibleChildDivs.length === 1) {
                visibleChildDivs[0].hide;
                let elementId = area + '_' + type + '_section_text';
                let newEle = document.getElementById(elementId);
                if(newEle != null) {
                    newEle.style.display = 'none';
                }
            }
        });
    }

    function hideResources() {
        const areas = ['problem_resources', 'solution_resources', 'results_resources', 'multimedia'];

        areas.forEach(a => {
            $(`#display_${a}_form div[id*="_form"]`).hide();
        });
    }


    $document.on('turbolinks:load', initializeOverviewForm);
})(window.jQuery);

function displayResourceForm(sArea, sType) {
    $(`#display_${sArea}_form div[id*="_form"]`).hide();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
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
        link_form.attr('class', `resource_container margin-bottom-5`);
        link_form.find('.dm-cancel-add-button-row').remove();

        const deleteEntryHtml = `
            <div class="grid-col-12 margin-top-2">
               <input type="hidden" value="false" name="practice[practice_${sArea}_attributes][${nGuid}_${sType}][_destroy]"/>
               <button type="button" data-area="${sArea}" data-type="${sType}" class="usa-button--unstyled dm-btn-warning remove_nested_fields">
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
            let titleHTML = `<div id="${sArea}_${sType}_section_text" class="text-bold margin-bottom-2" >${title.toUpperCase()}:</div>`
            $(`#${container}`).append(titleHTML)
        }
        link_form.appendTo(`#${container}`);
        document.getElementById(container).style.display = 'block';

        //clear form_inputs
        $.each(formToClear.find('input:not([type="hidden"])'), function (i, ele) {
            $(ele).val(null);
            if (ele.type === 'file' && sType === 'file') {
                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                        <input id="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input" type="file" name="practice[practice_${sArea}_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".pdf,.docx,.xlxs,.jpg,.jpeg,.png" aria-describedby="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING-hint" />
                    `);
            } else if (ele.type === 'file' && sType === 'image') {
                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                    <input id="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input dm-cropper-upload-image" type="file" name="practice[practice_${sArea}_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".jpg,.jpeg,.png" aria-describedby="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING-hint" />
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

function removePracticeProblemResource(id) {
    var res = document.getElementById("problem_resource_link_" + id);
    res.remove();
}

function clearFormOnAddResource(form) {
    var formToClear = document.getElementById(form);
    $.each(formToClear.find('input'), function (i, ele) {
        $(ele).val('');
    });
}