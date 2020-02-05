(($) => {
    const $document = $(document);

    function trainingDropdown() {
        const container = $('#required-training-container');
        const radioContainer = $('.need-training-radio-container');

        container.hasClass('required-training-container-open') ? container.css('display', 'block') : container.css('display', 'none');

        $('.need_training_true_label').on('click', () => {
            container.css('display', 'block')
            radioContainer.css('margin-bottom', '0px');
        })
        
        $('.need_training_false_label').on('click', () => {
            container.css('display', 'none')
            radioContainer.css('margin-bottom', '44px');
        })
    }

    function checkAllDepartmentBoxes() {
        $('#all_practice_departments').click(function(event) {   
            if(this.checked) {
                $('.department-input').each(function() {
                    this.checked = true;                        
                });
                $('#no_practice_department').prop('checked', false);
            } else {
                $('.department-input').each(function() {
                    this.checked = false;                        
                });
            }
        });
    }

    function uncheckAllDepartmentBoxes() {
        $('#no_practice_department').click(function(event) {   
            if(this.checked) {
                $('#all_practice_departments').prop('checked', false);
                $('.department-input').each(function() {
                    this.checked = false;                        
                });
            }
        });
    }

    function uncheckAllIfAnotherOptionIsChosen() {
        $('.department-input').click(function(event) {   
            if($(event.target).is(':checked') && $('#all_practice_departments').is(':checked')) {
                $('#all_practice_departments').prop('checked', false);
                $('.department-input').not(event.target).prop('checked', false);
            }
        });
    }

    function uncheckNoneIfOtherOptionIsChosen() {
        $('.department-input').click(function(event) {   
            if(this.checked) {
                $('#no_practice_department').prop('checked', false);
            }
        });
    }

    function removeRequiredStaffTrainingFieldsIfTrainingIsNotRequired() {
        $document.arrive('.staff-training-container', (newElem) => {
            let trainingTitle = $('.staff-training-title');
            let trainingDescription = $('.staff-training-description');
            if ($('#practice_need_training_false').prop('checked') == true && $('.usa-checkbox__input:checked').length > 0) {
                trainingTitle.prop('required', false);
                trainingDescription.prop('required', false);
            } else {
                trainingTitle.prop('required', true);
                trainingDescription.prop('required', true);
            }
            $document.unbindArrive('.staff-training-container', newElem);
        });
    }

    function initComplexityFunctions() {
        trainingDropdown();
        checkAllDepartmentBoxes();
        uncheckAllDepartmentBoxes();
        removeRequiredStaffTrainingFieldsIfTrainingIsNotRequired();
        uncheckNoneIfOtherOptionIsChosen();
        uncheckAllIfAnotherOptionIsChosen();
    }

    $document.on('turbolinks:load', initComplexityFunctions);
})(window.jQuery);