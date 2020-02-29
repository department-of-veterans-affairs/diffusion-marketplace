(($) => {
    const $document = $(document);

    function findNext(key, obj) {
        let keys = Object.keys(obj);
        return keys[(keys.indexOf(key) + 1)];
    }
    
    function highlightSidebarSectionWhenInView() {
        const SECTIONS = {
            '#overview': '.sidebar-overview',
            '#origin': '.sidebar-origin',
            '#impact': '.sidebar-impact',
            '#resources_required': '.sidebar-resources',
            '#complexity': '.sidebar-complexity',
            '#timeline_and_checklist': '.sidebar-timeline',
            '#risk_and_mitigation': '.sidebar-risk-miti',
            '#contact': '.sidebar-contact',
            '#comments': '.sidebar-comments',
        };
        let hoverCss = {
            'font-weight': 'bold',
            'border-left': '4px solid #005EA2',
            'color': 'black',
            'background-color': 'transparent'
        };
        let nonHoverCss = {
            'font-weight': 'normal',
            'border-left': 'none',
            'color': 'none',
            'background-color': 'transparent'
        };
        $(window).on('scroll', function() {
            let viewportTop = $(window).scrollTop();
            let activeItem = false;
            Object.keys(SECTIONS).forEach(function(s) {
                let sectionPosition = $(s).offset().top + (-50);
                let nextSection = findNext(s, SECTIONS);
                if (nextSection) {
                    let nextSectionPosition = $(nextSection).offset().top + (-50);
                    if (viewportTop >= sectionPosition && viewportTop < nextSectionPosition && !activeItem) {
                        $(SECTIONS[s]).css(hoverCss);
                        activeItem = true;
                    } else {
                        $(SECTIONS[s]).css(nonHoverCss);
                    }
                } else if (viewportTop >= sectionPosition && !activeItem){
                    $(SECTIONS[s]).css(hoverCss);
                    activeItem = true;
                } else {
                    $(SECTIONS[s]).css(nonHoverCss);
                }
            });
        })
    }


    function showMoreOrLessOfACommentOnPageLoad() {
        let showChar = 300;
        let ellipsesText = "...";
        let moreText = '&nbsp;' + 'See more' + ' <i class="fas fa-angle-down show-arrow display-inline-block"></i>';
        let lessText = '&nbsp;' + 'See less' + ' <i class="fas fa-angle-up show-arrow display-inline-block"></i>';

        $('.more').find('p').each(function () {
            let content = $(this).html();

            if (content.length > showChar) {

                let c = content.substr(0, showChar);
                let h = content.substr(showChar - 1, content.length - showChar);

                let html = c + '<span class="more-ellipses">' + ellipsesText + '&nbsp;</span><span class="more-content"><span>' + h + '</span><a href="" class="more-link display-inline-block">' + moreText + '</a></span>';

                $(this).html(html);
            }

        });

        $(".more-link").click(function () {
            if ($(this).hasClass("less")) {
                $(this).removeClass("less");
                $(this).html(moreText);
            } else {
                $(this).addClass("less");
                $(this).html(lessText);
            }
            $(this).parent().prev().toggle();
            $(this).prev().toggle();
            return false;
        });
    }

    function showMoreOrLessOfACommentOfNewlyAdded() {
        let showChar = 300;
        let ellipsesText = "...";
        let moreText = '&nbsp;' + 'See more' + ' <i class="fas fa-angle-down show-arrow display-inline-block"></i>';
        let lessText = '&nbsp;' + 'See less' + ' <i class="fas fa-angle-up show-arrow display-inline-block"></i>';

        $(document).arrive(".more", (newElem) => {
            $(newElem).find('p').each(function() {
                let content = $(this).html();

                if (content.length > showChar) {

                    let c = content.substr(0, showChar);
                    let h = content.substr(showChar - 1, content.length - showChar);

                    let html = c + '<span class="more-ellipses">' + ellipsesText + '&nbsp;</span><span class="more-content"><span>' + h + '</span><a href="" class="more-link display-inline-block">' + moreText + '</a></span>';

                    $(this).html(html);
                }

            });

            $(".more-link").click(function () {
                if ($(this).hasClass("less")) {
                    $(this).removeClass("less");
                    $(this).html(moreText);
                } else {
                    $(this).addClass("less");
                    $(this).html(lessText);
                }
                $(this).parent().prev().toggle();
                $(this).prev().toggle();
                return false;
            });
        });
    }

    function showMoreOrLessOfACommentOnEdit() {
        let showChar = 300;
        let ellipsesText = "...";
        let moreText = '&nbsp;' + 'See more' + ' <i class="fas fa-angle-down show-arrow display-inline-block"></i>';
        let lessText = '&nbsp;' + 'See less' + ' <i class="fas fa-angle-up show-arrow display-inline-block"></i>';

        $document.find('.comment-submit').each(function() {
            $('.more').find('p').each(function () {
                let content = $(this).html();

                if (content.length > showChar) {

                    let c = content.substr(0, showChar);
                    let h = content.substr(showChar - 1, content.length - showChar);

                    let html = c + '<span class="more-ellipses">' + ellipsesText + '&nbsp;</span><span class="more-content"><span>' + h + '</span><a href="" class="more-link display-inline-block">' + moreText + '</a></span>';

                    $(this).html(html);
                }

            });

            $(".more-link").click(function () {
                if ($(this).hasClass("less")) {
                    $(this).removeClass("less");
                    $(this).html(moreText);
                } else {
                    $(this).addClass("less");
                    $(this).html(lessText);
                }
                $(this).parent().prev().toggle();
                $(this).prev().toggle();
                return false;
            });
        });
    }

    function showMoreOrLessOfACommentOnCancel() {
        let showChar = 300;
        let ellipsesText = "...";
        let moreText = '&nbsp;' + 'See more' + ' <i class="fas fa-angle-down show-arrow display-inline-block"></i>';
        let lessText = '&nbsp;' + 'See less' + ' <i class="fas fa-angle-up show-arrow display-inline-block"></i>';

        $document.find('.comment-cancel').each(function() {
            $(this).on('click', function() {
                $('.more').find('p').each(function () {
                    let content = $(this).html();

                    if (content.length > showChar) {

                        let c = content.substr(0, showChar);
                        let h = content.substr(showChar - 1, content.length - showChar);

                        let html = c + '<span class="more-ellipses">' + ellipsesText + '&nbsp;</span><span class="more-content"><span>' + h + '</span><a href="" class="more-link display-inline-block">' + moreText + '</a></span>';

                        $(this).html(html);
                    }

                });

                $(".more-link").click(function () {
                    if ($(this).hasClass("less")) {
                        $(this).removeClass("less");
                        $(this).html(moreText);
                    } else {
                        $(this).addClass("less");
                        $(this).html(lessText);
                    }
                    $(this).parent().prev().toggle();
                    $(this).prev().toggle();
                    return false;
                });
            });
        });
    }

    function executePracticeCommentsFunctions() {
        highlightSidebarSectionWhenInView();
        showMoreOrLessOfACommentOnPageLoad();
        showMoreOrLessOfACommentOfNewlyAdded();
        showMoreOrLessOfACommentOnEdit();
        showMoreOrLessOfACommentOnCancel();
    }

    $document.on('turbolinks:load', executePracticeCommentsFunctions);
})(window.jQuery);