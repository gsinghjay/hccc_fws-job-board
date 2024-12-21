<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ouc">

    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <!-- Match the ouc:div root element -->
    <xsl:template match="ouc:div">
        <job_board>
            <xsl:apply-templates select="ouc:job_board"/>
        </job_board>
    </xsl:template>

    <!-- Match job_board -->
    <xsl:template match="ouc:job_board">
        <xsl:apply-templates select="ouc:on_campus_jobs/ouc:job"/>
        <xsl:apply-templates select="ouc:off_campus_jobs/ouc:job"/>
    </xsl:template>

    <!-- Match individual job -->
    <xsl:template match="ouc:job">
        <job>
            <xsl:apply-templates select="*"/>
        </job>
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