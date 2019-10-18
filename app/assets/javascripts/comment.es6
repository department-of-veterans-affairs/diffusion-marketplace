$(document).on('turbolinks:load', () => {
    $('.comment-cancel').on('click', (event) => {
        $('.comment-textarea').val('');
    });
});