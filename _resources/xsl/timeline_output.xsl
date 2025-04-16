<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ouc">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Match the ouc:div root element -->
    <xsl:template match="ouc:div">
        <timeline>
            <xsl:apply-templates select="ouc:timeline"/>
        </timeline>
    </xsl:template>

    <!-- Match timeline -->
    <xsl:template match="ouc:timeline">
        <xsl:apply-templates select="ouc:year"/>
    </xsl:template>

    <!-- Match individual year -->
    <xsl:template match="ouc:year">
        <year>
            <xsl:attribute name="value">
                <xsl:value-of select="@value"/>
            </xsl:attribute>
            <xsl:apply-templates select="ouc:event"/>
        </year>
    </xsl:template>

    <!-- Match individual event -->
    <xsl:template match="ouc:event">
        <event>
            <xsl:apply-templates select="*"/>
        </event>
    </xsl:template>

    <!-- Generic template for elements -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Generic template for attributes -->
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
</xsl:stylesheet>