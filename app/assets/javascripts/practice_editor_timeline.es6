const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
const MILESTONE_MAX_LENGTH = 150;

(($) => {
    const $document = $(document);

    function newMilestoneCharacterCounter() {
        $document.arrive('.milestone-textarea', (newElem) => {
            $(newElem).on('input', (e) => {
                let t = e.target;
                let currentLength = $(t).val().length;
        
                let milestoneCharacterSpan = $(t).closest('div').find('.milestone-character-count');
                let characterCounter = `(${currentLength}/${MILESTONE_MAX_LENGTH} characters)`;
        
                milestoneCharacterSpan.css('color', CHARACTER_COUNTER_VALID_COLOR);
                milestoneCharacterSpan.text(characterCounter);
        
                if (currentLength >= MILESTONE_MAX_LENGTH) {
                    milestoneCharacterSpan.css('color', CHARACTER_COUNTER_INVALID_COLOR);
                }
            });
            $document.unbindArrive('.milestone-textarea', newElem);
        });
    }

    $document.on('turbolinks:load', newMilestoneCharacterCounter);
})(window.jQuery);