$(document).arrive('.fields', (newElem) => {
    window.MutationObserver = window.MutationObserver
                            || window.WebKitMutationObserver
                            || window.MozMutationObserver;
                          // Find the element that you want to "watch"
                          var target = newElem, // document.querySelector('.fields'),
// create an observer instance
                            observer = new MutationObserver(function(mutation) {
                              /** this is the callback where you
                               do what you need to do.
                               The argument is an array of MutationRecords where the affected attribute is
                               named "attributeName". There is a few other properties in a record
                               but I'll let you work it out yourself.
                               **/
                              if (mutation[0].target.style.display === 'none' && !mutation[0].target.classList.value.includes('sortable-dragging')) {
                                  let $parent = $(newElem).parent();
                                  $(newElem).appendTo('ul.trash-can');
                                  $(newElem).find('input').prop('required', false);
                                  $(newElem).find('textarea').prop('required', false);
                                  $(document).unbindArrive('.fields', newElem);
                                  $parent.children('li').map(function(index){
                                      $(this).find('input[class*="position"]').val(index + 1);
                                      return "resources[]=" + $(this).data("id");
                                  }).get().join("&");
                                  observer.disconnect();
                              }
                            }),
// configuration of the observer:
                            config = {
                              attributes: true // this is to watch for attribute changes.
                            };
                          // pass in the element you wanna watch as well as the options
                          observer.observe(target, config);
                          // later, you can stop observing
                          // observer.disconnect();
});

function initSortable(ulId) {
    sortable(ulId, {
        forcePlaceholderSize: true,
        placeholder: '<div></div>',
        handle: '.position-arrows'
    });
}

function truncateText() {
    $('.practice-title').each(function(index, element) {
        $(element).shave(46);
    });

    $('.practice-card-tagline').each(function(index, element) {
        $(element).shave(56);
    });

    $('.practice-card-origin-info').each(function(index, element) {
        $(element).shave(32);
    });
}

$(document).on('turbolinks:load', truncateText);
