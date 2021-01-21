(($) => {
    const $document = $(document);

    function findNext(key, obj) {
        let keys = Object.keys(obj);
        return keys[(keys.indexOf(key) + 1)];
    }

    function addActiveClass(selector) {
        $(selector).removeClass('side-nav-inactive');
        $(selector).addClass('side-nav-active');
    }
    function removeActiveClass(selector) {
        $(selector).removeClass('side-nav-active');
        $(selector).addClass('side-nav-inactive');
    }

    function highlightSidebarSectionWhenInView() {
        let sections = {};
        const sideNavHeaders = $('.nav-header');
        sideNavHeaders.each(function() {
            const headerSelector = `#${this.id}`;
            sections[headerSelector] = `.sidebar-${this.id}`;
        });

        $(window).on('scroll', function () {
            let viewportTop = $(window).scrollTop();
            let activeItem = false;
            Object.keys(sections).forEach(function (s) {
                let sectionPosition = $(s).offset().top + (-50);
                let nextSection = findNext(s, sections);
                if (nextSection) {
                    let nextSectionPosition = $(nextSection).offset().top + (-50);
                    if (viewportTop >= sectionPosition && viewportTop < nextSectionPosition && !activeItem) {
                        addActiveClass(sections[s]);
                        activeItem = true;
                    } else {
                        removeActiveClass(sections[s]);
                    }
                } else if (viewportTop >= sectionPosition && !activeItem) {
                    addActiveClass(sections[s]);
                    activeItem = true;
                } else {
                    removeActiveClass(sections[s]);
                }
            });
        })
    }

    // Show more or less on comments
    function setMoreLessHTML(element) {
        const showChar = 300;
        const ellipsesText = "...";
        const moreText = 'See more';
        const lessText = 'See less';
        let t = $(element).text();
        let firstHalf = `${t.slice(0, showChar)}<span>${ellipsesText} </span><button type="button" class="usa-button--unstyled dm-btn-primary more-link text-no-underline width-auto">${moreText}</button>`;
        let secondHalf = `<span style="display:none;">${t.slice(showChar, t.length)} <button type="button" class="usa-button--unstyled dm-btn-primary less-link text-no-underline width-auto">${lessText}</button></span>`;
        if (t.length < showChar) return;

        $(element).html(firstHalf + secondHalf);
    }

    function setMoreLessHandlers(elements) {
        $('button.more-link', elements).click(function (event) {
            let $this = $(this);
            event.preventDefault();
            $this.hide().prev().hide();
            $this.next().show();
        });

        $('button.less-link', elements).click(function (event) {
            event.preventDefault();
            $(this).parent().hide().prev().show().prev().show();
        });
    }

    function setUpShowMoreOrLessButtons() {
        const minimized_elements = $('div.more');

        minimized_elements.each(function () {
            setMoreLessHTML(this);
        });

        setMoreLessHandlers(minimized_elements);
    }

    function setUpShowMoreOrLessOnArrive() {
        $(document).arrive(".more", (newElem) => {
            setMoreLessHTML(newElem);

            setMoreLessHandlers(newElem);
        });
    }

    function createWidthForImageCaption() {
        $('.practice-editor-impact-photo-container').each(function () {
            $(this).hide();
        });
        $(window).on('load', function() {
            $('.practice-editor-impact-photo').each(function () {
                $(this).parent().show();
                if ($(window).width() > 1023) {
                    $(this).next().width(`${$(this).width()}`);
                }
            })
        })
    }

    // This sets the comment parameters for the Resize plugin
    function commontatorResize(El) {
        if (!$(El).hasClass('clone')) {
            $(El).each(function () {
                $(El).autoResize({extraSpace: 14});
                $(El).height($(this)[0].scrollHeight - 12);
            });
        }
    }

    function expandCommentTextArea() {
        commontatorResize('.comment-textarea')
    }

    function expandReplyTextArea() {
        let replyEl = '.reply-textarea';
        $document.arrive(replyEl, function(newElem) {
            if (!$(newElem).hasClass('clone')) {
                commontatorResize(newElem);
            }
            $document.unbindArrive(replyEl, newElem);
        });
    }

    function openAdoptionStatusModal(status) {
        $(document).on('click', `.${status}-modal-icon`, (e) => {
            // Click accordion button to close content because when the icon is clicked, so is the button
            $(e.target).parent().click();

            $(`.${status}-status-modal-container`).removeClass('display-none');
        });
    }

    function closeAdoptionStatusModal(status) {
        $(document).on('click', `#close_${status}_status_modal`, () => {
            $(`.${status}-modal-icon`).parent().focus();
            $(`.${status}-status-modal-container`).addClass('display-none');
        });
    }

    function toggleAdoptionStatusModal() {
        let adoptionStatuses = [
            'successful',
            'unsuccessful',
            'in-progress'
        ];

        adoptionStatuses.forEach(status => {
            openAdoptionStatusModal(status);
            closeAdoptionStatusModal(status);
        });
    }

    function executePracticeCommentsFunctions() {
        highlightSidebarSectionWhenInView();
        setUpShowMoreOrLessButtons();
        setUpShowMoreOrLessOnArrive();
        createWidthForImageCaption();
        expandCommentTextArea();
        expandReplyTextArea();
        toggleAdoptionStatusModal();
    }

    $document.on('turbolinks:load', executePracticeCommentsFunctions);
})(window.jQuery);

function seeMoreText() {
    var dots = document.getElementById("dots");
    var moreText = document.getElementById("more_text");
    var btnText = document.getElementById("seeMore");
    var originFacilityTruncated = document.getElementById("origin_facility_truncated");
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        originFacilityTruncated.style.display = "inline";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        originFacilityTruncated.style.display = "none";
        moreText.style.display = "inline";
    }
}
function seeMoreTextAwards() {
    var dots = document.getElementById("dots_award");
    var moreText = document.getElementById("more_text_award");
    var btnText = document.getElementById("seeMore_award");
    var awardsTruncated = document.getElementById("awards_truncated");
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        moreText.style.display = "none";
        awardsTruncated.style.display = "inline";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        awardsTruncated.style.display = "none";
        moreText.style.display = "inline";
    }
}

function seeMoreSearchTermsMobile() {
    var btnText = document.getElementById("seeMore_search_terms_mobile");
    var termsTruncated = document.getElementById("search_terms_truncated_mobile");

    if (termsTruncated.style.display === "none") {
        btnText.innerHTML = "See less";
        termsTruncated.style.display = "inline";
    } else {
        btnText.innerHTML = "See more";
        termsTruncated.style.display = "none";
    }
}

function seeMoreSearchTermsDesktop() {
    var btnText = document.getElementById("seeMore_search_terms_desktop");
    var termsTruncated = document.getElementById("search_terms_truncated_desktop");

    if (termsTruncated.style.display === "none") {
        btnText.innerHTML = "See less";
        termsTruncated.style.display = "inline";
    } else {
        btnText.innerHTML = "See more";
        termsTruncated.style.display = "none";
    }
}

function seeMoreStatementText(dotsSection, moreStatementText, buttonText, statementTruncated) {
    var dots = document.getElementById(dotsSection.id);
    var moreText = document.getElementById(moreStatementText.id);
    var btnText = document.getElementById(buttonText.id);
    var originFacilityTruncated = document.getElementById(statementTruncated.id);
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        originFacilityTruncated.style.display = "inline";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        originFacilityTruncated.style.display = "none";
        moreText.style.display = "inline";
    }
}

function seeMoreTextOriginStory() {
    let dots = document.getElementById("dots_origin_story");
    let moreText = document.getElementById("more_text_origin_story");
    let btnText = document.getElementById("seeMore_origin_story");
    let textTruncated = document.getElementById("origin_story_truncated");
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        moreText.style.display = "none";
        textTruncated.style.display = "inline";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        textTruncated.style.display = "none";
        moreText.style.display = "inline";
    }
}