<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST');
header('Content-Type: application/json');

$conn = new mysqli("localhost", "root", "", "redspartan"); // Make sure this connects to your DB

$input = json_decode(file_get_contents("php://input"), true);

if (!isset($input['office']) || empty(trim($input['office']))) {
    echo json_encode(["status" => "fail", "message" => "Office not provided"]);
    exit;
}

$office = trim($input['office']);

try {
    $stmt = $conn->prepare("SELECT report_name FROM office_reports WHERE office = ?");
    $stmt->bind_param("s", $office);
    $stmt->execute();
    $result = $stmt->get_result();

    $reports = [];
    while ($row = $result->fetch_assoc()) {
        $reports[] = $row['report_name'];
    }

    if (count($reports) > 0) {
        echo json_encode(["status" => "success", "reports" => $reports]);
    } else {
        echo json_encode(["status" => "fail", "message" => "No reports allowed for this office"]);
    }
} catch (Exception $e) {
    echo json_encode(["status" => "fail", "message" => "Server error: " . $e->getMessage()]);
}
?>
