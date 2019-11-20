// (($) => {
//     const $document = $(document);

//     const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
//     const MILESTONE_CHARACTER_COUNT = 150;

//     function countTimelineChars() {
//         $('.milestone-textarea').each(function(i) {
//             let milestoneCurrentLength = $(i).val().length;
//             console.log(timelineCurrentLength);
//             let milestoneCharacterCounter = `(${milestoneCurrentLength}/${MILESTONE_CHARACTER_COUNT} characters)`;

//             $(i).find('.timeline-character-count').text(milestoneCharacterCounter);

//             if (timelineCurrentLength >= MILESTONE_CHARACTER_COUNT) {
//                 $(i).find('.milestone-textarea').css('color', CHARACTER_COUNTER_INVALID_COLOR);
//             }
//         });
//     }

//     $document.on('turbolinks:load', countTimelineChars);
// })(window.jQuery);