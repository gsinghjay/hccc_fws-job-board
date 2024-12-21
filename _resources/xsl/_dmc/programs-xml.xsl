<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
]>
<xsl:stylesheet version="3.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="xs ou ouc"
				expand-text="yes">

	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/template-matches.xsl"/> <!-- global template matches -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/variables.xsl"/> <!-- global variables -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/functions.xsl"/> <!-- global functions -->
	<xsl:import href="../_shared/variables.xsl"/> <!-- customer variables -->
	<xsl:import href="_core/functions.xsl"/> <!-- DMC functions -->
	<xsl:include href="_core/xml-beautify.xsl" />

	<!-- 	<xsl:output method="xml" version="1.0" include-content-type="yes" /> -->

	<xsl:template match="/document">
		<xsl:variable name="internal-doc" select="ou:get-internal-doc(ou:pcf-param('aggregation-path'))" />
		<!-- 		<xsl:variable name="external-doc" select="ou:get-external-doc(ou:pcf-param('external-xml-url'))" /> -->

		<root>
			<items>
				<xsl:for-each select="$internal-doc/items/item">
					<item href="{@href}">
						<xsl:apply-templates />
						<url>{@href}</url>
					</item>
				</xsl:for-each>
			</items>
		</root>


	</xsl:template>

	<xsl:template match="department">
		<xsl:for-each select="tokenize(., ',')">
			<department>
				<xsl:value-of select="normalize-space(.)"/>
			</department>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="programType">
		<xsl:for-each select="tokenize(., ',')">
			<programType>
				<xsl:value-of select="normalize-space(.)"/>
			</programType>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="credentialType">
		<xsl:for-each select="tokenize(., ',')">
			<credentialType>
				<xsl:value-of select="normalize-space(.)"/>
			</credentialType>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="location">
		<xsl:for-each select="tokenize(., ',')">
			<location>
				<xsl:value-of select="normalize-space(.)"/>
			</location>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="programDivision">
		<xsl:for-each select="tokenize(., ',')">
			<programDivision>
				<xsl:value-of select="normalize-space(.)"/>
			</programDivision>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
