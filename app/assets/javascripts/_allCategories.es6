(($) => {
    let $document = $(document);

    function addAllCheckBoxListener(allCheckboxSelector, standardCheckboxSelector) {
        let allCheckbox = allCheckboxSelector;
        let checkbox = standardCheckboxSelector;

        $document.on('change', allCheckbox, function() {
            if ($(this).prop('checked')) {
                $(checkbox).prop('checked', true);
            } else {
                $(checkbox).prop("checked", false);
            }
        });

        $document.on('change', checkbox, function() {
            let catCheckboxesCountMinusAllAndOther = $(checkbox).length;
            if ($(`input${checkbox}:checked`).length === catCheckboxesCountMinusAllAndOther) {
                $(allCheckbox).prop('checked', true);
            } else {
                $(allCheckbox).prop('checked', false);
            }
        });
    }

    function executeAllCategoryFunctions() {
        addAllCheckBoxListener('.all-clinical-checkbox', '.clinical-checkbox');
        addAllCheckBoxListener('.all-operational-checkbox', '.operational-checkbox');
        addAllCheckBoxListener('.all-strategic-checkbox', '.strategic-checkbox');
    }
    $document.on('turbolinks:load', executeAllCategoryFunctions);
})(window.jQuery);

