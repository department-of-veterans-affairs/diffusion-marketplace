(($) => {
    const $document = $(document);

    function initializeOverviewForm() {
        hideResources();

        //links
        attachAddResourceListener('problem_resource_link_form', 'display_problem_resources_link', 'problem', 'link');
        attachAddResourceListener('solution_resource_link_form', 'display_solution_resources_link', 'solution', 'link');
        attachAddResourceListener('results_resource_link_form', 'display_results_resources_link', 'results', 'link');
        attachDeleteResourceListener('problem', 'link');
        attachDeleteResourceListener('solution', 'link');
        attachDeleteResourceListener('results', 'link');
        //Videos
        attachAddResourceListener('problem_resource_video_form', 'display_problem_resources_video', 'problem', 'video');
        attachDeleteResourceListener('problem', 'video');
        attachAddResourceListener('solution_resource_video_form', 'display_solution_resources_video', 'solution', 'video');
        attachDeleteResourceListener('solution', 'video');
        attachAddResourceListener('results_resource_video_form', 'display_results_resources_video', 'results', 'video');
        attachDeleteResourceListener('results', 'video');
        //Files
        attachAddResourceListener('problem_resource_file_form', 'display_problem_resources_file', 'problem', 'file');
        attachDeleteResourceListener('problem', 'file');
        attachAddResourceListener('solution_resource_file_form', 'display_solution_resources_file', 'solution', 'file');
        attachDeleteResourceListener('solution', 'file');

        attachAddResourceListener('results_resource_file_form', 'display_results_resources_file', 'results', 'file');
        attachDeleteResourceListener('results', 'file');
        //Images
        attachAddResourceListener('problem_resource_image_form', 'display_problem_resources_image', 'problem', 'image');
        attachAddResourceListener('solution_resource_image_form', 'display_solution_resources_image', 'solution', 'image');
        attachAddResourceListener('results_resource_image_form', 'display_results_resources_image', 'results', 'image');
        attachDeleteResourceListener('problem', 'image');
        attachDeleteResourceListener('solution', 'image');
        attachDeleteResourceListener('results', 'image');


        //PROBLEM
        $(document).on('click', '#cancel_problem_resource_link', function (e) {
            e.preventDefault();
            document.getElementById("problem_link_form").style.display = 'none';
            document.getElementById('practice_problem_link').checked = false;
            document.getElementById('problem_resource_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_problem_resource_video', function (e) {
            e.preventDefault();
            document.getElementById("problem_video_form").style.display = 'none';
            document.getElementById('practice_problem_video').checked = false;
            document.getElementById('problem_resource_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_problem_resource_file', function (e) {
            e.preventDefault();
            document.getElementById("problem_file_form").style.display = 'none';
            document.getElementById('practice_problem_file').checked = false;
            document.getElementById('problem_resource_file_form').style.display = 'none';
        });

        //SOLUTION
        $(document).on('click', '#cancel_solution_resource_link', function (e) {
            e.preventDefault();
            document.getElementById("solution_link_form").style.display = 'none';
            document.getElementById('practice_solution_link').checked = false;
            document.getElementById('solution_resource_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_solution_resource_video', function (e) {
            e.preventDefault();
            document.getElementById("solution_video_form").style.display = 'none';
            document.getElementById('practice_solution_video').checked = false;
            document.getElementById('solution_resource_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_solution_resource_file', function (e) {
            e.preventDefault();
            document.getElementById("solution_file_form").style.display = 'none';
            document.getElementById('practice_solution_file').checked = false;
            document.getElementById('solution_resource_file_form').style.display = 'none';
        });

        //RESULTS
        $(document).on('click', '#cancel_results_resource_link', function (e) {
            e.preventDefault();
            document.getElementById("results_link_form").style.display = 'none';
            document.getElementById('practice_results_link').checked = false;
            document.getElementById('results_resource_link_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_results_resource_video', function (e) {
            e.preventDefault();
            document.getElementById("results_video_form").style.display = 'none';
            document.getElementById('practice_results_video').checked = false;
            document.getElementById('results_resource_video_form').style.display = 'none';
        });

        $(document).on('click', '#cancel_results_resource_file', function (e) {
            e.preventDefault();
            document.getElementById("results_file_form").style.display = 'none';
            document.getElementById('practice_results_file').checked = false;
            document.getElementById('results_resource_file_form').style.display = 'none';
        });
    }
    function showCurrentlySelectedOptions(currentSelectForm){
        $(`#${currentSelectForm}`).show();
    }
    function hideOtherSelectForms(formsToHide){
        formsToHide.forEach(f => {
            $(`#${f}`).hide();
        });
    }

    function attachDeleteResourceListener(sArea, sType){
        $document.on('click', '.remove_nested_fields', function (e) {
            const destroyInput = $(e.target).siblings('input');
            destroyInput.val(true);
            $(e.target).parents('div[id*=' + sArea + '_resource_' + sType + '_form]').hide();
        });
    }


    function hideResources(){
        document.getElementById('problem_image_form').style.display = 'none';
        document.getElementById('problem_video_form').style.display = 'none';
        document.getElementById('problem_file_form').style.display = 'none';
        document.getElementById('problem_link_form').style.display = 'none';

        document.getElementById('solution_image_form').style.display = 'none';
        document.getElementById('solution_video_form').style.display = 'none';
        document.getElementById('solution_file_form').style.display = 'none';
        document.getElementById('solution_link_form').style.display = 'none';
        // document.getElementById('solution_resource_video_form').style.display = 'none';
        // document.getElementById('solution_resource_file_form').style.display = 'none';
        // document.getElementById('solution_resource_image_form').style.display = 'none';
        // document.getElementById('solution_resource_link_form').style.display = 'none';


        //document.getElementById('results_image_form').style.display = 'none';
        document.getElementById('results_image_form').style.display = 'none';
        document.getElementById('results_video_form').style.display = 'none';
        document.getElementById('results_file_form').style.display = 'none';
        document.getElementById('results_link_form').style.display = 'none';
        // document.getElementById('results_resource_video_form').style.display = 'none';
        // document.getElementById('results_resource_file_form').style.display = 'none';
        // document.getElementById('results_resource_image_form').style.display = 'none';
        // document.getElementById('results_resource_link_form').style.display = 'none';
    }


    $document.on('turbolinks:load', initializeOverviewForm );
})(window.jQuery);

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#blah').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#imgInp").change(function(){
    readURL(this);
});

function displayResourceForm(sArea, sType){
    switch (sType) {
        case 'image':
            document.getElementById(sArea + '_image_form').style.display = 'block';
            document.getElementById(sArea + '_resource_image_form').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'video':
            document.getElementById(sArea + '_video_form').style.display = 'block';
            document.getElementById(sArea + '_resource_video_form').style.display = 'block';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'file':
            document.getElementById(sArea + '_file_form').style.display = 'block';
            document.getElementById(sArea + '_resource_file_form').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            document.getElementById(sArea + '_link_form').style.display = 'none';
            break;
        case 'link':
            document.getElementById(sArea + '_link_form').style.display = 'block';
            document.getElementById(sArea + '_resource_link_form').style.display = 'block';
            document.getElementById(sArea + '_video_form').style.display = 'none';
            document.getElementById(sArea + '_file_form').style.display = 'none';
            document.getElementById(sArea + '_image_form').style.display = 'none';
            break;
    }
}

// function addImageFields(sArea){
//     var form_container = document.getElementById('display_' + sArea + '_form');
//     // // Clear previous contents of the container
//     while (form_container.hasChildNodes()) {
//         form_container.removeChild(form_container.lastChild);
//     }


//     //for (i=0;i<number;i++){
//         // Append a node with a random text

//         form_container.appendChild(document.createTextNode("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB.  If you want to upload " +
//             "an image that features a Veteran you must have FORM 3203.  Waivers must be filled out with the 'External to VA' check box selected."));
//         form_container.appendChild(document.createElement("br"));
//         form_container.appendChild(document.createElement("br"));

//         var sGuid = createGUID();

//         var input = document.createElement("INPUT");
//         input.setAttribute("type", "file");
//         form_container.appendChild(input);
//         form_container.appendChild(document.createElement("br"));
//         form_container.appendChild(document.createElement("br"));




//         sGuid = createGUID();
//         // Create an <input> element, set its type and name attributes
//         input = document.createElement("input");
//         input.type = "text";
//         input.name = sGuid;
//         input.id = sGuid;
//         input.style.width = "643px";
//         input.required = true;
//         var label = document.createElement("Label");
//         label.htmlFor = sGuid;
//         label.innerHTML="Caption";
//         form_container.appendChild(label);
//         form_container.appendChild(document.createElement("br"));
//         form_container.appendChild(input);
//         form_container.appendChild(document.createElement("br"));
// }

function addVideoFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;
    input.placeholder = "https://www.youtube.com/watch?"
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Link (paste the full Youtube address)";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Caption";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));

}

function addLinkFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Link (paste the full address)";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Title";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "309px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();

    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="Description";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
}

function addFileFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }

    form_container.appendChild(document.createTextNode("Upload a .pdf, .docx, .xlxs, .jpg, or .png file that is less than 32MB. "));
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));
    //for (i=0;i<number;i++){
    // Append a node with a random text
    var sGuid = createGUID();
    // Create an <input> element, set its type and name attributes
    var input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "393px";
    input.required = true;
    var label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="File name";
    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(document.createElement("br"));

    sGuid = createGUID();
    label = document.createElement("Label");
    label.htmlFor = sGuid;
    label.innerHTML="File description";

    input = document.createElement("input");
    input.type = "text";
    input.name = sGuid;
    input.id = sGuid;
    input.style.width = "643px";
    input.required = true;

    form_container.appendChild(label);
    form_container.appendChild(document.createElement("br"));
    form_container.appendChild(input);
    form_container.appendChild(document.createElement("br"));
}

function validateFormFields(formSelector, sArea, sType){
    debugger
    clearErrorDivs(sArea);
    if(sType == "file"){
        var sAttachment = document.getElementsByClassName(sArea + '-file-attachment');
        if(sAttachment[0].value == ""){
            var errDiv = document.getElementById(sArea + '_file_err_message_attachment');
            errDiv.style.display = "block";
            return false;
        }
        var sName = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_file_name');
        if(sName.value == ""){
            var errDiv = document.getElementById(sArea + '_file_err_message_name');
            errDiv.style.display = "block";
            return false;
        }
        var sDesc = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_file_description');
        if(sDesc.value == ""){
            var errDiv = document.getElementById(sArea + '_file_err_message_description');
            errDiv.style.display = "block";
            return false;
        }
    }
    else if(sType == 'video'){
        var sLink = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_video_link_url');
        if(sLink.value == "" || !sLink.value.includes('https://www.youtube.com')){
            var errDiv = document.getElementById(sArea + '_video_err_message_link_url');
            errDiv.style.display = "block";
            return false;
        }

        var sName = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_video_name');
        if(sName.value === ""){
            var errDiv = document.getElementById(sArea + '_video_err_message_name');
            errDiv.style.display = "block";
            return false;
        }
    }
    else if(sType == 'link'){
        var sLink = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_link_link_url');
        if(sLink.value == ""){
            var errDiv = document.getElementById(sArea + '_link_err_message_link_url');
            errDiv.style.display = "block";
            return false;
        }
        var sName = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_link_name');
        if(sName.value == ""){
            var errDiv = document.getElementById(sArea + '_link_err_message_name');
            errDiv.style.display = "block";
            return false;
        }
        var sDesc = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_link_description');
        if(sDesc.value == ""){
            var errDiv = document.getElementById(sArea + '_link_err_message_description');
            errDiv.style.display = "block";
            return false;
        }
    }
    else if(sType == 'image'){
        var sAttachment = document.getElementsByClassName(sArea + '-image-attachment');
        if(sAttachment[0].value == ""){
            var errDiv = document.getElementById(sArea + '_image_err_message_attachment');
            errDiv.style.display = "block";
            return false;
        }
        var sName = document.getElementById('practice_' + sArea + '_resources_attributes_RANDOM_NUMBER_OR_SOMETHING_image_name');
        if(sName.value == ""){
            var errDiv = document.getElementById(sArea + '_image_err_message_name');
            errDiv.style.display = "block";
            return false;
        }
    }
    return true;
}

function clearErrorDivs(sArea){
    //FILE
    document.getElementById(sArea + '_file_err_message_name').style.display = "none";
    document.getElementById(sArea + '_file_err_message_description').style.display = "none";
    document.getElementById(sArea + '_file_err_message_attachment').style.display = "none";

    document.getElementById(sArea + '_video_err_message_name').style.display = "none";
    document.getElementById(sArea + '_video_err_message_link_url').style.display = "none";

    document.getElementById(sArea + '_link_err_message_link_url').style.display = "none";
    document.getElementById(sArea + '_link_err_message_name').style.display = "none";
    document.getElementById(sArea + '_link_err_message_description').style.display = "none";

    document.getElementById(sArea + '_image_err_message_attachment').style.display = "none";
    document.getElementById(sArea + '_image_err_message_name').style.display = "none";

}

function attachAddResourceListener(formSelector, container, sArea, sType){
    $(document).on('click', `#${formSelector} .add-resource`, function(e){
        e.preventDefault();
        if(validateFormFields(formSelector, sArea, sType) == false){
            return false;
        }
        const nGuid = createGUID();
        const formToClear = $(`#${formSelector}`);
        const link_form = formToClear.clone(true);
        link_form.attr('id', `${formSelector}_${nGuid}`);
        link_form.attr('class', `resource_container`);
        link_form.find('#cancelAddButtonRow').remove();

          const deleteEntryHtml = `<div class="grid-col-12 trash-container">
           <input type="hidden" value="false" name="practice[practice_${sArea}_resources_attributes][${nGuid}_${sType}][_destroy]"/>
            <button class="usa-button--unstyled dm-btn-warning remove_nested_fields">Delete entry</button></div>`;

        link_form.append(deleteEntryHtml);
        $.each(link_form.find('input'), function(i, ele){
            ele.required = true;
            $(ele).attr('name', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
            $(ele).attr('id', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });
        $.each(link_form.find('label'), function(i, ele){
            $(ele).attr('for', $(ele).attr('for').replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });
        link_form.appendTo(`#${container}`);
        document.getElementById(container).style.display = 'block';

        //clear form_inputs
        $.each(formToClear.find('input:not([type="hidden"])'), function(i, ele){
            $(ele).val(null);
            if (ele.type === 'file' && sType == 'file') {
                $(ele)
                    .closest('.usa-file-input')
                    .replaceWith(`
                        <input id="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input" type="file" name="practice[practice_${sArea}_resources_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".pdf,.docx,.xlxs,.jpg,.jpeg,.png" aria-describedby="input-single-hint" />
                    `);
            } else if (ele.type === 'file' && sType == 'image') {
                $(ele)
                .closest('.usa-file-input')
                .replaceWith(`
                    <input id="practice_${sArea}-input-single_RANDOM_NUMBER_OR_SOMETHING" class="usa-hint usa-file-input dm-cropper-upload-image" type="file" name="practice[practice_${sArea}_resources_attributes][RANDOM_NUMBER_OR_SOMETHING_${sType}][attachment]" accept=".jpg,.jpeg,.png" aria-describedby="input-single-hint" />
                `);
            }
        });

        if (sType == 'image') {
            formToClear.find('.dm-cropper-images-container').empty()
            $(`#${container}`).find('.dm-file-upload-label').remove()
            $(`#${container}`).find('.dm-cropper-delete-image').remove()
            $(`#${container}`).find('.usa-file-input').addClass('display-none')
        }
    });
}

function removePracticeProblemResource(id){
    var res = document.getElementById("problem_resource_link_"  + id);
    res.remove();
}

function clearFormOnAddResource(form){
        
    var formToClear = document.getElementById(form);
    
    $.each(formToClear.find('input'), function(i, ele){
        $(ele).val('');
    });
}




