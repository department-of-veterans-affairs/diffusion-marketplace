(($) => {
    const $document = $(document);

    function initializeOverviewForm() {
        hideResources();
        attachAddResourceListener('problem_resource_link_form', 'display_problem_resources_link');
        $(document).on('click', '#cancel_problem_resource_link', function (e) {
            debugger;
            e.preventDefault();
            document.getElementById("problem_link_form").style.display = 'none';
            document.getElementById('practice_problem_link').checked = false;
            document.getElementById('problem_resource_link_form').style.display = 'none';
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
        document.getElementById('solution_resource_video_form').style.display = 'none';
        document.getElementById('solution_resource_file_form').style.display = 'none';
        document.getElementById('solution_resource_image_form').style.display = 'none';
        document.getElementById('solution_resource_link_form').style.display = 'none';


        //document.getElementById('results_image_form').style.display = 'none';
        document.getElementById('results_resource_image_form').style.display = 'none';
        document.getElementById('results_video_form').style.display = 'none';
        document.getElementById('results_file_form').style.display = 'none';
        document.getElementById('results_link_form').style.display = 'none';
        document.getElementById('results_resource_video_form').style.display = 'none';
        document.getElementById('results_resource_file_form').style.display = 'none';
        document.getElementById('results_resource_image_form').style.display = 'none';
        document.getElementById('results_resource_link_form').style.display = 'none';
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

function addImageFields(sArea){
    var form_container = document.getElementById('display_' + sArea + '_form');
    // // Clear previous contents of the container
    while (form_container.hasChildNodes()) {
        form_container.removeChild(form_container.lastChild);
    }



    //for (i=0;i<number;i++){
        // Append a node with a random text

        form_container.appendChild(document.createTextNode("Use a high-quality .jpg, .jpeg, or .png file that is less than 32MB.  If you want to upload " +
            "an image that features a Veteran you must have FORM 3203.  Waivers must be filled out with the 'External to VA' check box selected."));
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(document.createElement("br"));

        var sGuid = createGUID();

        var input = document.createElement("INPUT");
        input.setAttribute("type", "file");
        form_container.appendChild(input);
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(document.createElement("br"));




        sGuid = createGUID();
        // Create an <input> element, set its type and name attributes
        input = document.createElement("input");
        input.type = "text";
        input.name = sGuid;
        input.id = sGuid;
        input.style.width = "643px";
        input.required = true;
        var label = document.createElement("Label");
        label.htmlFor = sGuid;
        label.innerHTML="Caption";
        form_container.appendChild(label);
        form_container.appendChild(document.createElement("br"));
        form_container.appendChild(input);
        form_container.appendChild(document.createElement("br"));
}

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

function attachAddResourceListener(formSelector, container){
    $(document).on('click', `#${formSelector} .add-resource`, function(e){
        debugger;
        e.preventDefault();
        const nGuid = createGUID();
        const link_form = $(`#${formSelector}`).clone(true);
        link_form.attr('id', `${formSelector}_${nGuid}`);


        $.each(link_form.find('input'), function(i, ele){
            $(ele).attr('name', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
            $(ele).attr('id', ele.name.replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });
        $.each(link_form.find('label'), function(i, ele){
            $(ele).attr('for', $(ele).attr('for').replace(/RANDOM_NUMBER_OR_SOMETHING/g, nGuid));
        });
        link_form.appendTo(`#${container}`);
        document.getElementById(container).style.display = 'block';
    });
}


