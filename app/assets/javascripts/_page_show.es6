const COMPONENT_CLASSES = [
    '.page-paragraph-component',
    '.page-accordion-component',
    '.page-compound-body-component',
    '.page-event-component p',
    '.page-news-component p',
    '.page-map-component p'
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

    function containerizeSubpageHyperlinkCards() {
      let cardClass = 'pb-link-card';
      let cardContainerClass = 'pb-two-column-card-link-container';

      function addContainerAndAppendElements(container, containerClass, elementOne, elementTwo) {
          if (!elementOne.parent().hasClass(containerClass) || !elementTwo.parent().hasClass(containerClass)) {
                elementOne.before(container);
                elementOne.prev().append(elementOne, elementTwo);
                elementOne.parent().parent().next().remove()
          }
      }

      $('.dm-page-content').children().each(function() {
          let $this = $(this);
          // refactored to use individual grid-container divs which means expected classes are
          // now one layer deeper
          let currEle = $this.children().first()
          let prevEle = $this.prev().children().first();
          let nextEle = $this.next().children().first();
          let containerDiv = "<div class='pb-two-column-card-link-container grid-row grid-gap-3'></div>";

          if (currEle.hasClass(cardClass) && prevEle.hasClass(cardClass)) {
              addContainerAndAppendElements(containerDiv, cardContainerClass, prevEle, currEle);
          } else if (currEle.hasClass(cardClass) && nextEle.hasClass(cardClass)) {
              addContainerAndAppendElements(containerDiv, cardContainerClass, currEle, nextEle);
          } else if (currEle.hasClass(cardClass)) {
              currEle.before(containerDiv);
              currEle.prev().append(currEle);
          }
      });

      // Add bottom margin styles
      $(`.${cardContainerClass}`).each(function() {
          let $this = $(this);
          let lastEle = $('.dm-page-content').children().last()
    
          if (lastEle.is($this.parent())) {
              $this.parent().addClass('margin-bottom-neg-3');
          } else if (!$this.next().hasClass(cardContainerClass)) {
              $this.addClass('margin-bottom-2');
          }
      });
    }

    // Remediate internal links on PageBuilder paragraph and accordion components
    function remediateInternalLinksTarget() {
        let intLinks = $(COMPONENT_CLASSES).find("a[href*='marketplace.va.gov'], a[href^='/'],a[href^='.']");

        intLinks.each(function(){
            // Don't add the USWDS link class to 'PageComponentImage' image links
            if (!$(this).hasClass('page-image-component-image-link')) {
                $(this).addClass("usa-link");
            }
            if ($(this).is("[target='_blank']")) {
                $(this).attr("target","");
            }
        })
    }

    // Style PageBuilder external links and set to open in a new tab (508 accessibility)
    function identifyExternalLinks() {
        // identify external by HREF content
        let extLinks = $(COMPONENT_CLASSES).find("a:not([href*='marketplace.va.gov'])").not("[href^='/']").not("[href^='.']");

        extLinks.each(function() {
            $(this).attr("target", "_blank");
            // Don't add USWDS link classes to 'PageComponentImage' image links
            if (!$(this).hasClass('page-image-component-image-link')) {
                $(this).addClass("usa-link usa-link--external");
            }
        });
    }

    function chromeWorkaroundForAnchorTags(){
        var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
        if (window.location.hash && isChrome) {
            setTimeout(function () {
                var hash = window.location.hash;
                window.location.hash = "";
                window.location.hash = hash;
            }, 300);
        }
    }

    function fetchPageComponentFileResources() {
        const pageComponents = document.querySelectorAll('.page-downloadable-file-component, .page-publication-component');
        // Replace each 'PageDownloadableFileComponent or PagePublicationComp;onent's 'href' with a new signed URL
        pageComponents.forEach(element => {
            const filePath = element.getAttribute('data-resource-path');
            const fileUrl = element.href;
            const fileId = element.getAttribute('data-resource-id');

            fetchSignedResource(
                filePath,
                fileUrl,
                `a[data-resource-id="${fileId}"]`,
                'file'
            );
        });
    }

    function execPageBuilderFunctions() {
        browsePageBuilderPageHappy();
        containerizeSubpageHyperlinkCards();
        remediateInternalLinksTarget();
        identifyExternalLinks();
        chromeWorkaroundForAnchorTags();
        fetchPageComponentFileResources();
    }

    $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);