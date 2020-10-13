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
const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
const TAGLINE_CHARACTER_COUNT = 150;

function initSortable(ulId) {
    sortable(ulId, {
        forcePlaceholderSize: true,
        placeholder: '<div></div>',
        handle: '.position-arrows'
    });
}

function countCharsOnPageLoad() {
    let practiceNameCurrentLength = $('.practice-editor-name-input').val().length;
    let practiceSummaryCurrentLength = $('.practice-editor-summary-textarea').val().length;

    let practiceNameCharacterCounter = `(${practiceNameCurrentLength}/${NAME_CHARACTER_COUNT} characters)`;
    let practiceSummaryCharacterCounter = `(${practiceSummaryCurrentLength}/${SUMMARY_CHARACTER_COUNT} characters)`;

    $('#practice-editor-name-character-counter').text(practiceNameCharacterCounter);
    $('#practice-editor-summary-character-counter').text(practiceSummaryCharacterCounter);

    if (practiceNameCurrentLength >= NAME_CHARACTER_COUNT) {
        $('#practice-editor-name-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
    }

    if (practiceSummaryCurrentLength >= SUMMARY_CHARACTER_COUNT) {
        $('#practice-editor-summary-character-counter').css('color', CHARACTER_COUNTER_INVALID_COLOR);
    }
}

function characterCounter(e, $element, maxlength) {
    const t = e.target;
    let currentLength = $(t).val().length;

    let characterCounter = `(${currentLength}/${maxlength} characters)`;

    $element.css('color', CHARACTER_COUNTER_VALID_COLOR);
    $element.text(characterCounter);

    if (currentLength >= maxlength) {
        $element.css('color', CHARACTER_COUNTER_INVALID_COLOR);
    }
}

function maxCharacters() {
    debugger
    $('.practice-editor-tagline-textarea').on('input', (e) => {
        characterCounter(e, $('#practice-editor-tagline-character-counter'), TAGLINE_CHARACTER_COUNT);
    });
}

function truncateText() {
    debugger
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

$(document).on('turbolinks:load', truncateText, countCharsOnPageLoad, maxCharacters);
