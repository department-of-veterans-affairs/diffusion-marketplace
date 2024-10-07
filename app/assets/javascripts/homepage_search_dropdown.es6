function setupSearchDropdown() {
    const searchInput = $(`#dm-homepage-search-form .usa-input`);
    const dropdown = $('#search-dropdown');

    const allCategories = JSON.parse($('.homepage-search').attr('data-categories') || '[]');
    const mostPopularCategories = allCategories.slice(0, 2);

    const allInnovations = JSON.parse($('.homepage-search').attr('data-innovations') || '[]');
    const mostRecentInnovations = allInnovations.slice(0, 2);

    const allCommunities = JSON.parse($('.homepage-search').attr('data-communities') || '[]');
    const mostPopularCommunities = allCommunities.slice(0, 2);

    const allProducts = JSON.parse($('.homepage-search').attr('data-products') || '[]');
    const mostRecentProducts = allProducts.slice(0, 2);

    searchInput.focus(function() {
        dropdown.show();
        searchInput.attr('aria-expanded', 'true');
    });

    searchInput.on('input', function() {
        let searchTerm = searchInput.val().toLowerCase();
        let filteredCategories = searchTerm ? allCategories.filter(category => category.name.toLowerCase().includes(searchTerm)).slice(0,2) : mostPopularCategories;
        let filteredInnovations = searchTerm ? allInnovations.filter(innovation => innovation.name.toLowerCase().includes(searchTerm)).slice(0,2) : mostRecentInnovations;
        let filteredCommunities = searchTerm ? allCommunities.filter(community => community.name.toLowerCase().includes(searchTerm)).slice(0,2) : mostPopularCommunities;
        let filteredProducts = searchTerm ? allProducts.filter(product => product.name.toLowerCase().includes(searchTerm)).slice(0,2) : mostRecentProducts;
        updateDropdown(filteredCategories, filteredInnovations, filteredCommunities, filteredProducts);
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

    $(document).on('click', function(event) {
        if (!$(event.target).closest(`#dm-homepage-search-form, #search-dropdown`).length) {
            dropdown.hide();
            searchInput.attr('aria-expanded', 'false');
        }
    });

    $(document).on('focusin', function(event) {
        if (!$(event.target).closest(`#dm-homepage-search-form, #search-dropdown`).length) {
            dropdown.hide();
            searchInput.attr('aria-expanded', 'false');
        }
    });
}

function updateDropdown(categories, innovations, communities, products) {
  $('#category-list, #practice-list, #community-list, #product-list').empty();

  categories.forEach(function(category) {
      let link = $('<a></a>')
          .attr('href', `/search?category=${encodeURIComponent(category.name)}`)
          .text(category.name);
      let listItem = $('<li></li>')
          .addClass('search-result')
          .attr('data-category_id', category.id)
          .append(link);

      $('#category-list').append(listItem);
  });

  innovations.forEach(function(innovation) {
      let link = $('<a></a>')
          .attr('href', `/innovations/${encodeURIComponent(innovation.slug)}`)
          .text(innovation.name);
      let listItem = $('<li></li>')
          .addClass('search-result')
          .attr('data-practice-id', innovation.id)
          .append(link);

      $('#practice-list').append(listItem);
  });

  communities.forEach(function(community) {
      let link = $('<a></a>')
          .attr('href', `/search?category=${encodeURIComponent(community.name)}`)
          .text(community.name);
      let listItem = $('<li></li>')
          .addClass('search-result')
          .attr('data-community-id', community.id)
          .append(link);

      $('#community-list').append(listItem);
  });

  products.forEach(function(product) {
      let link = $('<a></a>')
          .attr('href', `/products/${product.slug}`)
          .text(product.name);
      let listItem = $('<li></li>')
          .addClass('search-result')
          .attr('data-product-id', product.id)
          .append(link);

      $('#product-list').append(listItem);
  });
}

function setupClickTracking(listSelector, eventName, dataAttribute) {
  const dropdownContent = document.querySelector('.dropdown-content');
  const list = dropdownContent ? dropdownContent.querySelector(listSelector) : null;
  if (!list) return;

  list.addEventListener('click', function(e) {
    if (e.target && e.target.nodeName === 'A') {
      e.preventDefault();

      const name = e.target.innerText;
      const url = e.target.getAttribute('href');
      const id = e.target.closest('.search-result').getAttribute(dataAttribute);

      let properties = { from_homepage: true};
      properties[dataAttribute === 'data-practice-id' ? 'practice_name' : 'category_name'] = name;
      properties[dataAttribute.slice(5)] = parseInt(id); // Removes 'data-' and uses the rest as the key

      ahoy.track(eventName, properties);

      setTimeout(function() {
        window.location.href = url;
      }, 100);
    }
  });
}

function setupBrowseAllTracking() {
  const browseAllLinks = document.querySelectorAll('.browse-all-link');
  browseAllLinks.forEach(link => {
    link.addEventListener('click', function(e) {
      e.preventDefault();
      const url = this.getAttribute('href');
      const sectionType = this.closest('.result-section').getAttribute('data-type');

      ahoy.track("Dropdown Browse-all Link Clicked", {
        type: sectionType,
        url: url
      });

      setTimeout(function() {
        window.location.href = url;
      }, 100);
    });
  });
}

addEventListener('turbolinks:load', function () {
  if ($('#dm-homepage-search-button').length > 0) {
    setupSearchDropdown();
    setupBrowseAllTracking();
    setupClickTracking('#practice-list', "Dropdown Practice Link Clicked", 'data-practice-id');
    setupClickTracking('#category-list', "Category selected", 'data-category_id');
    setupClickTracking('#community-list', "Category selected", 'data-category_id');
    setupClickTracking('#product-list', "Dropdown Product Link Clicked", 'data-product_id');
  }
});
