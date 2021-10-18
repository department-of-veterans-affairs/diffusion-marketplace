(($) => {
    const $document = $(document);

function preventCrisisLineModalFlickerOnPageLoad() {
    $(document).arrive('header', { existing: true }, () => {
        $('#va-crisis-line-modal').find('.usa-modal').removeClass('display-none');
    });
}

    $document.on('turbolinks:load', preventCrisisLineModalFlickerOnPageLoad);
})(window.jQuery);

