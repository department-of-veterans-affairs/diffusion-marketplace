$(document).on('turbolinks:load', () => {
    $('.replies-container').on('click', (event) => {
        $(event.currentTarget).find('div.children').hasClass('hidden') ? $(event.currentTarget).find('div.children').removeClass('hidden') : $(event.currentTarget).find('div.children').addClass('hidden');
        $(event.currentTarget).find('h5:nth-child(1)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(1)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(1)').addClass('hidden');
        $(event.currentTarget).find('h5:nth-child(2)').hasClass('hidden') ? $(event.currentTarget).find('h5:nth-child(2)').removeClass('hidden') : $(event.currentTarget).find('h5:nth-child(2)').addClass('hidden');
    });
});
