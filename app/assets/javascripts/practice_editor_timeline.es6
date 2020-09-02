(($) => {
    const $document = $(document);

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-timeline-li', (newElem) => {
            // $(newElem).find($('.add-milestone-link')).click();
            $(newElem).appendTo('#sortable_timelines');
            initSortable('#sortable_timelines');
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-timeline-li', newElem);
        });
    }

    function dragAndDropTimelineListItems() {
        initSortable('#sortable_timelines');
            
        if (typeof sortable('#sortable_timelines')[0] != 'undefined'){
            sortable('#sortable_timelines')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_timelines')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.timeline-position' ).val(index + 1)
                    return "timelines[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeTimelineFunctions() {
        removeBulletPointFromNewLi();
        // dragAndDropTimelineListItems();
    }

    $document.on('turbolinks:load', loadPracticeTimelineFunctions);
})(window.jQuery);