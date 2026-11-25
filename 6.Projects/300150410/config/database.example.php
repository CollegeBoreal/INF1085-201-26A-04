<?php

$host = 'localhost';
$dbname = 'smartwallet';
$username = 'smartwallet_user';
$password = 'VOTRE_MOT_DE_PASSE';

$pdo = new PDO(
    "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
    $username,
    $password,
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
    ]
);
