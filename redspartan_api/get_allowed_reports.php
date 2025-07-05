<?php
header('Content-Type: application/json');

// Get JSON input from Flutter
$input = json_decode(file_get_contents("php://input"), true);

// Check if office is provided
if (!isset($input['office']) || empty(trim($input['office']))) {
    echo json_encode(["status" => "fail", "message" => "No office provided"]);
    exit;
}

$office = trim($input['office']);

// Define office to allowed reports mapping
$officeReports = [
    'Registrar' => ['Enrollment Data', 'Graduates Data'],
    'HRMO' => ['Employee Population', 'Leave Privileges'],
    'Library' => ['Number of Library Visitors'],
    'Health Services' => ['Number of Person with Disability (PWD)'],
    'EMU' => ['Water Consumption', 'Treated Water Generation', 'Electricity Consumption', 'Solid Waste'],
    'RGO' => ['Campus Population', 'Food Waste'],
    'GSO' => ['Fuel Consumption', 'Distance Traveled by Vehicles'],
    'TAO' => ['Admission Data'],
    'Budget Office' => ['Total Budget and Expenditure'],
    'All' => ['Flight and Accommodation']
];

if (array_key_exists($office, $officeReports)) {
    echo json_encode([
        "status" => "success",
        "reports" => $officeReports[$office]
    ]);
} else {
    echo json_encode([
        "status" => "fail",
        "message" => "Office not recognized: [$office]"
    ]);
}
?>
