(($) => {
    const $document = $(document);

    function showMoreOrLessOfCommentOnLoad() {
        $('.body').each(function(i, ele) {
            if ($(ele).innerHeight() > 60) {
                $(ele).addClass('comment-three-lines')
            }

            else {
                $(ele).next().addClass('hidden')
            }
        });

        $(".show-more button").on("click", function() {
            let $this = $(this);
            let $content = $this.parent().prev('div.body');
            let linkText = $this.text().toUpperCase();

            if (linkText === "SHOW MORE") {
                linkText = "Show less";
                $content.removeClass('comment-three-lines');
            } else {
                linkText = "Show more";
                $content.addClass('comment-three-lines');
            }

            $this.text(linkText);
        });
    }

    function pleaseWork() {

    }

    function showMoreOrLessOfNewlyAddedComment() {
        $document.arrive('.body', function() {
            console.log('hello')
            let newElem = $(this)
            $(newElem).each(function(i, ele) {
                if ($(ele).innerHeight() > 60) {
                    $(ele).addClass('comment-three-lines')
                } else {
                    $(ele).next().addClass('hidden')
                }
            });

            $(".show-more button").on("click", function() {
                let $this = $(this);
                let $content = $this.parent().prev('div.body');
                let linkText = $this.text().toUpperCase();

                if (linkText === "SHOW MORE") {
                    linkText = "Show less";
                    $content.removeClass('comment-three-lines');
                } else {
                    linkText = "Show more";
                    $content.addClass('comment-three-lines');
                }

                $this.text(linkText);
            });
            $document.unbindArrive('.body');
        });
    }

    function showMoreOrLessOfUpdatedComment() {
        $document.on('change', '.body', function() {
            $('.body').each(function (i, ele) {
                if ($(ele).innerHeight() > 60) {
                    $(ele).addClass('comment-three-lines')
                } else {
                    $(ele).next().addClass('hidden')
                }
            });

            $(".show-more button").on("click", function() {
                let $this = $(this);
                let $content = $this.parent().prev('div.body');
                let linkText = $this.text().toUpperCase();

                if (linkText === "SHOW MORE") {
                    linkText = "Show less";
                    $content.removeClass('comment-three-lines');
                } else {
                    linkText = "Show more";
                    $content.addClass('comment-three-lines');
                }

                $this.text(linkText);
            });
        });
    }

    function removeShowMoreOrLessButtonOnEdit() {
        $('.fa-edit').on('click', function(e) {
            let t = e.target;
            console.log(t);
            console.log('hello');
            $(t).closest('div').next().find('div.show-more').addClass('hidden')
        });
    }

    function findNext(key, obj) {
        console.log('obj', obj)
        let keys = Object.keys(obj);
        return keys[(keys.indexOf(key) + 1)];
    }

    function highlightSidebarSectionWhenInView() {
        $(window).on('scroll', function() {
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
            let viewportTop = $(window).scrollTop();
            let activeItem = false;
            Object.keys(SECTIONS).forEach(function(s) {
                console.log(s);
                let sectionPosition = $(s).offset().top;
                let nextSection = findNext(s, SECTIONS);
                if (nextSection) {
                    let nextSectionPosition = $(nextSection).offset().top;
                    if (viewportTop >= sectionPosition && viewportTop < nextSectionPosition && !activeItem) {
                        $(SECTIONS[s]).css(hoverCss);
                        activeItem = true;
                    } else {
                        $(SECTIONS[s]).css(nonHoverCss);
                    }
                } else if(viewportTop >= sectionPosition && !activeItem){
                    $(SECTIONS[s]).css(hoverCss);
                    activeItem = true;
                } else {
                    $(SECTIONS[s]).css(nonHoverCss);
                }
            });
        })
    }


    function executePracticeCommentsFunctions() {
        showMoreOrLessOfCommentOnLoad();
        showMoreOrLessOfNewlyAddedComment();
        showMoreOrLessOfUpdatedComment();
        removeShowMoreOrLessButtonOnEdit();
        highlightSidebarSectionWhenInView();
        findNext();
    }

    $document.on('turbolinks:load', executePracticeCommentsFunctions);
})(window.jQuery);