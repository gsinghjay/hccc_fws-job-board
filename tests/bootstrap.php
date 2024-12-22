<?php

// Set error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Define constants
define('PROJECT_ROOT', dirname(__DIR__));

// Autoloader
spl_autoload_register(function ($class) {
    // Convert namespace to full file path
    $class = str_replace('\\', DIRECTORY_SEPARATOR, $class);
    $file = PROJECT_ROOT . DIRECTORY_SEPARATOR . 'tests' . DIRECTORY_SEPARATOR . $class . '.php';
    
    if (file_exists($file)) {
        require_once $file;
        return true;
    }
    return false;
}); 