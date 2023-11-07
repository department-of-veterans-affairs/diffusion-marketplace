(($) => {
    const $document = $(document);

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-contact-li', (newElem) => {
            $(newElem).appendTo('#sortable_contacts');
            $(newElem).css('list-style', 'none');
            $document.unbindArrive('.practice-editor-contact-li', newElem);
        });
    }

    function loadPracticeContactFunctions() {
        removeBulletPointFromNewLi();
    }

    $document.on('turbolinks:load', loadPracticeContactFunctions);
})(window.jQuery);