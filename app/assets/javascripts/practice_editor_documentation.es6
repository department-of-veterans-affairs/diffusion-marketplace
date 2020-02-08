(($) => {
    const $document = $(document);

    function removeBulletPointFromNewAdditionalDocumentLi() {
        $document.arrive('.practice-editor-additional-document-li', (newElem) => {
            $(newElem).appendTo('#sortable_additional_documents');
            initSortable('#sortable_additional_documents');
            $(newElem).css('list-style', 'none');
            $document.unbindArrive('.practice-editor-additional-document-li', newElem);
        });
    }

    function removeBulletPointFromNewPublicationLi() {
        $document.arrive('.practice-editor-publication-li', (newElem) => {
            $(newElem).appendTo('#sortable_publications');
            initSortable('#sortable_publications');
            $(newElem).css('list-style', 'none');
            $document.unbindArrive('.practice-editor-publication-li', newElem);
        });
    }

    function dragAndDropAdditionalDocumentListItems() {
        initSortable('#sortable_additional_documents');
            
        if (typeof sortable('#sortable_additional_documents')[0] != 'undefined'){
            sortable('#sortable_additional_documents')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_additional_documents')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.additional-document-position' ).val(index + 1)
                    return "additional_documents[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function dragAndDropPublicationListItems() {
        initSortable('#sortable_publications');
            
        if (typeof sortable('#sortable_publications')[0] != 'undefined'){
            sortable('#sortable_publications')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_publications')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.publication-position' ).val(index + 1)
                    return "publications[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeDocumentationFunctions() {
        removeBulletPointFromNewAdditionalDocumentLi();
        removeBulletPointFromNewPublicationLi();
        dragAndDropAdditionalDocumentListItems();
        dragAndDropPublicationListItems();
    }

    $document.on('turbolinks:load', loadPracticeDocumentationFunctions);
})(window.jQuery);