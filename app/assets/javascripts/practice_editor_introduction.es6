(($) => {
    const $document = $(document);



    function attachFacilitySelectListener() {

        $document.arrive('.practice-editor-origin-facility-li', (newElem) => {
            let $newEl = $(newElem);
            let dataId = $newEl.data('id');
            styleOriginFacility($newEl, dataId);
            getFacilitiesByState(facilityData, `practice_practice_origin_facilities_attributes_${dataId}_facility_id`, `editor_state_select_${dataId}`)
            $document.unbindArrive('.practice-editor-origin-li', newElem);
        });
    }

    function loadPracticeIntroductionFunctions() {
        attachFacilitySelectListener();
        showOtherAwardFields();
    }

    $document.on('turbolinks:load', loadPracticeIntroductionFunctions);
})(window.jQuery);

function styleOriginFacility($newEl, dataId){
    $newEl.css('list-style', 'none');
    const $originFacilityElements = $('.practice-editor-origin-facility-li');
    if($originFacilityElements.length > 1){
        $.each($originFacilityElements, (i, el) => {
            if($(el).data('id') !== dataId) {
                $(el).addClass('margin-bottom-4');
            }
        });
    }
}

function showOtherAwardFields(){
    if(document.getElementById('awards_other').checked) {
        document.getElementById('other_awards_container').style.display = 'block';
    }
    else{
        document.getElementById('other_awards_container').style.display = 'none';
    }
}
