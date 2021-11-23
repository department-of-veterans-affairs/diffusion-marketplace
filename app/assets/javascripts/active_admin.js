//= require rails-ujs
//= require chartkick
//= require Chart.bundle
//= require active_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input

const CHARACTER_COUNTER_VALID_COLOR =  '#a9aeb1';
const CHARACTER_COUNTER_INVALID_COLOR = '#e52207';
const MAX_DESCRIPTION_LENGTH = 140;

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
      return $(
        "#" + $(select).val() + "_poly_" + $(select).data("component-id")
      ).show();
    });
  };

  function addPageDescriptionCharacterCounterText() {
      let hintEle = $('#page_description').next();
      $(hintEle).append(' <span class="page-description-character-counter">(0/140 characters)</span>');
  }

  function getPageDescriptionCharacterCountOnPageLoad() {
      let descriptionInput = $('#page_description');

      let characterCounterEle = $('.page-description-character-counter');
      $(characterCounterEle).css('color', CHARACTER_COUNTER_VALID_COLOR);

      let descriptionCurrentLength = descriptionInput.val().length;
      let characterCounterText = '(' + descriptionCurrentLength + '/' + MAX_DESCRIPTION_LENGTH + ' characters)';

      characterCounterEle.text(characterCounterText);

      if (descriptionCurrentLength === MAX_DESCRIPTION_LENGTH) {
          characterCounterEle.css('color', CHARACTER_COUNTER_INVALID_COLOR);
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

  var ready = function () {
    loadComponents();
    setDashboardPanelTooltipTitle();
    setColHeaderTooltipTitle();
    addPageDescriptionCharacterCounterText();
    getPageDescriptionCharacterCountOnPageLoad();
    pageDescriptionCharacterCounter();

  $("#practice_retired").click(function() {
      var practiceRetired = document.getElementById("practice_retired").checked;
      var htmlContent = document.getElementsByClassName("ql-editor");
      if (!practiceRetired){
          if(htmlContent.length > 0){
              htmlContent[0].innerHTML = "";
          }
          $(".ql-editor").attr('contenteditable', false);
      }
      else{
          $(".ql-editor").attr('contenteditable', true);
      }
  });
    // switches out polymorphic forms in page component
    $(document).on("change", ".polyselect", function () {
      $(".polyform.component-" + $(this).data("component-id")).hide();
      return $(
        "#" + $(this).val() + "_poly_" + $(this).data("component-id")
      ).show();
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


