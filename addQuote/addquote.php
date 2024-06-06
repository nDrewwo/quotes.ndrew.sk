<?php

include '../processes/db_connection.php';

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get form data
$author = $_POST['author'];
$quote = $_POST['quote'];

// Prepare and bind
$stmt = $conn->prepare("INSERT INTO quotes (author, quote) VALUES (?, ?)");
$stmt->bind_param("ss", $author, $quote);

// Execute the statement
if ($stmt->execute()) {
    header("Location: ../index.php");
} else {
    echo "Error: " . $stmt->error;
}

// Close the connection
$stmt->close();
$conn->close();
?>