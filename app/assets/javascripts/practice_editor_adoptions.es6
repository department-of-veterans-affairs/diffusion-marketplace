(($) => {
    const $document = $(document);

    function clearAdoptionEntryForm() {
        $document.on('click', '#clear_entry', function () {
            const adoptionFormId = 'adoption_form';
            const $adoptionForm = $(`#${adoptionFormId}`);
            $adoptionForm.parent().prev('.usa-alert').remove();
            $adoptionForm.parent().find('.usa-alert').remove();
            $adoptionForm[0].reset();
            const end_month_el = document.getElementById('date_ended_month');
            const end_year_el = document.getElementById('date_ended_year');
            const facility_el = document.getElementById('editor_facility_select');
            end_month_el.classList.add('dm-color-gray-20');
            end_month_el.disabled = true;
            end_year_el.classList.add('dm-color-gray-20');
            end_year_el.disabled = true;
            facility_el.style.color = FACILITY_SELECT_DISABLED_COLOR;
            facility_el.disabled = true;
            $('#adoption_form_container').addClass('display-none');
            $('#add_adoption_button').removeClass('display-none');
        })
    }

    function showAdoptionForm() {
        $(document).on('click', '#add_adoption_button', function() {
            $(this).addClass('display-none');
            $('#adoption_form_container').removeClass('display-none');
            $('.parent-accordion-button').each(function() {
                if ($(this).attr('aria-expanded') === 'true') {
                    $(this).attr('aria-expanded', false);
                    $(this).parent().next().attr('hidden', true)
                }
            })
        })
    }

    function toggleAccordions(accordionEl1, accordionEl2) {
        $(document).on("click", accordionEl1, function() {
            let adoptionFormEl = $('#adoption_form_container');
            if (accordionEl1 === '.parent-accordion-button') {
                if (!adoptionFormEl.hasClass('display-none')) {
                    adoptionFormEl.addClass('display-none');
                    $('#add_adoption_button').removeClass('display-none');
                }
                $(accordionEl2).parent().next().attr('hidden', true);
                $(accordionEl2).attr('aria-expanded', false);
            }
            $(accordionEl1).not($(this)).parent().next().attr('hidden', true);
            $(accordionEl1).not($(this)).attr('aria-expanded', false);
        })
    }

    function loadPracticeEditorFunctions() {
        // relies on `_facilitySelect.js` utility file to be loaded prior to this file
        getFacilitiesByState(facilityData);
        //getAdoptionFacilitiesByState(facilityData);
        clearAdoptionEntryForm();
        showAdoptionForm();
        toggleAccordions('.child-accordion-button', '.parent-accordion-button');
        toggleAccordions('.parent-accordion-button', '.child-accordion-button');
    }

    // client-side validate dates
    $document.on('click', 'button[id*="adoption_form"]', function (event) {
        event.preventDefault();
        const formId = $(event.target).data('form-id');
        const formIdSelector = `#${formId}`;

        // clear all alerts
        $(formIdSelector).parent().find('.usa-alert').remove();
        $(formIdSelector).find('.usa-alert').remove();

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
                <div class="usa-alert usa-alert--error margin-bottom-2" role="alert">
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