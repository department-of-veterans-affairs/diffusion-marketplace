$(document).on('turbolinks:load', () => {

    $(document).on('click', '.report-abuse-container', (e) => {
        $(e.target).find('.report-abuse-modal').removeClass('hidden');
    });

    $(document).on('click', '.report-abuse-cancel', (e) => {
        let cancelConfirmation = confirm('Are you sure want to cancel your report of this comment?');
        cancelConfirmation == true ? $(e.target).closest('.report-abuse-modal').addClass('hidden') : '';
    });
});
