<?php
// Test SUPER simple
echo "SUCCESS - PHP is working!\n";
echo "PHP Version: " . phpversion() . "\n";
echo "Server IP: " . ($_SERVER['SERVER_ADDR'] ?? 'N/A') . "\n";
echo "Remote IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'N/A') . "\n";
echo "Request Method: " . ($_SERVER['REQUEST_METHOD'] ?? 'N/A') . "\n";
echo "Script: " . ($_SERVER['SCRIPT_FILENAME'] ?? 'N/A') . "\n";
?>
