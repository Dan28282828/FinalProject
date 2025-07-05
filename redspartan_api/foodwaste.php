<?php
header('Content-Type: application/json');

// ✅ Step 1: Database connection
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan";

$conn = new mysqli($host, $user, $pass, $dbname); // ✅ You were missing this
if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit;
}

// ✅ Step 2: Read and validate input
$input = json_decode(file_get_contents("php://input"), true);
if (!$input || !isset($input['CreatedBy']) || !isset($input['rows']) || !is_array($input['rows'])) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input format.']);
    exit;
}

$createdBy = $input['CreatedBy'];
$rows = $input['rows'];
$tableName = 'foodwaste';
$now = date('Y-m-d H:i:s');

// ✅ Step 3: Insert into report_batch
$batchQuery = "INSERT INTO report_batch (CreatedBy, TableName, SubmittedAt) VALUES (?, ?, ?)";
$stmt = $conn->prepare($batchQuery);
$stmt->bind_param("sss", $createdBy, $tableName, $now);
if (!$stmt->execute()) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to create report batch']);
    $stmt->close();
    $conn->close();
    exit;
}
$batchId = $stmt->insert_id;
$stmt->close();

// ✅ Step 4: Insert foodwaste rows
$insertQuery = "INSERT INTO foodwaste (BatchId, Campus, Date, QuantityKg, Remarks) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($insertQuery);

foreach ($rows as $row) {
    $campus = $row['Campus'] ?? '';
    $date = $row['Date'] ?? '';
    $quantity = floatval($row['QuantityKg'] ?? 0);  // Make sure it's float
    $remarks = $row['Remarks'] ?? '';

    $stmt->bind_param("issds", $batchId, $campus, $date, $quantity, $remarks);
    if (!$stmt->execute()) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to insert foodwaste data', 'error' => $stmt->error]);
        $stmt->close();
        $conn->close();
        exit;
    }
}

$stmt->close();
$conn->close();

echo json_encode(['status' => 'success', 'batchId' => $batchId]);
?>
