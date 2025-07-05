<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// DB connection
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan"; // change if needed

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed."]);
    exit();
}

// Get JSON input
$input = json_decode(file_get_contents("php://input"));
if (!$input || !isset($input->email)) {
    echo json_encode(["success" => false, "message" => "Invalid request. Email required."]);
    exit();
}

$email = $conn->real_escape_string($input->email);

$sql = "SELECT Name, LastName, Email, Position, Office AS Department, Campus FROM login WHERE Email = '$email'";
$result = $conn->query($sql);

if ($result && $result->num_rows === 1) {
    $row = $result->fetch_assoc();

    echo json_encode([
        "success" => true,
        "data" => [
            "name" => $row["Name"] . " " . $row["LastName"],
            "email" => $row["Email"],
            "position" => $row["Position"],
            "department" => $row["Department"],
            "campus" => $row["Campus"]
        ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "User not found."]);
}

$conn->close();
?>
