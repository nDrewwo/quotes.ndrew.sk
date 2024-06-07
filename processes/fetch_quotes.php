<?php
// Database connection details
include 'db_connection.php';

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->set_charset("utf8");

// SQL query to select all quotes from the table
$sql = "SELECT * FROM quotes";
$result = $conn->query($sql);

// Check if there are any quotes
if ($result->num_rows > 0) {
    // Store all divs in an array
    $divs = array();
    while($row = $result->fetch_assoc()) {
        $div = '<div class="quote">';
        $div .= '<p>';
        $div .= '"' . $row["quote"] . '"<br>- ' . $row["author"];
        $div .= '</p>';
        $div .= '</div>';
        $divs[] = $div;
    }
    
    // Shuffle the divs
    shuffle($divs);
    
    // Echo the shuffled divs
    foreach ($divs as $div) {
        echo $div;
    }
} else {
    echo "No quotes found.";
}

// Close connection
$conn->close();
?>