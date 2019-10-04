$(document).on('turbolinks:load', () => {
    $('.show-hide-buttons-container').on('click', (event) => {
        $(event.currentTarget).next().hasClass('hidden') ? $(event.currentTarget).next().removeClass('hidden') : $(event.currentTarget).next().addClass('hidden');
        $(event.currentTarget).find('button:nth-child(1)').hasClass('hidden') ? $(event.currentTarget).find('button:nth-child(1)').removeClass('hidden') : $(event.currentTarget).find('button:nth-child(1)').addClass('hidden');
        $(event.currentTarget).find('button:nth-child(2)').hasClass('hidden') ? $(event.currentTarget).find('button:nth-child(2)').removeClass('hidden') : $(event.currentTarget).find('button:nth-child(2)').addClass('hidden');
    });
});
