(($) => {
    const $document = $(document);

    function removeBulletPointFromNewImpactPhotoLi() {
        $document.arrive('.practice-editor-impact-photo-li', (newElem) => {
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-impact-photo-li', newElem);
        });
    }

    function removeBulletPointFromNewVideoFileLi() {
        $document.arrive('.practice-editor-video-file-li', (newElem) => {
            $(newElem).css('list-style', 'none')
            $document.unbindArrive('.practice-editor-video-file-li', newElem);
        });
    }

    function dragAndDropImpactPhotoListItems() {
        sortable('#sortable_impact_photos', {
            forcePlaceholderSize: true,
            placeholder: '<div></div>'
        });
            
        if (typeof sortable('#sortable_impact_photos')[0] != 'undefined'){
            sortable('#sortable_impact_photos')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_impact_photos')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.impact-photo-position' ).val(index + 1)
                    return "impact_photos[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function dragAndDropVideoFileListItems() {
        sortable('#sortable_video_files', {
            forcePlaceholderSize: true,
            placeholder: '<div></div>'
        });
            
        if (typeof sortable('#sortable_video_files')[0] != 'undefined'){
            sortable('#sortable_video_files')[0].addEventListener('sortstart', function(e) {
                console.log('starting sort', e)
            });

            sortable('#sortable_video_files')[0].addEventListener('sortupdate', function(e) {
                var dataIDList = $(this).children('li').map(function(index){
                    $(this).find( '.video-file-position' ).val(index + 1)
                    return "video_files[]=" + $(this).data("id");
                }).get().join("&");
                // Rails.ajax({
                //     url: $(this).data("url"),
                //     type: "PATCH",
                //     data: dataIDList,
                // });
            });
        }
    }

    function loadPracticeEditorImpactFunctions() {
        removeBulletPointFromNewImpactPhotoLi();
        removeBulletPointFromNewVideoFileLi();
        dragAndDropImpactPhotoListItems();
        dragAndDropVideoFileListItems();
    }

    $document.on('turbolinks:load', loadPracticeEditorImpactFunctions);
})(window.jQuery);