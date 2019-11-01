$(document).on('turbolinks:load', () => {
    $('.return-to-top').on('click', () => {
        $(window).animate({
            scrollTop: 0}, 1000);
    });
});