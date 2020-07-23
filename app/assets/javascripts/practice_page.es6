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
        const moreText = '&nbsp; See more <i class="fas fa-angle-down show-arrow display-inline-block"></i>';
        const lessText = '&nbsp; See less <i class="fas fa-angle-up show-arrow display-inline-block"></i>';
        let t = $(element).text();
        if (t.length < showChar) return;

        $(element).html(
            `
             ${t.slice(0, showChar)}<span>${ellipsesText}</span> <button type="button" class="usa-button usa-button--unstyled more-link text-no-underline">${moreText}</button>
             <span style="display:none;"> ${t.slice(showChar, t.length)} <button type="button" class="usa-button usa-button--unstyled less-link text-no-underline">${lessText}</button></span>
             `
        );
    }

    function setMoreLessHandlers(elements) {
        $('button.more-link', elements).click(function (event) {
            event.preventDefault();
            $(this).hide().prev().hide();
            $(this).next().show();
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

    function executePracticeCommentsFunctions() {
        highlightSidebarSectionWhenInView();
        setUpShowMoreOrLessButtons();
        setUpShowMoreOrLessOnArrive();
    }

    $document.on('turbolinks:load', executePracticeCommentsFunctions);
})(window.jQuery);

function seeMoreText() {
    var dots = document.getElementById("dots");
    var moreText = document.getElementById("more_text");
    var btnText = document.getElementById("seeMore");
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        moreText.style.display = "inline";
    }
}
function seeMoreTextAwards() {
    var dots = document.getElementById("dots_award");
    var moreText = document.getElementById("more_text_award");
    var btnText = document.getElementById("seeMore_award");
    if (dots.style.display === "none") {
        dots.style.display = "inline";
        btnText.innerHTML = "See more";
        moreText.style.display = "none";
    } else {
        dots.style.display = "none";
        btnText.innerHTML = "See less";
        moreText.style.display = "inline";
    }
}