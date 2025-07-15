<?php
header("Content-Type: application/json");

// Get JSON input
$input = json_decode(file_get_contents("php://input"), true);

// Extract values
$email = $input['email'] ?? '';
$currentPassword = $input['current_password'] ?? '';
$newPassword = $input['new_password'] ?? '';

// Validate inputs
if (empty($email) || empty($currentPassword) || empty($newPassword)) {
    echo json_encode(['success' => false, 'message' => 'All fields are required.']);
    exit;
}

// Connect to the database
$conn = new mysqli("localhost", "root", "", "redspartan");
if ($conn->connect_error) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed.']);
    exit;
}

// Fetch the current password for the user from the users table
$stmt = $conn->prepare("SELECT Password FROM users WHERE Email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(['success' => false, 'message' => 'User not found.']);
    exit;
}

$row = $result->fetch_assoc();
$dbPassword = $row['Password'];

// NOTE: In production, use password hashing. For now we compare plain text
if ($currentPassword !== $dbPassword) {
    echo json_encode(['success' => false, 'message' => 'Current password is incorrect.']);
    exit;
}

// Update the password
$update = $conn->prepare("UPDATE users SET Password = ? WHERE Email = ?");
$update->bind_param("ss", $newPassword, $email);
$success = $update->execute();

if ($success) {
    echo json_encode(['success' => true, 'message' => 'Password updated successfully.']);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to update password.']);
}
