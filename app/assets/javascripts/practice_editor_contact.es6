const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
const EMPLOYEE_ROLE_MAX_LENGTH = 50;

(($) => {
    const $document = $(document);

    function newEmployeeRoleCharacterCounter() {
        $document.arrive('.va-employee-role', (newElem) => {
            $(newElem).on('input', (e) => {
                let t = e.target;
                let currentLength = $(t).val().length;
        
                let employeeRoleCharacterSpan = $(t).closest('div').find('.va-employee-role-character-count');
                let characterCounter = `(${currentLength}/${EMPLOYEE_ROLE_MAX_LENGTH} characters)`;
        
                employeeRoleCharacterSpan.css('color', CHARACTER_COUNTER_VALID_COLOR);
                employeeRoleCharacterSpan.text(characterCounter);
        
                if (currentLength >= EMPLOYEE_ROLE_MAX_LENGTH) {
                    milestoneCharacterSpan.css('color', CHARACTER_COUNTER_INVALID_COLOR);
                }
            });
            $document.unbindArrive('.va-employee-role', newElem);
        });
    }

    $document.on('turbolinks:load', newEmployeeRoleCharacterCounter);
})(window.jQuery);