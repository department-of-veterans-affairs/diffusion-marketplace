$(document).on('turbolinks:load', () => {
    const modalBackground = $('#report-abuse-modal-background');

    $(document).on('click', '.report-abuse-container', (e) => {
        $(e.target).find('.report-abuse-modal').removeClass('hidden')
        modalBackground.removeClass('hidden');
    });

    $(document).on('click', '.report-abuse-cancel', (e) => {
        $(e.target).closest('.report-abuse-modal').addClass('hidden');
        modalBackground.addClass('hidden');
    });
});
