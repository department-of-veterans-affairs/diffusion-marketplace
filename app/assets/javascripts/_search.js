async function getPractices() {
    return await (await fetch('/practices_json')).json();
}

async function searchPracticesPage() {
    // Skip if not the search page
    if (location.pathname !== '/search') return;

    let practices = await getPractices().then(data => data);

    // Search helper functions

    // Search practices and populate the page
    function search(query) {

        // Trim whitespace from the query (can cause matching problems)
        query = query.trim();

        // Set variables
        let resultsHTML = '';
        const resultsSummary = document.querySelector('#results-summary');
        const searchResults = document.querySelector('#search-results');

        // If the query is empty or less than three characters, remove any previous results from page
        if (query === '' || query.length < 3) {
            resultsSummary.innerHTML = '<p><i>Type at least three characters to search.</i></p>';
            searchResults.innerHTML = '';
            return;
        }

        // Run the search query
        const results = fuse.search(query);

        // Print the number of results for the query
        resultsSummary.innerHTML = `${results.length} result${results.length === 1 ? '' : 's'} for "${query}":`;
        resultsHTML += '<hr>';

        // Highlight results (only Fuse.js matching)
        results.forEach((result) => {
            highlighter(result);
        });

        // Template out the search results
        results.forEach((result) => {
            resultsHTML +=
                `<div class="grid-row search-row">
          <div class="grid-col flex-1">
            <div class="img-box margin-top-2">
              <a href="/practices/${result.item.slug}" aria-label="Go to ${result.item.name}">
              <div class="img img-box-content" style="${result.item.image ? `background: url('${result.item.image}') #97d4ea` : `background: #97d4ea`}; background-size: cover">
              
                </div>
                </a>
            </div>             
          </div>
          <div class="grid-col flex-2">
            <h2 class="margin-top-1"><a href="/practices/${result.item.id}">${result.item.tagline}</a></h2>
              <h3 class="truncate-text two-lines">${result.item.description}</h3>
              <p class="practice-details">${result.item.name} | <span class="uppercase">${result.item.date_initiated}</span> | <span class="uppercase">${result.item.initiating_facility}</span></p>
              <p class="truncate-text five-lines">${result.item.summary}</p>

              <!-- Uncomment to show Fuse.js diagnostics -->
              <!--
                <h3>Fuse.js highlighted character matching</h3>
                <p class="">${result.highlight}</p>
                <p><b>Score: ${result.score}</b></p>
              -->

          </div>
        </div>
        <hr>`;
        });

        // Print results to the page
        searchResults.innerHTML = resultsHTML;

        // Highlight search results where exact keyword matches
        const mark = new Mark('#search-results');
        mark.mark(query);
    }


    // Highlight Fuse.js results
    // Adapted from: https://github.com/brunocechet/Fuse.js-with-highlight
    function highlighter(resultItem) {
        resultItem.matches.forEach((matchItem) => {
            let text = resultItem.item[matchItem.key];
            let result = [];
            let matches = [].concat(matchItem.indices); // limpar referencia
            let pair = matches.shift();

            for (let i = 0; i < text.length; i++) {
                let char = text.charAt(i);
                if (pair && i === pair[0]) {
                    result.push('<mark>')
                }
                result.push(char);
                if (pair && i === pair[1]) {
                    result.push('</mark>');
                    pair = matches.shift()
                }
            }
            resultItem.highlight = result.join('');

            if (resultItem.children && resultItem.children.length > 0) {
                resultItem.children.forEach((child) => {
                    highlighter(child);
                });
            }
        });
    }


    // Set up search

    // Set Fuse.js search options
    const search_options = {
        keys: ['name', 'tagline', 'description', 'summary', 'initiating_facility'],
        minMatchCharLength: 3,
        tokenize: true,
        shouldSort: true,
        threshold: 0.2,
        location: 0,
        distance: 100,
        maxPatternLength: 32,
        matchAllTokens: true,
        findAllMatches: true,
        includeMatches: true,
        includeScore: true
    };

    // Create a search context with practices and search options
    const fuse = new Fuse(practices, search_options);

    // Search bar elements
    const searchField = document.querySelector('#practice-search-field');
    const searchButton = document.querySelector('#practice-search-button');

    // Set up "enter" event handler for search field
    let timeout = null;

    $(document).on('submit', '#searchForm', function (e) {
        e.preventDefault();
        // const $searchQuery = $('#practice-search-field').val();

        // Make a new timeout set to go off in 500ms
        timeout = setTimeout(function () {
            search(searchField.value);
            window.history.pushState("", "", '/search?query=' + searchField.value);
            if (typeof ga === 'function') {
                ga('send', {
                    hitType: 'event',
                    eventCategory: 'search',
                    eventAction: 'search',
                    location: '/search?query=' + searchField.value
                });
            }
        }, 500);

    });

    if (window.location.pathname === '/search' && window.location.search !== '') {
        const query = window.location.search.split('=')[1];
        search(decodeURI(query));
        searchField.value = decodeURI(query);
    }
}

document.addEventListener('turbolinks:load', () => {
    searchPracticesPage();
});
