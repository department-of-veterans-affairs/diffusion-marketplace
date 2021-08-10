(($) => {
  const $document = $(document);
  const catBtn = ".js-category-tag";
  const seeAllBtn = '.dm-see-all-btn';

  function setSortDefault() {
    $('#dm_sort_option').val('a_to_z');
  }

  function attachCategoryBtnEventListener() {
    $(catBtn).on('click', function(e) {
      if ($(e.target).hasClass("dm-tag--big--action-primary--selected")) {
        $(e.target).removeClass("dm-tag--big--action-primary--selected");
        $(e.target).addClass("dm-tag--big--action-primary");
      } else {
        $(e.target).removeClass("dm-tag--big--action-primary");
        $(e.target).addClass("dm-tag--big--action-primary--selected");
      }
    })
  }

  function attachShowAllCategoriesEventListener() {
    $(seeAllBtn).on('click', function(e) {
      $('.dm-see-more').removeClass('display-none');
      $(e.target).addClass('display-none');
    })
  }

  function setExplorePage () {
    setSortDefault();
    attachCategoryBtnEventListener();
    attachShowAllCategoriesEventListener();
  }

  $document.on('turbolinks:load', setExplorePage);
})(window.jQuery);
