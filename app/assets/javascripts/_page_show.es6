const COMPONENT_CLASSES = [
    '.page-paragraph-component',
    '.page-accordion-component',
    '.page-compound-body-component'
].join(', ');

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

    // Remediate internal links on PageBuilder paragraph and accordion components
    function remediateInternalLinksTarget() {
        let intLinks = $(COMPONENT_CLASSES).find("a[href*='marketplace.va.gov'], a[href^='/'],a[href^='.']");

        intLinks.each(function(){
            let currentLink = $(this);
            currentLink.addClass("usa-link");
            if (currentLink.is("[target='_blank']")) {
                currentLink.attr("target","");
            }
        })
    }

    // Style PageBuilder external links and set to open in a new tab (508 accessibility)
    function identifyExternalLinks() {
        // identify external by HREF content
        let extLinks = $(COMPONENT_CLASSES).find("a:not([href*='marketplace.va.gov'])").not("[href^='/']").not("[href^='.']");
        
        extLinks.each(function() {
            let currentLink = $(this);

            currentLink.attr("target", "_blank");
            currentLink.addClass("usa-link usa-link--external");
        });
    }

    function execPageBuilderFunctions() {
        browsePageBuilderPageHappy();
        removeBottomMarginFromLastAccordionHeading();
        containerizeSubpageHyperlinkCards();
        remediateInternalLinksTarget();
        identifyExternalLinks();
    }

    $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);

