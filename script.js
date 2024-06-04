document.addEventListener('DOMContentLoaded', function () {
  const searchInput = document.getElementById('search-input');
  const quoteContainer = document.getElementById('quote-container');
  let noResultsHeading; // Declare the heading variable outside the function scope

  searchInput.addEventListener('input', function () {
    const searchTerm = searchInput.value.toLowerCase();
    filterQuotes(searchTerm);
  });

  fetch('quotes.json')
    .then(response => response.json())
    .then(data => {
      // Shuffle the quotes randomly
      const shuffledQuotes = shuffleArray(data);

      displayQuotes(shuffledQuotes);
      setSearchInputAndQuoteWidth();
    })
    .catch(error => console.error('Error fetching quotes:', error));

  function displayQuotes(quotes) {
    quoteContainer.innerHTML = ''; // Clear existing quotes
    quotes.forEach(quote => {
      const quoteElement = document.createElement('div');
      quoteElement.classList.add('quote');

      const quoteText = `"${quote.quote}"<br>- ${quote.author}`;

      quoteElement.innerHTML = `<p>${quoteText}</p>`;

      quoteElement.addEventListener('click', function () {
        copyToClipboard(quote.quote, quote.author);
      });

      quoteContainer.appendChild(quoteElement);
    });
  }

  function setSearchInputAndQuoteWidth() {
    const quotes = document.querySelectorAll('.quote');
    const vwWidth = 80;

    quotes.forEach(quote => {
      const quoteWidth = `${vwWidth}vw`;
      quote.style.width = quoteWidth;
    });

    searchInput.style.width = `${vwWidth}vw`;
  }

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

  function copyToClipboard(quote, author) {
    const formattedQuote = `"${quote}"\n- ${author}`;
    const textarea = document.createElement('textarea');
    textarea.value = formattedQuote;
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
  }

  // Function to shuffle an array randomly
  function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  }
});
