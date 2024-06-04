<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve the form data
    $author = htmlspecialchars($_POST['author']);
    $quote = htmlspecialchars($_POST['quote']);

    // Define the new entry
    $newEntry = array(
        "author" => $author,
        "quote" => $quote
    );

    // Define the file path
    $filePath = 'quotes.json';

    // Read the existing JSON file
    if (file_exists($filePath)) {
        $json = file_get_contents($filePath);
        $data = json_decode($json, true);
    } else {
        $data = array();
    }

    // Add the new entry to the data array
    $data[] = $newEntry;

    // Encode the array back to JSON
    $newJson = json_encode($data, JSON_PRETTY_PRINT);

    // Write the JSON back to the file
    if (file_put_contents($filePath, $newJson)) {
        echo "Quote added successfully!";
    } else {
        echo "Error saving quote.";
    }
} else {
    echo "Invalid request method.";
}
?>
