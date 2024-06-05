<?php
// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "quotes_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query to select all quotes from the table
$sql = "SELECT * FROM quotes";
$result = $conn->query($sql);

// Check if there are any quotes
if ($result->num_rows > 0) {
    // Output each quote
    while($row = $result->fetch_assoc()) {
        echo '<div class="quote">';
        echo '<p>';
        echo '"' . $row["quote"] . '"<br>- ' . $row["author"];
        echo '</p>';
        echo '</div>';
    }
} else {
    echo "No quotes found.";
}

// Close connection
$conn->close();
?>
