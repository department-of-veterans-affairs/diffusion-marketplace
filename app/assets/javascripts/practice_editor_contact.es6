(($) => {
    const $document = $(document);

    function removeBulletPointFromNewLi() {
        $document.arrive('.practice-editor-contact-li', (newElem) => {
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-contact-li', newElem);
        });
    }

    function dragAndDropContactListItems() {
        sortable('#sortable_contacts', {
            forcePlaceholderSize: true,
            placeholder: '<div></div>'
        });
            
        if (typeof sortable('#sortable_contacts')[0] != 'undefined'){
            sortable('#sortable_contacts')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_contacts')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.contact-position' ).val(index + 1)
                    return "contacts[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeContactFunctions() {
        removeBulletPointFromNewLi();
        dragAndDropContactListItems();
    }

    $document.on('turbolinks:load', loadPracticeContactFunctions);
})(window.jQuery);