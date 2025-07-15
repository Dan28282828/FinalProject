<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Headers: *");

$conn = new mysqli("localhost", "root", "", "redspartan");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "DB connection failed."]);
    exit();
}

$raw = file_get_contents("php://input");
file_put_contents("debug_input.json", $raw); 
$data = json_decode($raw, true);

if (!isset($data['CreatedBy']) || !isset($data['rows'])) {
    echo json_encode(["status" => "error", "message" => "Invalid input format."]);
    exit();
}

$createdBy = $conn->real_escape_string($data['CreatedBy']);
$rows = $data['rows'];

$conn->query("INSERT INTO report_batch (UserEmail, TableName) VALUES ('$createdBy', 'campuspopulation')");
$batchId = $conn->insert_id;

foreach ($rows as $row) {
    $campus = $conn->real_escape_string($row['Campus']);
    $year = intval($row['Year']);
    $students = intval($row['NumStudents']);
    $isStudents = intval($row['NumISStudents']);
    $employees = intval($row['NumEmployees']);
    $canteen = intval($row['NumCanteenPersonnel']);
    $construction = intval($row['NumConstructionPersonnel']);
    $total = intval($row['Total']);

    $sql = "INSERT INTO campuspopulation 
            (Campus, Year, NumStudents, NumISStudents, NumEmployees, NumCanteenPersonnel, NumConstructionPersonnel, Total, CreatedBy, BatchId)
            VALUES 
            ('$campus', $year, $students, $isStudents, $employees, $canteen, $construction, $total, '$createdBy', $batchId)";
    if (!$conn->query($sql)) {
        echo json_encode(["status" => "error", "message" => "Insert failed: " . $conn->error]);
        exit();
    }
}

echo json_encode(["status" => "success", "batchId" => $batchId]);
$conn->close();
