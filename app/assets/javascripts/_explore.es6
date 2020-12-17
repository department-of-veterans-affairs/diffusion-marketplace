(($) => {
  const $document = $(document);
  const catBtn = '.dm-category-btn';
  const seeAllBtn = '.dm-see-all-btn';

  function setSortDefault() {
    $('#dm_sort_option').val('a_to_z');
  }

  function attachCategoryBtnEventListener() {
    $(catBtn).on('click', function(e) {
      if ($(e.target).hasClass('dm-selected')) {
        $(e.target).removeClass('dm-selected usa-button');
        $(e.target).addClass('usa-button--outline');
      } else {
        $(e.target).addClass('dm-selected usa-button');
        $(e.target).removeClass('usa-button--outline');
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
