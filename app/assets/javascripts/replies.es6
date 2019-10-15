function getEvents(element) {
    var elemEvents = $._data(element, "events") || {};
    var allDocEvnts = $._data(document, "events") || {};
    for(var evntType in allDocEvnts) {
        if(allDocEvnts.hasOwnProperty(evntType)) {
            var evts = allDocEvnts[evntType];
            for(var i = 0; i < evts.length; i++) {
                if($(element).is(evts[i].selector)) {
                    if(elemEvents == null || elemEvents == undefined) {
                        elemEvents = {};
                    }
                    if(!elemEvents.hasOwnProperty(evntType)) {
                        elemEvents[evntType] = [];
                    }
                    elemEvents[evntType].push(evts[i]);
                }
            }
        }
    }
    return elemEvents;
}

$(document).on('turbolinks:load', () => {
    console.log('turbolinks replies load');
    const events = getEvents($('.comments-show-hide-button')[0])
    const numEvents = events['click'] ? events['click'].length : 0;

    if (numEvents === 0) {
        $(document).on('click', '.comments-show-hide-button', (event) => {
            console.log('Is on click getting fired');
            const target = $(event.currentTarget);
            const container = target.parent().next();
            const containerHidden = container.hasClass('hidden');
            containerHidden ? container.removeClass('hidden') : container.addClass('hidden');

            const numReplies = target.data('number-replies');
            const repliesText = numReplies === 1 ? 'reply' : 'replies';
            console.log('container hidden', containerHidden);
            if (!containerHidden) {
                target.text(`View ${numReplies} ${repliesText} >`);
            } else {
                target.text(`Hide ${repliesText} >`);
            }
        });
    }
});

$(document).on('ajax:before', '.new_comment', (e) => {
    // e.preventDefault();
    const formData = $(e.target).serializeArray();
    const parentId = formData.find((d) => {
        return d.name === 'comment[parent_id]';
    }).value
    const showChildren = !$(`#commontator-comment-${parentId}-children`).hasClass('hidden');
    $(e.target).find('input[name="show_children"]').val(showChildren);
    console.log('here');
    // $(e.target).submit();
});
