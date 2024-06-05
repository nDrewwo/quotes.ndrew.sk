document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('search-input');
    const quoteContainer = document.getElementById('quote-container');
    let noResultsHeading; // Declare the heading variable outside the function scope

    searchInput.addEventListener('input', function () {
        const searchTerm = searchInput.value.toLowerCase();
        filterQuotes(searchTerm);
    });

    function filterQuotes(searchTerm) {
        const quotes = document.querySelectorAll('.quote');
        let resultsFound = false;

        quotes.forEach(quote => {
            const textContent = quote.textContent.toLowerCase();
            if (textContent.includes(searchTerm)) {
                quote.style.display = 'block';
                resultsFound = true;
            } else {
                quote.style.display = 'none';
            }
        });

        if (!resultsFound) {
            displayNoResults();
        } else {
            clearNoResults();
        }
    }

    function displayNoResults() {
        if (!noResultsHeading) {
            noResultsHeading = document.createElement('h2');
            noResultsHeading.textContent = 'No Results Found';
            noResultsHeading.classList.add('no-results-heading');
            quoteContainer.appendChild(noResultsHeading);
        }
    }

    function clearNoResults() {
        if (noResultsHeading) {
            quoteContainer.removeChild(noResultsHeading);
            noResultsHeading = null; // Reset the variable
        }
    }
});
