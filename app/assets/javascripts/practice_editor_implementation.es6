(($) => {
    const $document = $(document);

    function initializeImplementationForm() {
        hideResources('core_attachment');
        hideResources('optional_attachment');
        hideResources('support_attachment');

        attachDeleteResourceListener();
        attachAddResourceListener("core_attachment_file_form", "display_core_attachment_file", "core_attachment", "file" );
        attachAddResourceListener("core_attachment_link_form", "display_core_attachment_link", "core_attachment", "link" );

        attachAddResourceListener("optional_attachment_file_form", "display_optional_attachment_file", "optional_attachment", "file" );
        attachAddResourceListener("optional_attachment_link_form", "display_optional_attachment_link", "optional_attachment", "link" );

        attachAddResourceListener("support_attachment_file_form", "display_support_attachment_file", "support_attachment", "file" );
        attachAddResourceListener("support_attachment_link_form", "display_support_attachment_link", "support_attachment", "link" );

        // //links
        // attachAddResourceListener('problem_resources_link_form', 'display_problem_resources_link', 'problem_resources', 'link');
        // attachAddResourceListener('solution_resources_link_form', 'display_solution_resources_link', 'solution_resources', 'link');
        // attachAddResourceListener('results_resources_link_form', 'display_results_resources_link', 'results_resources', 'link');
        //
        // //Videos
        // attachAddResourceListener('problem_resources_video_form', 'display_problem_resources_video', 'problem_resources', 'video');
        // attachAddResourceListener('solution_resources_video_form', 'display_solution_resources_video', 'solution_resources', 'video');
        // attachAddResourceListener('results_resources_video_form', 'display_results_resources_video', 'results_resources', 'video');
        // attachAddResourceListener('multimedia_video_form', 'display_multimedia_video', 'multimedia', 'video');
        //
        // //Files
        // attachAddResourceListener('problem_resources_file_form', 'display_problem_resources_file', 'problem_resources', 'file');
        // attachAddResourceListener('solution_resources_file_form', 'display_solution_resources_file', 'solution_resources', 'file');
        // attachAddResourceListener('results_resources_file_form', 'display_results_resources_file', 'results_resources', 'file');
        //
        // //Images
        // attachAddResourceListener('problem_resources_image_form', 'display_problem_resources_image', 'problem_resources', 'image');
        // attachAddResourceListener('solution_resources_image_form', 'display_solution_resources_image', 'solution_resources', 'image');
        // attachAddResourceListener('results_resources_image_form', 'display_results_resources_image', 'results_resources', 'image');
        // attachAddResourceListener('multimedia_image_form', 'display_multimedia_image', 'multimedia', 'image');
        //
        // //PROBLEM
        // $(document).on('click', '#cancel_problem_resources_image', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_problem_image').checked = false;
        //     document.getElementById('problem_resources_image_form').style.display = 'none';
        // });
        //
        //
        // $(document).on('click', '#cancel_problem_resources_link', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_problem_link').checked = false;
        //     document.getElementById('problem_resources_link_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_problem_resources_video', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_problem_video').checked = false;
        //     document.getElementById('problem_resources_video_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_problem_resources_file', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_problem_file').checked = false;
        //     document.getElementById('problem_resources_file_form').style.display = 'none';
        // });
        //
        // //SOLUTION
        // $(document).on('click', '#cancel_solution_resources_image', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_solution_image').checked = false;
        //     document.getElementById('solution_resources_image_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_solution_resources_link', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_solution_link').checked = false;
        //     document.getElementById('solution_resources_link_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_solution_resources_video', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_solution_video').checked = false;
        //     document.getElementById('solution_resources_video_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_solution_resources_file', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_solution_file').checked = false;
        //     document.getElementById('solution_resources_file_form').style.display = 'none';
        // });
        //
        // //RESULTS
        // $(document).on('click', '#cancel_results_resources_image', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_results_image').checked = false;
        //     document.getElementById('results_resources_image_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_results_resources_link', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_results_link').checked = false;
        //     document.getElementById('results_resources_link_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_results_resources_video', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_results_video').checked = false;
        //     document.getElementById('results_resources_video_form').style.display = 'none';
        // });
        //
        // $(document).on('click', '#cancel_results_resources_file', function (e) {
        //     e.preventDefault();
        //     document.getElementById('practice_results_file').checked = false;
        //     document.getElementById('results_resources_file_form').style.display = 'none';
        // });
        //
        // //MULTIMEDIA
        // $(document).on('click', '#cancel_multimedia_image', function (e) {
        //     e.preventDefault();
        //     document.getElementById("multimedia_image_form").style.display = 'none';
        //     document.getElementById('practice_multimedia_image').checked = false;
        // });
        //
        // $(document).on('click', '#cancel_multimedia_video', function (e) {
        //     e.preventDefault();
        //     document.getElementById("multimedia_video_form").style.display = 'none';
        //     document.getElementById('practice_multimedia_video').checked = false;
        // });
    }

    function showCurrentlySelectedOptions(currentSelectForm) {
        $(`#${currentSelectForm}`).show();
    }

    function hideOtherSelectForms(formsToHide) {
        formsToHide.forEach(f => {
            $(`#${f}`).hide();
        });
    }

    function hideResources(sArea) {
        const areas = [sArea];
        areas.forEach(a => {
            $(`#display_${a}_form div[id*="_form"]`).hide();
            $(`#display_${a}_form div[id*="_file"]`).hide();
            $(`#display_${a}_form div[id*="_link"]`).hide();
        });
    }


    $document.on('turbolinks:load', initializeImplementationForm);
})(window.jQuery);

function displayAttachmentForm(sArea, sType) {
    //debugger
    $(`#display_${sArea}_form div[id*="_form"]`).hide();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
}