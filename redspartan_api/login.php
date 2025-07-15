<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json");

// Handle preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// DB connection
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed."]);
    exit();
}

// Read JSON input
$input = json_decode(file_get_contents("php://input"));
if (!$input || !isset($input->email) || !isset($input->password)) {
    echo json_encode(["success" => false, "message" => "Invalid input or missing fields."]);
    exit();
}

$email = $conn->real_escape_string($input->email);
$password = $conn->real_escape_string($input->password);

// Query the database
$sql = "SELECT * FROM users WHERE Email='$email' AND Password='$password'";
$result = $conn->query($sql);

if ($result && $result->num_rows === 1) {
    $row = $result->fetch_assoc();
    echo json_encode([
        "success" => true,
        "user" => [
            "id" => $row["Id"],
            "name" => $row["Name"],
            "lastname" => $row["LastName"],
            "email" => $row["Email"],
            "campus" => $row["Campus"],
            "position" => $row["Position"],
            "office" => $row["Office"],
            "role" => $row["Role"]
        ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid email or password"]);
}

$conn->close();
?>
