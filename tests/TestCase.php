<?php

namespace Tests;

use PHPUnit\Framework\TestCase as BaseTestCase;
use DOMDocument;
use DOMXPath;

class TestCase extends BaseTestCase
{
    protected $resourcesDir;
    protected $testDataDir;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->resourcesDir = dirname(__DIR__) . '/_resources';
        $this->testDataDir = dirname(__DIR__) . '/tests/data';
        
        // Create test data directory if it doesn't exist
        if (!file_exists($this->testDataDir)) {
            mkdir($this->testDataDir, 0777, true);
        }
        
        // Create subdirectories for different test data
        $subdirs = ['events', 'calendar', 'xslt'];
        foreach ($subdirs as $subdir) {
            $path = $this->testDataDir . '/' . $subdir;
            if (!file_exists($path)) {
                mkdir($path, 0777, true);
            }
        }
    }

    protected function createMockDMC(string $className): object
    {
        require_once $this->resourcesDir . '/dmc/php/_core/class.dmc.php';
        $filePath = $this->resourcesDir . "/dmc/php/{$className}.php";
        require_once $filePath;
        
        // Convert filename to class name (e.g., 'events' -> 'EventsDMC', 'fws_jobs' -> 'FWSJobsDMC')
        $className = str_replace(' ', '', ucwords(str_replace('_', ' ', $className))) . 'DMC';
        
        // Create instance with test data folder
        return new $className($this->testDataDir . '/');
    }

    protected function createMockXMLFile(string $filename, string $content, string $subdir = ''): string
    {
        $targetDir = $this->testDataDir;
        if ($subdir) {
            $targetDir .= '/' . trim($subdir, '/');
            if (!file_exists($targetDir)) {
                mkdir($targetDir, 0777, true);
            }
        }
        
        return createTestXMLFile($filename, $content, $targetDir);
    }

    protected function createMockXSLFile(string $filename, string $content, string $subdir = ''): string
    {
        $targetDir = $this->testDataDir;
        if ($subdir) {
            $targetDir .= '/' . trim($subdir, '/');
            if (!file_exists($targetDir)) {
                mkdir($targetDir, 0777, true);
            }
        }
        
        return createTestXSLFile($filename, $content, $targetDir);
    }

    protected function assertXMLEqual(string $expectedXML, string $actualXML, string $message = ''): void
    {
        $expected = new DOMDocument();
        $expected->loadXML($expectedXML);
        $expected->formatOutput = true;
        
        $actual = new DOMDocument();
        $actual->loadXML($actualXML);
        $actual->formatOutput = true;
        
        $this->assertEquals(
            $expected->saveXML(),
            $actual->saveXML(),
            $message ?: 'Failed asserting that two XML documents are equal.'
        );
    }

    protected function assertXPathExists(string $xml, string $xpath): void
    {
        $doc = new DOMDocument();
        $doc->loadXML($xml);
        $domXPath = new DOMXPath($doc);
        
        // Register all namespaces
        foreach ($doc->documentElement->getNamespaces(true) as $prefix => $uri) {
            $domXPath->registerNamespace($prefix ?: 'default', $uri);
        }
        
        $this->assertGreaterThan(0, $domXPath->query($xpath)->length, "XPath '$xpath' not found in XML");
    }

    protected function assertXPathValue(string $xml, string $xpath, string $expectedValue): void
    {
        $doc = new DOMDocument();
        $doc->loadXML($xml);
        $domXPath = new DOMXPath($doc);
        
        // Register all namespaces
        foreach ($doc->documentElement->getNamespaces(true) as $prefix => $uri) {
            $domXPath->registerNamespace($prefix ?: 'default', $uri);
        }
        
        $nodes = $domXPath->query($xpath);
        $this->assertGreaterThan(0, $nodes->length, "XPath '$xpath' not found in XML");
        $this->assertEquals($expectedValue, $nodes->item(0)->nodeValue);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
        
        // Clean up test files
        if (file_exists($this->testDataDir)) {
            $this->recursiveDelete($this->testDataDir);
        }
    }

    private function recursiveDelete(string $dir): void
    {
        if (is_dir($dir)) {
            $objects = scandir($dir);
            foreach ($objects as $object) {
                if ($object != "." && $object != "..") {
                    if (is_dir($dir . "/" . $object)) {
                        $this->recursiveDelete($dir . "/" . $object);
                    } else {
                        unlink($dir . "/" . $object);
                    }
                }
            }
            rmdir($dir);
        }
    }
} 