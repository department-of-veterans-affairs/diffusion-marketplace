(($) => {
    const $document = $(document);

    function removeAlertMessage() {
        $('#close-alert-message').on('click', function() {
            $(this).closest('.dm-system-message').remove();
        })
    }

    $document.on("turbolinks:load", removeAlertMessage);
})(window.jQuery);