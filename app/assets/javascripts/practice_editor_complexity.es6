(($) => {
    const $document = $(document);

    function trainingDropdown() {
        const container = $('#required-training-container');
        const radioContainer = $('.need-training-radio-container');
        radioContainer.css('margin-bottom', '44px');

        $('.need_training_true_label').on('click', () => {
            container.css('display', 'block')
            radioContainer.css('margin-bottom', '0px');
        })
        
        $('.need_training_false_label').on('click', () => {
            container.css('display', 'none')
            radioContainer.css('margin-bottom', '44px');
        })
    }

    $document.on('turbolinks:load', trainingDropdown);
})(window.jQuery);