(($) => {
    const $document = $(document);

    function clearAdoptionEntryForm() {
        $document.on('click', '#clear_entry', function () {
            document.getElementById('adoption_form').reset();
            const end_month_el = document.getElementById('date_ended_month');
            const end_year_el = document.getElementById('date_ended_year');
            const facility_el = document.getElementById('editor_facility_select');
            end_month_el.classList.add('dm-color-disabled');
            end_month_el.disabled = true;
            end_year_el.classList.add('dm-color-disabled');
            end_year_el.disabled = true;
            facility_el.style.color = FACILITY_SELECT_DISABLED_COLOR;
            facility_el.disabled = true;
        })
    }

    function loadPracticeEditorFunctions() {
        // relies on `_facilitySelect.js` utility file to be loaded prior to this file
        getFacilitiesByState(facilityData);
        clearAdoptionEntryForm();
    }


    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);