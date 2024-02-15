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

    const allInnovationsString = $('.homepage-search').attr('data-innovations');
    const allInnovations = allInnovationsString ? allInnovationsString.match(/[^",\[\]]+/g) : [];
    const mostRecentInnovations = allInnovations ? allInnovations.slice(0, 3) : [];

    searchInput.focus(function() {
        dropdown.show();
        searchInput.attr('aria-expanded', 'true');
    });

    searchInput.on('input', function() {
        let searchTerm = searchInput.val().toLowerCase();
        let filteredCategories = searchTerm ? allCategories.filter(category =>
            category.toLowerCase().includes(searchTerm)).slice(0,3) : mostPopularCategories;
        let filteredInnovations = searchTerm ? allInnovations.filter(innovation =>
            innovation.toLowerCase().includes(searchTerm)).slice(0,3) : mostRecentInnovations;
        updateDropdown(filteredCategories, filteredInnovations);
    });

    $(document).keydown(function(e) {
        if (searchInput.attr('aria-expanded') === 'true') {
            const items = $('#search-dropdown .search-result a, #search-dropdown .browse-all-link');
            const focusedElement = document.activeElement;
            const focusedIndex = items.index(focusedElement);

            if (e.keyCode === 40 || e.keyCode === 38) {
                e.preventDefault();
                if (e.keyCode === 40 && focusedIndex < items.length - 1) {
                    items.eq(focusedIndex + 1).focus();
                } else if (e.keyCode === 38 && focusedIndex > 0) {
                    items.eq(focusedIndex - 1).focus();
                }
            }
        }
    });

    function hideDropdownOutsideClickOrFocus(event) {
        if (!$(event.target).closest(`${formId}, #search-dropdown`).length) {
            dropdown.hide();
            searchInput.attr('aria-expanded', 'false');
        }
    }

    $(document).on('click', hideDropdownOutsideClickOrFocus);
    $(document).on('focusin', hideDropdownOutsideClickOrFocus);
}

function updateDropdown(categories, innovations) {
    const innovationLinks = JSON.parse($('.homepage-search').attr('data-innovation-links'));
    let categoryList = $('#category-list');
    let innovationList = $('#practice-list');
    $('li').remove('.search-result');

    categories.forEach(function(category) {
        let link = $('<a></a>').attr('href', `/search?category=${encodeURIComponent(category)}`).text(category);
        let listItem = $('<li></li>').addClass('search-result').append(link);

        categoryList.append(listItem);
    });

    innovations.forEach(function(innovation) {
        let link = $('<a></a>').attr('href', `/innovations/${encodeURIComponent(innovationLinks[innovation])}` ).text(innovation);
        let listItem = $('<li></li>').addClass('search-result').append(link);

        innovationList.append(listItem);
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
