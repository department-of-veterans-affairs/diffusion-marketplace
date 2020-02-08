(($) => {
    const $document = $(document);

    function removeBulletPointFromNewAdditionalResourceLi() {
        $document.arrive('.practice-editor-resource-li', (newElem) => {
            $(newElem).appendTo('#sortable_resources');
            initSortable('#sortable_resources');
            $(newElem).css('list-style', 'none');
            $document.unbindArrive('.practice-editor-resource-li', newElem);
        });
    }

    function removeBulletPointFromNewPermissionLi() {
        $document.arrive('.practice-editor-permission-li', (newElem) => {
            $(newElem).appendTo('#sortable_permissions');
            initSortable('#sortable_permissions');
            $(newElem).css('list-style', 'none');
            $document.unbindArrive('.practice-editor-permission-li', newElem);
        });
    }

    function dragAndDropAdditionalResourceListItems() {
        initSortable('#sortable_resources');
            
        if (typeof sortable('#sortable_resources')[0] != 'undefined'){
            sortable('#sortable_resources')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_resources')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.resource-position' ).val(index + 1);
                    return "resources[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function dragAndDropPermissionListItems() {
        initSortable('#sortable_permissions');
        if (typeof sortable('#sortable_permissions')[0] != 'undefined'){
            sortable('#sortable_permissions')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_permissions')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.permission-position' ).val(index + 1);
                    return "permissions[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeChecklistFunctions() {
        removeBulletPointFromNewAdditionalResourceLi();
        removeBulletPointFromNewPermissionLi();
        dragAndDropAdditionalResourceListItems();
        dragAndDropPermissionListItems();
    }

    $document.on('turbolinks:load', loadPracticeChecklistFunctions);
})(window.jQuery);