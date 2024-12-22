<?php

namespace Tests\Unit\XSLT;

class TemplateMatchingTest extends XSLTTestCase
{
    public function testBasicTemplateMatching(): void
    {
        // Create a test XSL file with template matching
        $xslContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:template match="/">
        <output>
            <xsl:apply-templates select="//item"/>
        </output>
    </xsl:template>
    
    <xsl:template match="item[@type='header']">
        <h1><xsl:value-of select="text"/></h1>
    </xsl:template>
    
    <xsl:template match="item[@type='paragraph']">
        <p><xsl:value-of select="text"/></p>
    </xsl:template>
</xsl:stylesheet>
XSL;

        $xslPath = $this->createTestXSLFile('template_match_test.xsl', $xslContent);
        $this->loadXSLTemplate($xslPath);

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <item type="header">
        <text>Test Header</text>
    </item>
    <item type="paragraph">
        <text>Test Paragraph</text>
    </item>
</root>
XML;

        $result = $this->transformXML($xmlContent);
        
        $this->assertXPathValue($result, "//h1", "Test Header");
        $this->assertXPathValue($result, "//p", "Test Paragraph");
    }

    public function testTemplateInheritance(): void
    {
        // Create a base template file
        $baseContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="base-layout">
        <html>
            <head>
                <xsl:call-template name="head-content"/>
            </head>
            <body>
                <header>
                    <xsl:call-template name="header-content"/>
                </header>
                <main>
                    <xsl:call-template name="main-content"/>
                </main>
                <footer>
                    <xsl:call-template name="footer-content"/>
                </footer>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="head-content">
        <title>Default Title</title>
    </xsl:template>
    
    <xsl:template name="header-content">
        <h1>Default Header</h1>
    </xsl:template>
    
    <xsl:template name="main-content">
        <p>Default Content</p>
    </xsl:template>
    
    <xsl:template name="footer-content">
        <p>Default Footer</p>
    </xsl:template>
</xsl:stylesheet>
XSL;

        // Create a child template that extends the base
        $childContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="_shared/base.xsl"/>
    
    <xsl:template match="/">
        <xsl:call-template name="base-layout"/>
    </xsl:template>
    
    <xsl:template name="head-content">
        <title><xsl:value-of select="/root/title"/></title>
    </xsl:template>
    
    <xsl:template name="main-content">
        <div class="content">
            <xsl:value-of select="/root/content"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL;

        $this->createTestXSLFile('_shared/base.xsl', $baseContent);
        $xslPath = $this->createTestXSLFile('child_template.xsl', $childContent);
        $this->loadXSLTemplate($xslPath);

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <title>Custom Title</title>
    <content>Custom Content</content>
</root>
XML;

        $result = $this->transformXML($xmlContent);
        
        $this->assertXPathValue($result, "//title", "Custom Title");
        $this->assertXPathValue($result, "//div[@class='content']", "Custom Content");
        $this->assertXPathValue($result, "//header/h1", "Default Header");
        $this->assertXPathValue($result, "//footer/p", "Default Footer");
    }

    public function testTemplateModesAndPriority(): void
    {
        // Create a test XSL file with template modes and priorities
        $xslContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:template match="/">
        <output>
            <normal>
                <xsl:apply-templates select="//item"/>
            </normal>
            <formatted>
                <xsl:apply-templates select="//item" mode="formatted"/>
            </formatted>
        </output>
    </xsl:template>
    
    <!-- Default template for items -->
    <xsl:template match="item">
        <text><xsl:value-of select="."/></text>
    </xsl:template>
    
    <!-- Higher priority template for special items -->
    <xsl:template match="item[@special='true']" priority="2">
        <special><xsl:value-of select="."/></special>
    </xsl:template>
    
    <!-- Formatted mode templates -->
    <xsl:template match="item" mode="formatted">
        <formatted-text>[<xsl:value-of select="."/>]</formatted-text>
    </xsl:template>
    
    <xsl:template match="item[@special='true']" mode="formatted" priority="2">
        <formatted-special>**<xsl:value-of select="."/>**</formatted-special>
    </xsl:template>
</xsl:stylesheet>
XSL;

        $xslPath = $this->createTestXSLFile('template_modes_test.xsl', $xslContent);
        $this->loadXSLTemplate($xslPath);

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <item>Normal Item</item>
    <item special="true">Special Item</item>
</root>
XML;

        $result = $this->transformXML($xmlContent);
        
        // Test normal mode
        $this->assertXPathValue($result, "//normal/text", "Normal Item");
        $this->assertXPathValue($result, "//normal/special", "Special Item");
        
        // Test formatted mode
        $this->assertXPathValue($result, "//formatted/formatted-text", "[Normal Item]");
        $this->assertXPathValue($result, "//formatted/formatted-special", "**Special Item**");
    }

    public function testNamedTemplates(): void
    {
        $title = 'Test Page Title';
        $content = 'Test page content';

        $this->createTestXSLFile('named-templates.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="title"/>
    <xsl:param name="content"/>
    
    <xsl:template name="page-header">
        <header>
            <h1><xsl:value-of select="\$title"/></h1>
        </header>
    </xsl:template>
    
    <xsl:template name="page-content">
        <main>
            <div class="content"><xsl:value-of select="\$content"/></div>
        </main>
    </xsl:template>
    
    <xsl:template match="/">
        <div class="page">
            <xsl:call-template name="page-header"/>
            <xsl:call-template name="page-content"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->loadXSLTemplate($this->testDataPath . '/named-templates.xsl');
        $this->xsltProcessor->setParameter('', 'title', $title);
        $this->xsltProcessor->setParameter('', 'content', $content);

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathValue($result, "//h1", $title);
        $this->assertXPathValue($result, "//div[@class='content']", $content);
    }
} 