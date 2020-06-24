$(document).on('turbolinks:load', () => {
    $('.dm-return-to-top').on('click', () => {
        $(window).animate({
            scrollTop: 0}, 0);
    });
});