function getEvents(element) {
    try {
        let elemEvents = $._data(element, "events") || {};
        const allDocEvnts = $._data(document, "events") || {};
        for (let evntType in allDocEvnts) {
            if (allDocEvnts.hasOwnProperty(evntType)) {
                const evts = allDocEvnts[evntType];
                for (let i = 0; i < evts.length; i++) {
                    if ($(element).is(evts[i].selector)) {
                        if (elemEvents == null || elemEvents == undefined) {
                            elemEvents = {};
                        }
                        if (!elemEvents.hasOwnProperty(evntType)) {
                            elemEvents[evntType] = [];
                        }
                        elemEvents[evntType].push(evts[i]);
                    }
                }
            }
        }
        return elemEvents;
    } catch(err) {
        // this usually happens if there are no comments on the page
        return {};
    }
}

$(document).on('turbolinks:load', () => {
    const events = getEvents($('.comments-show-hide-button')[0]);
    const numEvents = events['click'] ? events['click'].length : 0;

    if (numEvents === 0) {
        $(document).on('click', '.comments-show-hide-button', (event) => {
            const target = $(event.currentTarget);
            const container = target.parent().next().find('.children');
            const containerHidden = container.hasClass('hidden');
            containerHidden ? container.removeClass('hidden') : container.addClass('hidden');

            const numReplies = target.data('number-replies');
            const repliesText = numReplies === 1 ? 'reply' : 'replies';
            if (!containerHidden) {
                target.text(`Show ${numReplies} ${repliesText}`);
            } else {
                target.text(`Hide ${numReplies} ${repliesText}`);
            }
        });
    }
});

$(document).on('ajax:before', '.new_comment', (e) => {
    const formData = $(e.target).serializeArray();
    const parentId = formData.find((d) => {
        return d.name === 'comment[parent_id]';
    }).value;
    const showChildren = !$(`#commontator-comment-${parentId}-children`).hasClass('hidden');
    $(e.target).find('input[name="show_children"]').val(showChildren);
});
