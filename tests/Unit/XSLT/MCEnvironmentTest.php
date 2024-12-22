<?php

namespace Tests\Unit\XSLT;

class MCEnvironmentTest extends XSLTTestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // Create sample XSL template for testing
        $this->createTestXSLFile('test-template.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou">
    
    <xsl:template match="/">
        <div class="mc-content">
            <xsl:choose>
                <xsl:when test="\$ou:action = 'preview'">
                    <div class="preview-mode">Preview Content</div>
                </xsl:when>
                <xsl:when test="\$ou:action = 'edit'">
                    <div class="edit-mode">Edit Content</div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="production-mode">Production Content</div>
                </xsl:otherwise>
            </xsl:choose>
            <div class="site-info">
                <span class="path"><xsl:value-of select="\$ou:path"/></span>
                <span class="site"><xsl:value-of select="\$ou:site"/></span>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );
    }

    public function testPreviewMode(): void
    {
        $this->setTransformationMode(self::MODE_PREVIEW);
        $this->loadXSLTemplate($this->testDataPath . '/test-template.xsl');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathExists($result, "//div[@class='preview-mode']");
        $this->assertXPathValue($result, "//div[@class='preview-mode']", 'Preview Content');
    }

    public function testEditMode(): void
    {
        $this->setTransformationMode(self::MODE_EDIT);
        $this->loadXSLTemplate($this->testDataPath . '/test-template.xsl');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathExists($result, "//div[@class='edit-mode']");
        $this->assertXPathValue($result, "//div[@class='edit-mode']", 'Edit Content');
    }

    public function testProductionMode(): void
    {
        $this->setTransformationMode(self::MODE_PRODUCTION);
        $this->loadXSLTemplate($this->testDataPath . '/test-template.xsl');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathExists($result, "//div[@class='production-mode']");
        $this->assertXPathValue($result, "//div[@class='production-mode']", 'Production Content');
    }

    public function testMCParameters(): void
    {
        $customPath = '/custom/path';
        $customSite = 'custom-site';

        $this->setMCParameters([
            'ou:path' => $customPath,
            'ou:site' => $customSite
        ]);

        $this->loadXSLTemplate($this->testDataPath . '/test-template.xsl');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathValue($result, "//span[@class='path']", $customPath);
        $this->assertXPathValue($result, "//span[@class='site']", $customSite);
    }
} 