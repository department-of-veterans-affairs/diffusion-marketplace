(($) => {
    const $document = $(document);
    const sections = ['problem_resources', 'solution_resources', 'results_resources', 'multimedia'];
    const resourceTypes = ['link', 'video', 'file', 'image'];

    function initializeForm() {
        hideResources();
        attachDeleteResourceListener();


        sections.forEach(section => {
            resourceTypes.forEach(type => {
                const formId = `${section}_${type}_form`;
                const displayContainer = `display_${section}_${type}`;

                attachAddResourceListener(formId, displayContainer, section, type);
                attachCancelResourceListener(section, type);
            });
        });
    }

    function attachCancelResourceListener(section, type) {
        const cleanSection = section.replace('_resources', '');
        const cancelId = `#cancel_${section}_${type}`;
        $(document).on('click', cancelId, function (e) {
            e.preventDefault();
            document.getElementById(`practice_${cleanSection}_${type}`).checked = false;
            document.getElementById(`${section}_${type}_form`).style.display = 'none';
        });
    }

    function hideResources() {
        sections.forEach(section => {
            $(`#display_${section}_form div[id*="_form"]`).hide();
        });
    }

    $document.on('turbolinks:load', initializeForm);

})(window.jQuery);

function displayResourceForm(sArea, sType) {
    $(`#display_${sArea}_form div[id*="_form"]`).hide();
    $(`#display_${sArea}_form div[id="${sArea}_${sType}_form"]`).show();
}
