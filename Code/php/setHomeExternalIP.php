<?php

$dbhost = 'localhost';
$dbuser = 'itzikc_switch';
$servername = 'itzikc_switch';
$password = '981462';
$requestedIP = $_GET["ip"];
$token = $_GET["token"];

if($token == "a1a1a1a1")
{
	// Create connection
	$conn = new mysqli($dbhost, $servername, $password, $dbuser);
	// Check connection
	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	} 
	
	$sql = "UPDATE switch SET home_ip='".$requestedIP."'";
	
	if ($conn->query($sql) === TRUE) {
		echo "success : ip was set to " . $requestedIP;

	} else {
		echo "Error : cannot set IP " . $conn->error;
	}
	
	$conn->close();
}

else
{
	echo "Wrong password";
}
?>