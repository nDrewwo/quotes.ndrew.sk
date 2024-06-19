document.getElementById('quoteForm').addEventListener('submit', function(event) {
    event.preventDefault();

    var author = document.getElementById('author').value;
    var quote = document.getElementById('quote').value;

    fetch('https://api-quotes.ndrew.sk/addquote', {
        method: 'POST',
        headers: {
        'Content-Type': 'application/json',
        },
        body: JSON.stringify({
        author: author,
        quote: quote,
        }),
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        window.location.href = "https://quotes.ndrew.sk"; // replace with your URL
    })
    .catch((error) => {
        console.error('Error:', error);
    });
});