(($) => {
    const $document = $(document);

    function dismiss() {
        const parent = $(this).parents('.dismissible');
        parent.remove();
    }

    $document.on('click', '.dismiss-button', dismiss);
})(window.jQuery);