// $(document).on('turbolinks:load', () => {
//     $('.show-hide-replies').on('click', () => {
        
        // $(event.currentTarget).find('div.children').hasClass('hidden') ? $(event.currentTarget).find('div.children').removeClass('hidden') : $(event.currentTarget).find('div.children').addClass('hidden');
        // $(event.currentTarget).find('h5:nth-child(1)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(1)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(1)').addClass('hidden');
        // $(event.currentTarget).find('h5:nth-child(2)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(2)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(2)').addClass('hidden');
//     });
// });

$(document).on('turbolinks:load', () => {
    $('.show-hide-replies').on('click', (event) => {
        let id = $(this).id

        $(event.currentTarget).find('h5:nth-child(1)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(1)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(1)').addClass('hidden');
        $(event.currentTarget).find('h5:nth-child(2)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(2)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(2)').addClass('hidden');
        $(`div.commontator-comment-${id}-children`).hasClass('hidden') ? $(`div.commontator-comment-${id}-children`).removeClass('hidden') : $(`div.commontator-comment-${id}-children`).addClass('hidden');
    });
});
