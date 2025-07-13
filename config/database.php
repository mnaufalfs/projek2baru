<?php
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'rental_kendaraan';

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set charset to utf8
$conn->set_charset("utf8");

// Export connection to global variable
global $db;
$db = $conn;
?> 