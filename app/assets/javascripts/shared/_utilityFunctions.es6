function changeFormActionUrl(ele, actionUrl) {
    $(ele).attr('action', actionUrl);
}

function removeDisplayNoneFromModal(modalEle) {
    $(modalEle).find('.usa-modal').removeClass('display-none');
}

function buildTitleAndAriaLabelForMapMarker(json, markerObject, totalAdoptions) {
    if (json.facility) {
        let officialStationName = json.facility.official_station_name;
        let commonName = json.facility.common_name;

        if (officialStationName && officialStationName.includes(commonName)) {
            return `${officialStationName}, ${totalAdoptions} total adoption${totalAdoptions !== 1 ? 's' : ''}`;
        } else {
            return `${officialStationName} (${commonName}), ${totalAdoptions} total adoption${totalAdoptions !== 1 ? 's' : ''}`;
        }
    }
}

function toggleUnderlineStylingForPracticeCardHeader() {
    const hiddenLinkSelector = '.dm-practice-link-hidden';
    const titleSelector = '.dm-practice-title';
    const underlineClass = 'practice-title-underline';

    $(document).on('mouseenter', hiddenLinkSelector, function() {
        $(this).parent().find(titleSelector).addClass(underlineClass);
    });

    $(document).on('mouseleave', hiddenLinkSelector, function() {
        $(this).parent().find(titleSelector).removeClass(underlineClass);
    });
}