<?php

use PHPUnit\Framework\TestCase as BaseTestCase;

class TestCase extends BaseTestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        
        // Set up mock environment variables
        $_SERVER['DOCUMENT_ROOT'] = PROJECT_ROOT;
        $_SERVER['SCRIPT_FILENAME'] = __FILE__;
        $_SERVER['HTTP_HOST'] = 'localhost';
        $_SERVER['REQUEST_URI'] = '/';
        
        // Ensure the XML data directory exists
        $xmlDir = PROJECT_ROOT . '/_resources/data';
        if (!is_dir($xmlDir)) {
            mkdir($xmlDir, 0777, true);
        }
    }

    protected function tearDown(): void
    {
        parent::tearDown();
        
        // Clean up XML data directory
        $xmlDir = PROJECT_ROOT . '/_resources/data';
        if (is_dir($xmlDir)) {
            array_map('unlink', glob("$xmlDir/*"));
            rmdir($xmlDir);
        }
    }

    /**
     * Create a mock XML file for testing
     * @param string $filename The name of the XML file to create
     * @param string $content The XML content
     * @return string The full path to the created file
     */
    protected function createMockXMLFile(string $filename, string $content): string
    {
        // Ensure filename has .xml extension
        if (!str_ends_with($filename, '.xml')) {
            $filename .= '.xml';
        }
        
        $path = PROJECT_ROOT . '/_resources/data/' . $filename;
        $dir = dirname($path);
        
        if (!is_dir($dir)) {
            mkdir($dir, 0777, true);
        }
        
        // Ensure the content is valid XML
        if (!simplexml_load_string($content)) {
            throw new \RuntimeException('Invalid XML content provided');
        }
        
        if (file_put_contents($path, $content) === false) {
            throw new \RuntimeException("Failed to write XML file to: $path");
        }
        
        return $path;
    }

    /**
     * Clean up mock XML files
     * @param string $filename The name of the XML file to remove
     */
    protected function removeMockXMLFile(string $filename): void
    {
        // Ensure filename has .xml extension
        if (!str_ends_with($filename, '.xml')) {
            $filename .= '.xml';
        }
        
        $path = PROJECT_ROOT . '/_resources/data/' . $filename;
        if (file_exists($path)) {
            unlink($path);
        }
    }

    /**
     * Assert that HTML contains a specific element with attributes
     * @param string $html The HTML to check
     * @param string $element The element to look for
     * @param array $attributes The attributes to check for
     */
    protected function assertHtmlContainsElement(string $html, string $element, array $attributes = []): void
    {
        $dom = new DOMDocument();
        @$dom->loadHTML($html, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        
        $xpath = new DOMXPath($dom);
        
        $query = "//{$element}";
        if (!empty($attributes)) {
            $conditions = [];
            foreach ($attributes as $attr => $value) {
                $conditions[] = "@{$attr}='{$value}'";
            }
            $query .= '[' . implode(' and ', $conditions) . ']';
        }
        
        $elements = $xpath->query($query);
        $this->assertGreaterThan(0, $elements->length, "Element {$element} not found with specified attributes");
    }

    /**
     * Create a mock DMC class instance
     * @param string $className The name of the DMC class to mock
     * @return object The mocked class instance
     */
    protected function createMockDMC(string $className): object
    {
        require_once PROJECT_ROOT . '/_resources/dmc/php/_core/class.dmc.php';
        $filePath = PROJECT_ROOT . "/_resources/dmc/php/{$className}.php";
        require_once $filePath;
        
        // Convert filename to class name (e.g., 'events' -> 'EventsDMC', 'fws_jobs' -> 'FWSJobsDMC')
        $className = str_replace(' ', '', ucwords(str_replace('_', ' ', $className))) . 'DMC';
        
        // Create instance with custom data folder
        $instance = new $className('/_resources/data/');
        return $instance;
    }
} 