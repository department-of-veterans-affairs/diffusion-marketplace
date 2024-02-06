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

function debounce(func, wait, immediate) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        var later = function() {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
}

function setupSearchDropdown(formId) {
    const searchInput = $(`${formId} .usa-input`);
    const dropdown = $('#search-dropdown');

    const allCategoriesString = $('.homepage-search').attr('data-categories');
    const allCategories = allCategoriesString ? allCategoriesString.match(/[^",\[\]]+/g) : [];
    const mostPopularCategories = allCategories ? allCategories.slice(0, 3) : [];

    searchInput.focus(function() {
        dropdown.show();
        searchInput.attr('aria-expanded', 'true');
    });

    searchInput.on('input', debounce(function() {
        let searchTerm = searchInput.val().toLowerCase();
        let filteredCategories = searchTerm ? allCategories.filter(category => category.toLowerCase().includes(searchTerm)) : mostPopularCategories;
        updateDropdown(filteredCategories);
    }, 300));

    $(document).on('click', function(event) {
        if (!$(event.target).closest(`${formId}, #search-dropdown`).length) {
            dropdown.hide();
            searchInput.attr('aria-expanded', 'false');
        }
    });

    $(document).on('focusin', function(event) {
        if (!$(event.target).closest(`${formId}, #search-dropdown`).length) {
            dropdown.hide();
            searchInput.attr('aria-expanded', 'false');
        }
    });

    $(document).keydown(function(e) {
        if (searchInput.attr('aria-expanded') === 'true') {
            const items = $('#search-dropdown .category-item a, #search-dropdown .public-sans.text-bold');
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
}

function updateDropdown(categories) {
    let categoryList = $('#category-list');
    categoryList.empty();
    categories.forEach(function(category) {
        let link = $('<a></a>').attr('href', `/search?category=${encodeURIComponent(category)}`).text(category).addClass('public-sans');
        link.attr('role', 'option')
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
