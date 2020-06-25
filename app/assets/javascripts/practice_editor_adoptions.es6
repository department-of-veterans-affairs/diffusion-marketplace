(($) => {
    const $document = $(document);

    function clearAdoptionEntryForm() {
        $document.on('click', '#clear_entry', function () {
            const adoptionFormId = 'adoption_form';
            const $adoptionForm = $(`#${adoptionFormId}`);
            $adoptionForm.parent().find('.usa-alert').remove();
            $adoptionForm.find('.usa-alert').remove();
            $adoptionForm[0].reset();
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
        debugger
        getFacilitiesByState(facilityData);
        getAdoptionFacilitiesByState(facilityData);
        clearAdoptionEntryForm();
    }

    // client-side validate dates
    $document.on('click', 'button[id*="adoption_form"]', function (event) {
        event.preventDefault();
        const formId = $(event.target).data('form-id');
        const formIdSelector = `#${formId}`;

        // clear all alerts
        $(formIdSelector).parent().find('.usa-alert').remove();
        $(formIdSelector).find('.usa-alert').remove();
        debugger

        if (!$(formIdSelector)[0].checkValidity()) {
            $(formIdSelector)[0].reportValidity();
            return false;
        }

        let formValid = true;

        const data = $(formIdSelector).serializeArray().reduce(function (obj, item) {
            obj[item.name] = item.value;
            return obj;
        }, {});

        if (data['date_started[month]'] && data['date_started[year]'] && data['date_ended[month]'] && data['date_ended[year]']) {
            const startDate = new Date(Number(data['date_started[year]']), Number(data['date_started[month]']), 1);
            const endDate = new Date(Number(data['date_ended[year]']), Number(data['date_ended[month]']), 1);
            formValid = startDate.getTime() < endDate.getTime();
        }

        if (formValid) {
            Rails.fire(document.getElementById(formId), 'submit');
        } else {
            const alertHtml = `
                <div class="usa-alert usa-alert--error" role="alert">
                    <div class="usa-alert__body">
                        <h3 class="usa-alert__heading">There was a problem with your date entries.</h3>
                        <p class="usa-alert__text">The start date cannot be after the end date.</p>
                    </div>
                </div>`;
            $(formIdSelector).find('div:first').prepend(alertHtml);
            setTimeout(function () {
                Rails.enableElement(event.target);
            }, 1);
        }
    });

    $document.on('click', 'button[id*="cancel_edits"]', function (event) {
        const selector = $(event.target).data('selector');
        $(`button[aria-controls="${selector}"]`).attr('aria-expanded', false);
        $(`#${selector}`).attr('hidden', 'hidden');
    });

    $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);