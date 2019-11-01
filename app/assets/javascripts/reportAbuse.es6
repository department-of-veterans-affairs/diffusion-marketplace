$(document).on('turbolinks:load', () => {

    $(document).on('click', '.report-abuse-container', (e) => {
        $(e.target).find('.report-abuse-modal').removeClass('hidden');
    });

    $(document).on('click', '.report-abuse-cancel', (e) => {
        $(e.target).closest('.report-abuse-modal').addClass('hidden');
    });
});
