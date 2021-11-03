(($) => {
  const $document = $(document);

  function detectChrome() {
    return /chrome/.test(navigator.userAgent.toLowerCase());
  }

  function browsePageBuilderPageHappy() {
    var has_warning_banner = chromeWarning

    if (!detectChrome() && !$('.browsehappy').length && has_warning_banner == true) {
      pageChromeWarningBanner();
    }
  }

  function removeBottomMarginFromLastAccordionHeading() {
    var accordionHeading = '.usa-accordion__heading';
    $(accordionHeading).last().removeClass('margin-bottom-2');
    $(accordionHeading).last().addClass('margin-bottom-0');
  }

  function containerizeSubpageHyperlinkCards() {
      var cardClass = 'pb-link-card';
      var cardContainerClass = 'pb-two-column-card-link-container';

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

  function execPageBuilderFunctions() {
    browsePageBuilderPageHappy();
    removeBottomMarginFromLastAccordionHeading();
    containerizeSubpageHyperlinkCards();
  }

  $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);
