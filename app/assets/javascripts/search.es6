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
    const allCategories = JSON.parse(allCategoriesString) || [];
    const mostPopularCategories = allCategories.slice(0, 3);

    searchInput.focus(function() {
        dropdown.show();
    });

    searchInput.on('input', function() {
        let searchTerm = $(this).val().toLowerCase();
        let filteredCategories;
        if (searchTerm) {
            // return top 3 categories by popularity that contain search term as substring
            filteredCategories = allCategories
                .filter(([categoryName, _]) => categoryName.toLowerCase().includes(searchTerm))
                .sort((a, b) => b[1] - a[1])
                .slice(0, 3);
        } else {
            filteredCategories = mostPopularCategories;
        }
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

    categories.forEach(function([category, _]) {
        let linkText = `${category}`;
        let link = $('<a></a>').attr('href', `/search?category=${encodeURIComponent(category)}`).text(linkText).addClass('public-sans');
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
