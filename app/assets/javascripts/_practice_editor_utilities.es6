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
                              if (mutation[0].target.style.display === 'none' && mutation[0].target.draggable != true) {
                                  $(newElem).remove();
                                  $(document).unbindArrive('.fields', newElem);
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
