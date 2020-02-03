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

    function initComplexityFunctions() {
        trainingDropdown();
        checkAllDepartmentBoxes();
        uncheckAllDepartmentBoxes();
    }

    $document.on('turbolinks:load', initComplexityFunctions);
})(window.jQuery);