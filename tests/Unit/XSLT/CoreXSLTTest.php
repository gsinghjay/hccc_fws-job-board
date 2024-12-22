<?php

namespace Tests\Unit\XSLT;

class CoreXSLTTest extends XSLTTestCase
{
    public function testBasicXSLTTransformation(): void
    {
        $this->createTestXSLFile('basic.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <div class="result">
            <xsl:value-of select="/root/message"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->loadXSLTemplate($this->testDataPath . '/basic.xsl');
        
        $xml = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <message>Hello World</message>
</root>
XML;

        $result = $this->transformXML($xml);
        $this->assertXPathValue($result, "//div[@class='result']", 'Hello World');
    }

    public function testNamespaceHandling(): void
    {
        $this->createTestXSLFile('namespaces.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:test="http://example.com/test">
    <xsl:template match="/">
        <div class="result">
            <xsl:value-of select="translate(/root/test:message, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->loadXSLTemplate($this->testDataPath . '/namespaces.xsl');
        
        $xml = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root xmlns:test="http://example.com/test">
    <test:message>hello world</test:message>
</root>
XML;

        $result = $this->transformXML($xml);
        $this->assertXPathValue($result, "//div[@class='result']", 'HELLO WORLD');
    }

    public function testParameterPassing(): void
    {
        $this->createTestXSLFile('params.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="title"/>
    <xsl:param name="subtitle"/>
    
    <xsl:template match="/">
        <div class="result">
            <h1><xsl:value-of select="\$title"/></h1>
            <h2><xsl:value-of select="\$subtitle"/></h2>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->loadXSLTemplate($this->testDataPath . '/params.xsl');
        $this->xsltProcessor->setParameter('', 'title', 'Test Title');
        $this->xsltProcessor->setParameter('', 'subtitle', 'Test Subtitle');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathValue($result, "//h1", 'Test Title');
        $this->assertXPathValue($result, "//h2", 'Test Subtitle');
    }

    public function testModernCampusVariables(): void
    {
        $this->createTestXSLFile('mc-vars.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables">
    <xsl:template match="/">
        <div class="result">
            <xsl:value-of select="\$ou:action"/>
            <xsl:value-of select="\$ou:path"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->setMCParameters([
            'ou:path' => '/test/path'
        ]);
        
        $this->loadXSLTemplate($this->testDataPath . '/mc-vars.xsl');

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathValue($result, "//div[@class='result']", 'preview/test/path');
    }
} 