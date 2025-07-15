<?php
// report_history.php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

// Database connection
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
}

// Read JSON input
$data = json_decode(file_get_contents("php://input"), true);
$userEmail = $data['userEmail'] ?? '';

if (!$userEmail) {
    echo json_encode(['status' => 'error', 'message' => 'Missing userEmail']);
    exit;
}

// Query report_batch based on user email
$sql = "SELECT BatchId, TableName, SubmittedAt FROM report_batch WHERE UserEmail = ? ORDER BY SubmittedAt DESC";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $userEmail);
$stmt->execute();
$result = $stmt->get_result();

$reports = [];
while ($row = $result->fetch_assoc()) {
    $reports[] = $row;
}

echo json_encode(['status' => 'success', 'reports' => $reports]);
?>
