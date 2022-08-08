function changeFormActionUrl(ele, actionUrl) {
    $(ele).attr('action', actionUrl);
}

function removeDisplayNoneFromModal(modalEle) {
    $(modalEle).find('.usa-modal').removeClass('display-none');
}