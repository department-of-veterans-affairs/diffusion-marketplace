(($) => {
    const $document = $(document);

    function detectChrome() {
    return /chrome/.test(navigator.userAgent.toLowerCase());
    }

    function browsePageBuilderPageHappy() {
        let has_warning_banner = chromeWarning

        if (!detectChrome() && !$('.browsehappy').length && has_warning_banner == true) {
        pageChromeWarningBanner();
        }
    }

    function removeBottomMarginFromLastAccordionHeading() {
        let accordionHeading = '.usa-accordion__heading';
        $(accordionHeading).last().removeClass('margin-bottom-2');
        $(accordionHeading).last().addClass('margin-bottom-0');
    }

    function containerizeSubpageHyperlinkCards() {
      let cardClass = 'pb-link-card';
      let cardContainerClass = 'pb-two-column-card-link-container';

      function addContainerAndAppendElements(container, containerClass, elementOne, elementTwo) {
          if (!elementOne.parent().hasClass(containerClass) || !elementTwo.parent().hasClass(containerClass)) {
                elementOne.before(container);
                elementOne.prev().append(elementOne, elementTwo);
          }
      }

      $('.dm-page-content').children().each(function() {
          let $this = $(this);
          let prevEle = $this.prev();
          let nextEle = $this.next();
          let containerDiv = "<div class='pb-two-column-card-link-container grid-row grid-gap-3'></div>";

          if ($this.hasClass(cardClass) && prevEle.hasClass(cardClass)) {
              addContainerAndAppendElements(containerDiv, cardContainerClass, prevEle, $this);
          } else if ($this.hasClass(cardClass) && nextEle.hasClass(cardClass)) {
              addContainerAndAppendElements(containerDiv, cardContainerClass, $this, nextEle);
          } else if ($this.hasClass(cardClass)) {
              $this.before(containerDiv);
              $this.prev().append($this);
          }
      });

      // Add bottom margin styles
      $(`.${cardContainerClass}`).each(function() {
          let $this = $(this);

          if ($('.dm-page-content').children().last().is($this)) {
              $this.addClass('margin-bottom-neg-3');
          } else if (!$this.next().hasClass(cardContainerClass)) {
              $this.addClass('margin-bottom-2');
          }
      });
    }


    // due to the breadcrumbs being rendered before everything else, move them into the gradient banner for page-builder pages, if the title and description are visible
    function relocateAndStyleBreadcrumb() {
        let breadcrumbContainer = '.breadcrumbs-container';
        let breadcrumb = '.usa-breadcrumb__list-item';

        if (!$('.page-builder-intro-container').hasClass('display-none')) {
            $(breadcrumbContainer).parent().prependTo('.page-builder-intro-content');
            $(breadcrumbContainer).parent().removeClass('grid-container');
            $(breadcrumbContainer).addClass('text-white padding-top-0 padding-bottom-1');
            $(breadcrumb).first().find('a').addClass('dm-alt-link-white');
        } else {
            $(breadcrumbContainer).find('.fa-arrow-left').addClass('text-gray-50');
        }
    }

    function addMarginToPageContentWithNoBreadCrumb() {
        if ($('#breadcrumbs').parent().hasClass('display-none') && $('.page-builder-intro-container').hasClass('display-none')) {
            $('#page-builder-page').addClass('margin-top-10');
        }
    }

    function execPageBuilderFunctions() {
        browsePageBuilderPageHappy();
        removeBottomMarginFromLastAccordionHeading();
        containerizeSubpageHyperlinkCards();
        relocateAndStyleBreadcrumb();
        addMarginToPageContentWithNoBreadCrumb();
    }

    $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);
