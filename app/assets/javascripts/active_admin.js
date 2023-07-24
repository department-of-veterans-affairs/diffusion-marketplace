//= require rails-ujs
//= require chartkick
//= require Chart.bundle
//= require active_admin/base
//= require arrive.min
//= require tinymce
//= require ./practice_editor_utilities

const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
const MAX_DESCRIPTION_LENGTH = 140;
const pageComponentNames = [
    'PageAccordionComponent',
    'PageBlockQuoteComponent',
    'PageCtaComponent',
    'PageDownloadableFileComponent',
    'PageEventComponent',
    'PageHeader2Component',
    'PageHeader3Component',
    'PageHrComponent',
    'PageImageComponent',
    'PageMapComponent',
    'PageNewsComponent',
    'PageOneToOneImageComponent',
    'PageParagraphComponent',
    'PagePublicationComponent',
    'PagePracticeListComponent',
    'PageSimpleButtonComponent',
    'PageSubpageHyperlinkComponent',
    'PageTripleParagraphComponent',
    'PageTwoToOneImageComponent',
    'PageYouTubePlayerComponent'
];

(function () {
    var PANEL_TOOLTIPS = {
        "dm-new-users-by-month":
            "Number of first time visitors to the site by month",
        "dm-user-visits-by-month":
            "Number of unique user visits to the site by month",
        "dm-practice-views-leaderboard":
            "Most to least number of practice page views sorted by practice with the most views this month",
        "dm-custom-page-traffic":
            "Includes only the landing page of the custom page (excludes subpages)"
    };

    var COL_HEADER_TOOLTIPS = {
        "col-total_lifetime_views":
            "Total number of practice page views for each practice",
        "col-term": "Search entry",
        "col-lifetime": "Total number of times term has been searched",
        "col-unique_visitors_last_month":
            "Number of distinct IP addresses that visited the site in the previous month",
        "col-number_of_page_views_last_month":
            "Number of page views by new and returning users in the previous month",
        "col-total_accounts_all-time": "Total number of users",
        "col-total_practices_created":
            "Number of enabled and published practice pages on the site",
        "col-unique_visitors_custom_page":
            "Number of distinct IP addresses that visited the landing page of each custom page in the previous month",
        "col-page_views_custom_page":
            "Number of landing page views for each custom page by new and returning users in the previous month",
        "col-total_views_custom_page":
            "Total number of landing page views for each custom page",
    };

    // sets the `title` attribute for the `h3`s on the `panel` class on `/admin/dashboard` page
    var setDashboardPanelTooltipTitle = function () {
        var $panels = $(".dm-panel-container");
        $panels.each(function (index, panel) {
            var panelId = $(panel).attr("id");
            $("#" + panelId)
                .find("h3")
                .attr({"title": PANEL_TOOLTIPS[panelId], "class": "dm-tooltip"});
        });
    };

    // sets `title` for table column headers on `/admin/dashboard` page
    var setColHeaderTooltipTitle = function () {
        Object.keys(COL_HEADER_TOOLTIPS).map(function (key, index) {
            $('table').each(function() {
                if (!$(this).hasClass('total-search-counts')) {
                    $(this).find("." + key).first().contents().wrap('<span title="' + COL_HEADER_TOOLTIPS[key] + '" class="dm-tooltip"></span>');
                }
            });
        });

        $('.total-search-counts').find('th').last().contents().wrap('<span title="Total number of times the search functionality has been utilized across all pages" class="dm-tooltip"></span>');
    };

    var loadComponents = function () {
        var selects = $(".polyform")
            .siblings("li.select.input")
            .find(".polyselect");
        $.each(selects, function (index, select) {
            const componentName = $(select).val();
            // Only show the component form if the select value is a valid page component name
            if (pageComponentNames.includes(componentName)) {
                return $(
                    "#" + componentName + "_poly_" + $(select).data("component-id")
                ).show();
            }
        });
    };

    // the 'maximum length' validation in rails automatically adds the 'maxlength' attr on any corresponding page description input, but we want the user to have the freedom to exceed that number
    function removeMaxLengthAttrFromPageDescription() {
        $('#page_description').removeAttr('maxLength');
    }

    function addPageDescriptionCharacterCounterText() {
        let hintEle = $('#page_description').next();
        $(hintEle).append(' <span class="page-description-character-counter">(0/140 characters)</span>');
    }

    function getPageDescriptionCharacterCountOnPageLoad() {
        let descriptionInput = $('#page_description');
        let characterCounterEle = $('.page-description-character-counter');
        if (descriptionInput.length > 0 && characterCounterEle.length > 0) {
            $(characterCounterEle).css("color", CHARACTER_COUNTER_VALID_COLOR);

            let descriptionCurrentLength = descriptionInput.val().length;
            let characterCounterText =
                "(" +
                descriptionCurrentLength +
                "/" +
                MAX_DESCRIPTION_LENGTH +
                " characters)";

            characterCounterEle.text(characterCounterText);

            if (descriptionCurrentLength >= MAX_DESCRIPTION_LENGTH) {
                characterCounterEle.css("color", CHARACTER_COUNTER_INVALID_COLOR);
            }
        }

    }

    function pageDescriptionCharacterCounter() {
        $(document).on('input', '#page_description', function() {
            let currentLength = $(this).val().length;

            let characterCounterEle = $('.page-description-character-counter');
            let characterCounterText  = '(' + currentLength + '/' + MAX_DESCRIPTION_LENGTH + ' characters)';

            characterCounterEle.css('color', CHARACTER_COUNTER_VALID_COLOR);
            characterCounterEle.text(characterCounterText);

            if (currentLength >= MAX_DESCRIPTION_LENGTH) {
                characterCounterEle.css('color', CHARACTER_COUNTER_INVALID_COLOR);
            }
        });
    }
    function _modifySubmitBtnIDonPageBuilder() {
        $('.input_action').each(function(i, e) {
            e.id = e.id + '_' + i;
            $('#' + e.id + ' input').attr('name', 'commit_' + i);
        })
    }

    function _initTinyMCE(selector) {
        tinymce.init({
            selector: selector,
            menubar: false,
            plugins: ["link", "lists"],
            toolbar:
                'undo redo | styleselect | bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | forecolor backcolor | link bullist numlist superscript subscript | outdent indent | removeformat',
            link_title: false,
            link_assume_external_targets: false
        });
    }

    function _addTinyMCEOnSelection() {
        $(document).change('.polyselect', function(e) {
            var componentType = $(e.target).val();
            var componentId = $(e.target).data('componentId');
            var typeText;
            if (componentType === 'PageAccordionComponent') {
                typeText = 'accordion';
            } else if (componentType === 'PageParagraphComponent' || componentType === 'PageTripleParagraphComponent') {
                typeText = 'paragraph';
            }
            var componentTextareaId = '#page_page_components_attributes_' + typeText + '_' + componentId + '_component_attributes_text'
            if (
                componentType === 'PageAccordionComponent' || 
                componentType === 'PageParagraphComponent' || 
                componentType === 'PageTripleParagraphComponent' || 
                componentType === 'PageBlockQuoteComponent' || 
                componentType === 'PageTwoToOneImageComponent' ||
                componentType === 'PageOneToOneImageComponent'
            ) {
                _initTinyMCE(componentTextareaId);
            }
        })
    }

    function _initializeTinyMCEOnDragAndDrop() {
        $(document).on('mouseup', '.handle', function(e) {
            const wysiwygComponents = ['PageAccordionComponent',  
                                       'PageParagraphComponent', 
                                       'PageTripleParagraphComponent', 
                                       'PageBlockQuoteComponent',
                                       'PageTwoToOneImageComponent',
                                       'PageOneToOneImageComponent'];
            var componentType = $(e.target).closest('ol').find('.polyselect').val();

            if (wysiwygComponents.includes(componentType)) {
                var textareaContainer = $(e.target).closest('ol').find(`.polyform[style*='list-item']`);

                $(textareaContainer).find('textarea.tinymce').each(function() {
                    const textAreaId = $(this).attr('id');
                    tinymce.get(textAreaId).remove();
                    _initTinyMCE('#' + textAreaId);
                });
            }
        })
    }

    // Remove content creator's ability to choose whether
    // links open in a new tab or current tab
    function _modifyTinyMCELinkEditor() {
        $(document).arrive('.tox-dialog__title', function(e) {
            if ($('.tox-dialog__title').text() == "Insert/Edit Link" ) {
                var UrlField = $('.tox-form label:contains("URL")');
                UrlField.append('<span class="inline-hints">(For external URLs, use full URL i.e. https://google.com)</span>');
                var openLinkInDropdown = $('.tox-label:contains("Open link in")').parent();
                openLinkInDropdown.css("display","none");
            }
        })
    }

    function _loadPageBuilderFns() {
        var $body = $('body');
        if ($body.hasClass('admin_pages') && $body.hasClass('edit')) {
            _addTinyMCEOnSelection();
            _initializeTinyMCEOnDragAndDrop();
            _modifyTinyMCELinkEditor();
            _modifySubmitBtnIDonPageBuilder();
        }
    }

    function removeIdFromTrElements() {
        // remove ids from tr elements for certain pages of the admin panel because it results in duplicate ids
        let adminPathNames = ['/admin', '/admin/site_metrics', '/admin/innovation_views_leaderboard', '/admin/innovation_search_terms'];
        let currentPathName = window.location.pathname.endsWith('/') ? window.location.pathname.slice(0, -1) : window.location.pathname

        if (adminPathNames.includes(currentPathName)) {
            $('tr').each(function () {
                $(this).removeAttr('id');
            })
        }
    }

    function appendLiHTMLToList(targetOl, liHTML) {
        return $(targetOl).append(liHTML);
    }

    function initTinyMCEOnTextAreaArrival() {
        $(document).arrive('textarea.tinymce', function() {
            let textareaId = $(this).attr('id');
            _initTinyMCE(`#${textareaId}`);
        });
    }

    var ready = function () {
        loadComponents();
        setDashboardPanelTooltipTitle();
        setColHeaderTooltipTitle();
        removeMaxLengthAttrFromPageDescription();
        addPageDescriptionCharacterCounterText();
        getPageDescriptionCharacterCountOnPageLoad();
        pageDescriptionCharacterCounter();
        _initTinyMCE("textarea.tinymce");
        _loadPageBuilderFns();
        removeIdFromTrElements();
        initTinyMCEOnTextAreaArrival();

        // switches out polymorphic forms in page component
        $(document).on("change", ".polyselect", function () {
            $(".polyform.component-" + $(this).data("component-id")).hide();
            const componentName = $(this).val();
            // Only show the component form if the select value is a valid page component name
            if (pageComponentNames.includes(componentName)) {
                return $(
                    "#" + componentName + "_poly_" + $(this).data("component-id")
                ).show();
            }
        });

        // when form is submitted, purges any page component form that is not used on the page
        return $(document).on("submit", "form", function (e) {
            return $(".polyform").each(
                (function (_this) {
                    return function (index, element) {
                        var $e = $(element);
                        if ($e.css("display") !== "list-item") {
                            return $e.remove();
                        }
                    };
                })(this)
            );
        });
    };

    $(document).ready(ready);

    $(document).on("turbolinks:load", ready);
}).call(this);


