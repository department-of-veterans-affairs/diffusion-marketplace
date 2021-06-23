(($) => {
  const $document = $(document);

  function clearAdoptionFormListener() {
    $document.on('click', '#clear_entry', function () {
      clearAdoptionForm();
    })
  }

  function onAdoptionFormArriveListener() {
    $document.arrive("#adoption_form", (e) => {
      submitFormListener();
      let radioBtn = $(e.currentTarget).find('.adoptions-radio-button:checked');
      let target = $(e.currentTarget).closest(".adoption-form");
      if (radioBtn.length > 0) {
        let status = $(radioBtn[0]).val();
        _toggleViewsByStatus({ status, target });
      } else {
        _toggleDateRangeView({ target, visible: false });
        _toggleUnsuccessfulReasonsView({ target, visible: false });
      }
    });
  }

  function clearAdoptionForm() {
    const adoptionFormId = "adoption_form";
    const $adoptionForm = $(`#${adoptionFormId}`);
    $adoptionForm.parent().prev(".usa-alert").remove();
    $adoptionForm.parent().find(".usa-alert").remove();
    $adoptionForm[0].reset();
    $("#adoption_form_container").addClass("display-none");
    $("#add_adoption_button").removeClass("display-none");
    $adoptionForm.find(".usa-combo-box__clear-input").click();
  }

  function clearAdoptionForms() {
    let $adoptionForms = $(".adoption-form");
    $adoptionForms.each((i, adoptionForm) => {
      adoptionForm.reset();
    });
  }

  function showAdoptionFormListener() {
    $document.on('click', '#add_adoption_button', function() {
      _clearFormAlerts('#adoption_form')
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

  function toggleAccordionsListener(accordionEl1, accordionEl2) {
    $document.on("click", accordionEl1, function() {
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

  function submitFormListener() {
    // client-side validate dates
    $('button[id*="adoption_form"]').on('click', (event) => {
      const formId = $(event.target).data('form-id');
      const formIdSelector = `#${formId}`;

      // clear all alerts
      _clearFormAlerts(formIdSelector);

      if (!$(formIdSelector)[0].checkValidity()) {
        $(formIdSelector)[0].reportValidity();
        return false;
      }

      const data = $(formIdSelector).serializeArray().reduce(function (obj, item) {
        obj[item.name] = item.value;
        return obj;
      }, {});

      let dateErrorMsg = _isInvalidDate(data);
      let facilityErrorMsg = _isInvalidFacility(formIdSelector);
      let statusErrorMsg = _isInvalidStatus({ formIdSelector, status: data.status })

      let formValid = !dateErrorMsg && !facilityErrorMsg && !statusErrorMsg
      let invalidFormReason = `${dateErrorMsg}${dateErrorMsg && facilityErrorMsg ? "<br/>" : ""}${facilityErrorMsg}${dateErrorMsg || facilityErrorMsg && statusErrorMsg ? "<br/>" : ""}${statusErrorMsg}`;

      if (formValid && !invalidFormReason) {
        Rails.fire(document.getElementById(formId), 'submit');
      } else {
        _setAlert({target: event.target, formIdSelector, message: invalidFormReason});
      }
    });
  }

  function _clearFormAlerts(formIdSelector) {
    $(formIdSelector).parent().find(".usa-alert").remove();
    $(formIdSelector).find(".usa-alert").remove();
    $(".adoption-success-alert").remove();
  }

  function _isInvalidDate(data) {
    let errorMsg = '';
    if (data.status !== "In progress") {
      if (data["date_started[month]"] && data["date_started[year]"] && data["date_ended[month]"] && data["date_ended[year]"]) {
        const startDate = new Date(Number(data["date_started[year]"]), Number(data["date_started[month]"]), 1);
        const endDate = new Date(Number(data["date_ended[year]"]), Number(data["date_ended[month]"]), 1);
        let isValid = startDate.getTime() < endDate.getTime();
        errorMsg = isValid ? "" : "The start date cannot be after the end date.";
      } else if ((data["date_started[month]"] && !data["date_started[year]"]) || (!data["date_started[month]"] && data["date_started[year]"])) {
        errorMsg = "Provide a complete start date.";
      } else if ((data["date_ended[month]"] && !data["date_ended[year]"]) || (!data["date_ended[month]"] && data["date_ended[year]"])) {
        errorMsg = "Provide a complete end date.";
      }
    }
    return errorMsg
  }

  function _isInvalidFacility(formIdSelector) {
    let facValExists = $(formIdSelector).find('input[id*="editor_facility_select"]').val().length > 0;
    return facValExists ? '' : 'A facility must be selected.';
  }

  function _isInvalidStatus({formIdSelector, status}) {
    let errorMsg = '';
    if (status === 'Unsuccessful') {
      let checked = $(formIdSelector).find(".usa-checkbox__input:checked");
      let otherReasonText = $(formIdSelector).find('.dm-unsuccessful-reasons-other');
      let checkedList = [];

      checked.each((k, checkbox) => {
        checkedList.push($(checkbox).val());
      });

      if (checkedList.length === 0) {
        errorMsg = 'A reason must be selected for the unsuccessful adoption.';
      }

      if (checkedList.includes('5') && otherReasonText.val().length === 0) {
        errorMsg = "Provide text for the 'Other' reason the adoption was unsuccessful.";
      }
    }
    return errorMsg;
  }

  function _setAlert({ target, formIdSelector, message }) {
    const alertHtml = `
      <div class="usa-alert usa-alert--error margin-bottom-2" role="alert">
        <div class="usa-alert__body">
          <h3 class="usa-alert__heading">There was a problem with your adoption.</h3>
          <p class="usa-alert__text">${message}</p>
        </div>
      </div>`;
    $(formIdSelector).find("div:first").prepend(alertHtml);
    setTimeout(function () {
      Rails.enableElement(target);
    }, 1);
  }

  function cancelEditsListener() {
    $document.on('click', 'button[id*="cancel_edits"]', function (event) {
      const selector = $(event.target).data('selector');
      $(`button[aria-controls="${selector}"]`).attr('aria-expanded', false);
      $(`#${selector}`).attr('hidden', 'hidden');
    });
  }

  function _toggleDateRangeView({ visible, target }) {
    if (visible) {
      $(target).find(".dm-adoption-end-date").removeClass("display-none");
      $(target).find(".dm-date-range-text").removeClass("display-none");
    } else {
      $(target).find(".dm-adoption-end-date").addClass("display-none");
      $(target).find(".dm-date-range-text").addClass("display-none");
    }
  }

  function _toggleUnsuccessfulReasonsView({ visible, target }) {
    if (visible) {
      $(target).find(".dm-unsuccessful-adoption-reasons").removeClass("display-none");
    } else {
      $(target).find(".dm-unsuccessful-adoption-reasons").addClass("display-none");
    }
  }

  function _toggleOtherReasonTextAreaView({ visible, target }) {
    if (visible) {
      $(target).find(".ur-other-character-counter").removeClass("display-none");
      $(target).find(".dm-unsuccessful-adoption-other-reason").removeClass("display-none");
    } else {
      $(target).find(".ur-other-character-counter").addClass("display-none");
      $(target).find(".dm-unsuccessful-adoption-other-reason").addClass('display-none')
    }
  }

  function unsuccessfulReasonsCheckboxListener() {
    $document.on("click", ".dm-unsuccessful-adoption-checkbox", (e) => {
      let $currentCheck = $(e.currentTarget);
      let checked = $currentCheck.parent().parent().find(".usa-checkbox__input:checked");
      let checkedList = [];

      checked.each((k, checkbox) => {
        checkedList.push($(checkbox).val());
      })

      let showOtherReasonTextArea =
        checkedList.includes("5") ||
        ($currentCheck.val() === "5" && $currentCheck.is(":checked"));

      let target = $currentCheck.closest('.adoption-form')
      _toggleOtherReasonTextAreaView({ visible: showOtherReasonTextArea, target });
    });
  }

  function _toggleViewsByStatus({status, target}) {
    switch (status) {
      case "Completed":
        _toggleDateRangeView({ visible: true, target });
        _toggleUnsuccessfulReasonsView({ visible: false, target });
        break;
      case "In progress":
        _toggleDateRangeView({ visible: false, target });
        _toggleUnsuccessfulReasonsView({ visible: false, target });
        break;
      case "Unsuccessful":
        _toggleDateRangeView({ visible: true, target });
        _toggleUnsuccessfulReasonsView({ visible: true, target });
        break;
    }
  }

  function adoptionStatusRadioBtnListener() {
    $document.on('change', '.adoptions-radio-button', (e) => {
      let $adoptionStatus = $(e.currentTarget);
      let isChecked = $adoptionStatus.is(":checked");
      let status = $adoptionStatus.val();
      let target = $adoptionStatus.closest('.adoption-form');
      if (isChecked) {
        _toggleViewsByStatus({ status, target });
      }
    })
  }

  function loadPracticeEditorFunctions() {
    clearAdoptionForm();
    clearAdoptionForms();
    clearAdoptionFormListener();
    showAdoptionFormListener();
    toggleAccordionsListener('.child-accordion-button', '.parent-accordion-button');
    toggleAccordionsListener('.parent-accordion-button', '.child-accordion-button');
    adoptionStatusRadioBtnListener();
    cancelEditsListener();
    unsuccessfulReasonsCheckboxListener();
    submitFormListener();
    onAdoptionFormArriveListener();
  }

  $document.on('turbolinks:load', loadPracticeEditorFunctions);
})(window.jQuery);
