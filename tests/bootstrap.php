<?php

use Dotenv\Dotenv;

// Define project root
define('PROJECT_ROOT', dirname(__DIR__));

// Load test environment variables
$dotenv = Dotenv::createImmutable(PROJECT_ROOT . '/tests', '.env.testing');
$dotenv->load();

// Set Modern Campus specific environment variables
$_SERVER['ou:action'] = $_ENV['OU_ACTION'] ?? 'preview';
$_SERVER['ou:path'] = $_ENV['OU_PATH'] ?? '/';
$_SERVER['ou:site'] = $_ENV['OU_SITE'] ?? 'test-site';
$_SERVER['ou:stagingpath'] = PROJECT_ROOT . ($_ENV['OU_STAGING_PATH'] ?? '/staging');

// Create necessary test directories
$directories = [
    PROJECT_ROOT . $_ENV['TEST_DATA_PATH'],
    PROJECT_ROOT . $_ENV['TEST_DATA_PATH'] . '/xslt',
    PROJECT_ROOT . $_ENV['TEST_DATA_PATH'] . '/xslt/_shared',
    PROJECT_ROOT . $_ENV['TEST_RESOURCES_PATH']
];

// Create staging directory structure for Modern Campus
$stagingDirs = [
    $_SERVER['ou:stagingpath'] . '/OMNI-INF/stylesheets',
    $_SERVER['ou:stagingpath'] . '/OMNI-INF/includes',
    $_SERVER['ou:stagingpath'] . '/OMNI-INF/components'
];

// Combine all directories
$allDirs = array_merge($directories, $stagingDirs);

// Create directories if they don't exist
foreach ($allDirs as $dir) {
    if (!file_exists($dir) && !mkdir($dir, 0777, true)) {
        throw new RuntimeException(sprintf('Directory "%s" was not created', $dir));
    }
}

// Copy shared XSL files from _resources to test directory
$sharedXslDir = PROJECT_ROOT . '/_resources/xsl/_shared';
$testSharedXslDir = PROJECT_ROOT . $_ENV['TEST_DATA_PATH'] . '/xslt/_shared';

if (is_dir($sharedXslDir)) {
    $files = scandir($sharedXslDir);
    foreach ($files as $file) {
        if ($file !== '.' && $file !== '..' && pathinfo($file, PATHINFO_EXTENSION) === 'xsl') {
            $sourcePath = $sharedXslDir . '/' . $file;
            $targetPath = $testSharedXslDir . '/' . $file;
            if (!file_exists($targetPath)) {
                copy($sourcePath, $targetPath);
            }
        }
    }
}

// Register autoloader
require_once PROJECT_ROOT . '/vendor/autoload.php';

// Load test helpers
require_once __DIR__ . '/helpers.php'; 