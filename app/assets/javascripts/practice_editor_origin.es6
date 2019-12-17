(($) => {
    const $document = $(document);

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-origin-li', (newElem) => {
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-origin-li', newElem);
        });
    }

    function dragAndDropOriginListItems() {
        sortable('.sortable');
        sortable('#sortable_origins', {
            forcePlaceholderSize: true,
            placeholder: '<div></div>'
        });
            
        if (typeof sortable('#sortable_origins')[0] != 'undefined'){
            sortable('#sortable_origins')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_origins')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.origin-position' ).val(index + 1)
                    return "practice_creators[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeOriginFunctions() {
        removeBulletPointFromNewLi();
        dragAndDropOriginListItems();
    }

    $document.on('turbolinks:load', loadPracticeOriginFunctions);
})(window.jQuery);