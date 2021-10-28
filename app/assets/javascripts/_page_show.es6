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

  function execPageBuilderFunctions() {
    browsePageBuilderPageHappy();
    removeBottomMarginFromLastAccordionHeading();
  }

  $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);
