function executePracticeSearch(formId) {
    $(formId).submit(function(e) {
        e.preventDefault();
        let searchField = $(e.target).find(".usa-input")
        let sUrl = `${location.protocol}//${location.host}/search`;
        if(searchField.val()) {
            sUrl += `?query=${encodeURI(searchField.val())}`;
        }
        searchField.val(''); // clear form
        window.location = sUrl;
    });
}

function setupSearchDropdown(formId) {
    const searchInput = $(`${formId} .usa-input`);
    const dropdown = $('#search-dropdown');

    const allCategoriesString = $('.homepage-search').attr('data-categories');
    const allCategories = allCategoriesString ? allCategoriesString.match(/[^",\[\]]+/g) : [];
    const mostPopularCategories = allCategories ? allCategories.slice(0, 3) : [];

    searchInput.focus(function() {
        dropdown.show();
    });

    searchInput.on('input', function() {
        let searchTerm = $(this).val().toLowerCase();
        let filteredCategories = searchTerm ? allCategories.filter(category =>
            category.toLowerCase().includes(searchTerm)) : mostPopularCategories;
        updateDropdown(filteredCategories);
    });

    function hideDropdownOutsideClickOrFocus(event) {
        if (!$(event.target).closest(`${formId}, #search-dropdown`).length) {
            dropdown.hide();
        }
    }

    $(document).on('click', hideDropdownOutsideClickOrFocus);
    $(document).on('focusin', hideDropdownOutsideClickOrFocus);
}

function updateDropdown(categories) {
    let categoryList = $('#category-list');
    categoryList.empty();

    categories.forEach(function(category) {
        let link = $('<a></a>').attr('href', `/search?category=${encodeURIComponent(category)}`).text(category).addClass('public-sans');
        let listItem = $('<li></li>').addClass('category-item padding-bottom-1').append(link);

        categoryList.append(listItem);
    });
}

addEventListener('turbolinks:load', function () {
    if ($('#dm-homepage-search-button').length > 0) {
        setupSearchDropdown('#dm-homepage-search-form');
    }
    executePracticeSearch('#dm-navbar-search-desktop-form');
    executePracticeSearch('#dm-navbar-search-mobile-form');
    executePracticeSearch('#dm-homepage-search-form');
});
