// $(document).ready(function() {
//     $('.replies-container').on('click', function() {
//         $('.children').hasClass('hidden') ? $('.children').removeClass('hidden') : $('.children').addClass('hidden');
//     });
// });


$(document).ready(function() {
    $('.replies-container').on('click', function() {
        $(this).find('div.children').hasClass('hidden') ? $(this).find('div.children').removeClass('hidden') : $(this).find('div.children').addClass('hidden');
    });
})
