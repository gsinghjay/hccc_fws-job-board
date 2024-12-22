<?php

namespace Tests;

use RuntimeException;

/**
 * Create a test file with the given content
 *
 * @param string $path Relative path from PROJECT_ROOT
 * @param string $content Content to write
 * @return string Full path to the created file
 */
function createTestFile(string $path, string $content): string
{
    $fullPath = PROJECT_ROOT . '/' . ltrim($path, '/');
    $directory = dirname($fullPath);

    if (!file_exists($directory)) {
        if (!mkdir($directory, 0777, true)) {
            throw new RuntimeException("Failed to create directory: $directory");
        }
    }

    if (file_put_contents($fullPath, $content) === false) {
        throw new RuntimeException("Failed to write file: $fullPath");
    }

    return $fullPath;
}

/**
 * Delete a test file
 *
 * @param string $path Relative path from PROJECT_ROOT
 * @return bool True if file was deleted or didn't exist
 */
function deleteTestFile(string $path): bool
{
    $fullPath = PROJECT_ROOT . '/' . ltrim($path, '/');
    if (file_exists($fullPath)) {
        return unlink($fullPath);
    }
    return true;
}

/**
 * Create a test XML file
 *
 * @param string $path Relative path from PROJECT_ROOT
 * @param string $content XML content
 * @return string Full path to the created file
 */
function createTestXMLFile(string $path, string $content): string
{
    if (!str_starts_with($content, '<?xml')) {
        $content = '<?xml version="1.0" encoding="UTF-8"?>' . PHP_EOL . $content;
    }
    return createTestFile($path, $content);
}

/**
 * Create a test XSL file
 *
 * @param string $path Relative path from PROJECT_ROOT
 * @param string $content XSL content
 * @return string Full path to the created file
 */
function createTestXSLFile(string $path, string $content): string
{
    if (!str_starts_with($content, '<?xml')) {
        $content = '<?xml version="1.0" encoding="UTF-8"?>' . PHP_EOL . $content;
    }
    return createTestFile($path, $content);
}

/**
 * Get the path to a test data file
 *
 * @param string $path Relative path from PROJECT_ROOT
 * @return string Full path to the file
 */
function getTestDataPath(string $path): string
{
    return PROJECT_ROOT . '/' . ltrim($path, '/');
}

/**
 * Clean up test files and directories
 *
 * @param string $path Relative path from PROJECT_ROOT
 */
function cleanupTestData(string $path): void
{
    $fullPath = PROJECT_ROOT . '/' . ltrim($path, '/');
    if (is_dir($fullPath)) {
        $files = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($fullPath, \RecursiveDirectoryIterator::SKIP_DOTS),
            \RecursiveIteratorIterator::CHILD_FIRST
        );

        foreach ($files as $file) {
            if ($file->isDir()) {
                rmdir($file->getRealPath());
            } else {
                unlink($file->getRealPath());
            }
        }
        rmdir($fullPath);
    }
} 