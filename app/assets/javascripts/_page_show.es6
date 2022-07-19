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

    function isImageLink(link){
        return link.find("img").length > 0
    };

    function isButton(link){
        return link.hasClass("usa-button") || link.is("[class*='btn']") || link.is("[class*='button']");
    }

    function isIcon(link){
        return link.children("i").length > 0;
    }

    function isPracticeLink(link){
        return link.hasClass("dm-practice-link");
    }

    // Remediate internal links on old PageBuilder pages
    function remediateInternalLinksTarget(){
        let intLinks = $('.dm-page-content').find("a[href*='marketplace.va.gov'], a[href^='/']");

        intLinks.each(function(){
            let currentLink = $(this);
            // Add USWDS link styling text links only
            if (!isImageLink(currentLink) && !isButton(currentLink) && !isIcon(currentLink) && !isPracticeLink(currentLink)){
                currentLink.addClass("usa-link");
            }

            // Remediate any internal links created by 'Open link in: New Window'
            if (currentLink.is("[target='_blank']")){
                currentLink.attr("target","")
            }
        })
    }

    // Style PageBuilder external links and set to open in a new tab (508 accessibility)
    function identifyExternalLinks() {
        // identify external by HREF content
        let extLinks = $('.dm-page-content').find("a:not([href*='marketplace.va.gov'])").not("[href^='/']");
        
        extLinks.each(function() {
            let currentLink = $(this);

            // Open in a new tab
            currentLink.attr("target", "_blank");

            // Do not apply visual styling to buttons and links
            if ( !isImageLink(currentLink) && !isButton(currentLink) ) {
                currentLink.addClass("usa-link usa-link--external");
            }
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

