(($) => {
    const $document = $(document);

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-timeline-li', (newElem) => {
            $(newElem).appendTo('#sortable_timelines');
            initSortable('#sortable_timelines');
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-timeline-li', newElem);
        });
    }
    function loadPracticeTimelineFunctions() {
        removeBulletPointFromNewLi();
    }

    $document.on('turbolinks:load', loadPracticeTimelineFunctions);
})(window.jQuery);