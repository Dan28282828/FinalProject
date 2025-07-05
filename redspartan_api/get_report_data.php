<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$tableName = $data['tableName'] ?? '';
$batchId = $data['batchId'] ?? '';

if (!$tableName || !$batchId) {
    echo json_encode(['status' => 'error', 'message' => 'Missing tableName or batchId']);
    exit;
}

$tableName = preg_replace('/[^a-zA-Z0-9_]/', '', $tableName); // security

$sql = "SELECT * FROM `$tableName` WHERE BatchId = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $batchId);
$stmt->execute();
$result = $stmt->get_result();

$rows = [];
while ($row = $result->fetch_assoc()) {
    $rows[] = $row;
}

echo json_encode(['status' => 'success', 'data' => $rows]);
?>
