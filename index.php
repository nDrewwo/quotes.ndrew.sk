<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quotes</title>
    <link rel="stylesheet" href="data/css/styles.css">
    <link rel="icon" href="data/assets/icon.png">
    <meta name="description" content="Web for saving and collecting quotes of students.">
</head>
<body>
    <div id="search-container">
        <input type="text" id="search-input" placeholder="Search quotes...">
    </div>
    <div id="quote-container">
        <?php include 'processes/fetch_quotes.php'; ?>
    </div>
    <script src="script.js"></script>
</body>
</html>