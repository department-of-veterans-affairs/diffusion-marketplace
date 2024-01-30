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
    const popularCategoriesString = $('.homepage-search').attr('data-popular-categories');

    const allCategories = allCategoriesString ? allCategoriesString.match(/[^",\[\]]+/g) : [];
    const popularCategories = popularCategoriesString ? popularCategoriesString.match(/[^",\[\]]+/g) : [];

    searchInput.focus(function() {
        updateDropdown(popularCategories);
        dropdown.show();
    });

    searchInput.on('input', function() {
        let searchTerm = $(this).val().toLowerCase();
        let filteredCategories = searchTerm ? allCategories.filter(category =>
            category.toLowerCase().includes(searchTerm)) : popularCategories;
        updateDropdown(filteredCategories);
    });

    $(document).click(function(event) {
        if (!$(event.target).closest(`${formId}, #search-dropdown`).length) {
            dropdown.hide();
        }
    });
}

function updateDropdown(categories) {
    let categoryList = $('#category-list');
    categoryList.empty();

    categories.forEach(function(category) {
        let listItem = $(`<li class="category-item">${category}</li>`);
        categoryList.append(listItem);
    });
}

$(document).on('click', '.category-item', function() {
    let category = $(this).text().trim();
    window.location.href = `/search?category=${encodeURIComponent(category)}`;
});

addEventListener('turbolinks:load', function () {
    setupSearchDropdown('#dm-homepage-search-form');
    executePracticeSearch('#dm-navbar-search-desktop-form');
    executePracticeSearch('#dm-navbar-search-mobile-form');
    executePracticeSearch('#dm-homepage-search-form');
});
