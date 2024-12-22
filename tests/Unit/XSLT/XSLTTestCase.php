<?php

namespace Tests\Unit\XSLT;

use PHPUnit\Framework\TestCase;
use DOMDocument;
use DOMXPath;
use XSLTProcessor;
use function Tests\createTestFile;
use function Tests\createTestXMLFile;
use function Tests\createTestXSLFile;
use function Tests\deleteTestFile;
use function Tests\getTestDataPath;
use function Tests\cleanupTestData;

class XSLTTestCase extends TestCase
{
    protected XSLTProcessor $xsltProcessor;
    protected string $testDataPath;
    protected string $stagingPath;
    protected string $currentMode = 'preview';

    // Constants for transformation modes
    const MODE_PREVIEW = 'preview';
    const MODE_EDIT = 'edit';
    const MODE_PRODUCTION = 'production';

    protected function setUp(): void
    {
        parent::setUp();
        $this->xsltProcessor = new XSLTProcessor();
        $this->testDataPath = PROJECT_ROOT . '/tests/data/xslt';
        $this->stagingPath = PROJECT_ROOT . '/staging';
        
        // Set default Modern Campus parameters
        $this->setMCParameters([
            'ou:action' => $this->currentMode,
            'ou:path' => '/',
            'ou:site' => 'test-site',
            'ou:stagingpath' => $this->stagingPath
        ]);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
        cleanupTestData($this->testDataPath);
    }

    protected function createTestXSLFile(string $filename, string $content): string
    {
        return createTestXSLFile($this->testDataPath . '/' . $filename, $content);
    }

    protected function loadXSLTemplate(string $path): void
    {
        $xslDoc = new DOMDocument();
        $xslDoc->load($path);
        $this->xsltProcessor->importStylesheet($xslDoc);
    }

    protected function transformXML(string $xmlContent): string
    {
        $xmlDoc = new DOMDocument();
        $xmlDoc->loadXML($xmlContent);
        return $this->xsltProcessor->transformToXml($xmlDoc);
    }

    protected function setMCParameters(array $params): void
    {
        foreach ($params as $name => $value) {
            $this->xsltProcessor->setParameter('http://omniupdate.com/XSL/Variables', $name, $value);
        }
    }

    protected function setTransformationMode(string $mode): void
    {
        $this->currentMode = $mode;
        $this->setMCParameters(['ou:action' => $mode]);
    }

    protected function assertXPathExists(string $xml, string $xpath): void
    {
        $doc = new DOMDocument();
        $doc->loadXML($xml);
        $xpathObj = new DOMXPath($doc);
        $this->assertGreaterThan(0, $xpathObj->query($xpath)->length);
    }

    protected function assertXPathValue(string $xml, string $xpath, string $expected): void
    {
        $doc = new DOMDocument();
        $doc->loadXML($xml);
        $xpathObj = new DOMXPath($doc);
        $nodes = $xpathObj->query($xpath);
        $this->assertGreaterThan(0, $nodes->length);
        $this->assertEquals($expected, $nodes->item(0)->nodeValue);
    }

    protected function registerMCNamespaces(DOMXPath $xpath): void
    {
        $namespaces = [
            'xsl' => 'http://www.w3.org/1999/XSL/Transform',
            'ou' => 'http://omniupdate.com/XSL/Variables',
            'ouc' => 'http://omniupdate.com/XSL/Variables'
        ];

        foreach ($namespaces as $prefix => $uri) {
            $xpath->registerNamespace($prefix, $uri);
        }
    }
} 