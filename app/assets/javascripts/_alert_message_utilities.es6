(($) => {
    const $document = $(document);

    function removeAlertMessage() {
        $('#close-alert-message').on('click', function() {
            $(this).closest('.usa-alert').remove();
        })
    }

    $document.on("turbolinks:load", removeAlertMessage);
})(window.jQuery);