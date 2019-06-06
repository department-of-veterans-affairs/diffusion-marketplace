(($) => {
    const $document = $(document);

    function printChecklist() {
        $('#share-practice').hide();
        $('#print-checklist-button').hide();
        window.print();
        $('#share-practice').show();
        $('#print-checklist-button').show();
    }

    $document.on('click', '#print-checklist-button', printChecklist);
})(window.jQuery);