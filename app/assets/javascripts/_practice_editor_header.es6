(($) => {
    function preventHeaderModalFlickerOnPageLoad() {
        $(document).arrive('header', { existing: true }, () => {
            removeDisplayNoneFromModal('#dm-practice-editor-close-modal');
            removeDisplayNoneFromModal('#dm-editing-guide-modal');
            removeDisplayNoneFromModal('#thumbnail-image-guidance-modal');
        });
    }

    function initPracticeEditorHeaderFns() {
        preventHeaderModalFlickerOnPageLoad();
    }

    $(document).on("turbolinks:load", initPracticeEditorHeaderFns);
})(window.jQuery);
