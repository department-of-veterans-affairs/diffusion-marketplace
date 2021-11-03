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

    // due to the breadcrumbs being rendered before everything else, move them into the gradient banner for page-builder pages, if the title and description are visible
        function relocateAndStyleBreadcrumbs() {
        let breadcrumbContainer = '.breadcrumbs-container';
        let breadcrumb = '.usa-breadcrumb__list-item';
        if (!$('.page-builder-intro-container').hasClass('display-none')) {
            $(breadcrumbContainer).parent().prependTo('.page-builder-intro-content');
            $(breadcrumbContainer).parent().removeClass('grid-container');
            $(breadcrumbContainer).addClass('text-white padding-top-0 padding-bottom-1');
            $(breadcrumb).first().find('a').addClass('dm-alt-link-white');
        }
    }

    function execPageBuilderFunctions() {
        browsePageBuilderPageHappy();
        removeBottomMarginFromLastAccordionHeading();
        relocateAndStyleBreadcrumbs();
    }

    $document.on('turbolinks:load', execPageBuilderFunctions);
})(window.jQuery);
