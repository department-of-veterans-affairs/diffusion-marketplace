function addClassToElement(ele, eleClass) {
    $(ele).addClass(eleClass);
}

function removeClassFromElement(ele, eleClass) {
    $(ele).removeClass(eleClass);
}

function changeFormActionUrl(ele, actionUrl) {
    $(ele).attr('action', actionUrl);
}

function removeDisplayNoneFromModal(modalEle) {
    $(modalEle).find('.usa-modal').removeClass('display-none');
}