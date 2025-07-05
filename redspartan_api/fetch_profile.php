<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "redspartan";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));
if (!$data || !isset($data->email)) {
    echo json_encode(["success" => false, "message" => "Invalid input. Email missing."]);
    exit;
}

$email = $conn->real_escape_string($data->email);
$sql = "SELECT * FROM users WHERE Email='$email'";
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
    echo json_encode(["success" => false, "message" => "User not found"]);
}

$conn->close();
?>
