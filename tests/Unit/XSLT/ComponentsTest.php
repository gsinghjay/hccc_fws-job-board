<?php

namespace Tests\Unit\XSLT;

class ComponentsTest extends XSLTTestCase
{
    public function testSharedVariables(): void
    {
        // Create a test XSL file that imports shared variables
        $xslContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables">
    
    <xsl:import href="_shared/variables.xsl"/>
    
    <xsl:template match="/">
        <output>
            <site-name><xsl:value-of select="\$site.name"/></site-name>
            <site-url><xsl:value-of select="\$site.url"/></site-url>
        </output>
    </xsl:template>
</xsl:stylesheet>
XSL;

        // Create mock shared variables file
        $sharedVarsContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="site.name">Test Site</xsl:variable>
    <xsl:variable name="site.url">http://test.site</xsl:variable>
</xsl:stylesheet>
XSL;

        $this->createTestXSLFile('_shared/variables.xsl', $sharedVarsContent);
        $xslPath = $this->createTestXSLFile('shared_vars_test.xsl', $xslContent);
        $this->loadXSLTemplate($xslPath);

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root/>
XML;

        $result = $this->transformXML($xmlContent);
        
        $this->assertXPathValue($result, "//site-name", "Test Site");
        $this->assertXPathValue($result, "//site-url", "http://test.site");
    }

    public function testCustomFunctions(): void
    {
        // Create a test XSL file that uses custom functions
        $xslContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">
    
    <xsl:import href="_shared/functions.xsl"/>
    
    <xsl:template match="/">
        <output>
            <formatted-date>
                <xsl:call-template name="format-date">
                    <xsl:with-param name="date" select="/root/date"/>
                </xsl:call-template>
            </formatted-date>
            <clean-text>
                <xsl:call-template name="clean-html">
                    <xsl:with-param name="text" select="/root/html"/>
                </xsl:call-template>
            </clean-text>
        </output>
    </xsl:template>
</xsl:stylesheet>
XSL;

        // Create mock functions file
        $functionsContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="format-date">
        <xsl:param name="date"/>
        <xsl:value-of select="concat('Formatted: ', \$date)"/>
    </xsl:template>
    
    <xsl:template name="clean-html">
        <xsl:param name="text"/>
        <xsl:value-of select="normalize-space(\$text)"/>
    </xsl:template>
</xsl:stylesheet>
XSL;

        $this->createTestXSLFile('_shared/functions.xsl', $functionsContent);
        $xslPath = $this->createTestXSLFile('functions_test.xsl', $xslContent);
        $this->loadXSLTemplate($xslPath);

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <date>2023-12-22</date>
    <html>  <p>Test   HTML</p>  </html>
</root>
XML;

        $result = $this->transformXML($xmlContent);
        
        $this->assertXPathValue($result, "//formatted-date", "Formatted: 2023-12-22");
        $this->assertXPathValue($result, "//clean-text", "Test HTML");
    }

    public function testBreadcrumbComponent(): void
    {
        // Create a test XSL file that uses the breadcrumb component
        $xslContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables">
    
    <xsl:import href="_shared/breadcrumb.xsl"/>
    
    <xsl:template match="/">
        <nav>
            <xsl:call-template name="breadcrumb">
                <xsl:with-param name="path" select="\$ou:path"/>
            </xsl:call-template>
        </nav>
    </xsl:template>
</xsl:stylesheet>
XSL;

        // Create mock breadcrumb component
        $breadcrumbContent = <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="breadcrumb">
        <xsl:param name="path"/>
        <ol class="breadcrumb">
            <li>Home</li>
            <xsl:for-each select="tokenize(\$path, '/')">
                <li><xsl:value-of select="."/></li>
            </xsl:for-each>
        </ol>
    </xsl:template>
</xsl:stylesheet>
XSL;

        $this->createTestXSLFile('_shared/breadcrumb.xsl', $breadcrumbContent);
        $xslPath = $this->createTestXSLFile('breadcrumb_test.xsl', $xslContent);
        $this->loadXSLTemplate($xslPath);

        // Set the path parameter
        $this->xsltProcessor->setParameter('http://omniupdate.com/XSL/Variables', 'path', '/test/path');

        $xmlContent = <<<XML
<?xml version="1.0" encoding="UTF-8"?>
<root/>
XML;

        $result = $this->transformXML($xmlContent);
        
        $this->assertXPathExists($result, "//ol[@class='breadcrumb']");
        $this->assertXPathExists($result, "//ol/li[text()='Home']");
    }

    public function testSocialMetaTags(): void
    {
        $title = 'Test Page Title';
        $description = 'Test page description';
        $imageUrl = 'https://example.com/image.jpg';

        $this->createTestXSLFile('social-meta.xsl', <<<XSL
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="title"/>
    <xsl:param name="description"/>
    <xsl:param name="image"/>
    
    <xsl:template match="/">
        <meta property="og:title" content="{$title}"/>
        <meta property="og:description" content="{$description}"/>
        <meta property="og:image" content="{$image}"/>
    </xsl:template>
</xsl:stylesheet>
XSL
        );

        $this->loadXSLTemplate($this->testDataPath . '/social-meta.xsl');
        $this->xsltProcessor->setParameter('', 'title', $title);
        $this->xsltProcessor->setParameter('', 'description', $description);
        $this->xsltProcessor->setParameter('', 'image', $imageUrl);

        $xml = '<root/>';
        $result = $this->transformXML($xml);

        $this->assertXPathValue($result, "//meta[@property='og:title']/@content", $title);
        $this->assertXPathValue($result, "//meta[@property='og:description']/@content", $description);
        $this->assertXPathValue($result, "//meta[@property='og:image']/@content", $imageUrl);
    }
} 