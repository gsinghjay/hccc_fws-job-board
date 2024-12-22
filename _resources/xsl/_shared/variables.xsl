<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY amp   "&#38;">
<!ENTITY copy   "&#169;">
<!ENTITY gt   "&#62;">
<!ENTITY hellip "&#8230;">
<!ENTITY laquo  "&#171;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY lsquo   "&#8216;">
<!ENTITY lt   "&#60;">
<!ENTITY nbsp   "&#160;">
<!ENTITY quot   "&#34;">
<!ENTITY raquo  "&#187;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY rsquo   "&#8217;">
]>

<!--
Implementation Skeleton - 08/24/2018

Variables XSL
Customer Variables particular to the school
-->

<xsl:stylesheet version="3.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<!-- production server type -->
	<xsl:variable name="server-type" select="'php'"/>
	<!-- production server include type -->
	<xsl:variable name="include-type" select="'php'"/>
	<!-- production server index file name -->
	<xsl:variable name="index-file" select="'index'"/>
	<!-- production server file type extension -->
	<xsl:variable name="extension" select="'html'"/>
	<!-- enable ou search tags to be output around the include functions and other places -->
	<xsl:variable name="enable-ou-search-tags" select="false()"/>
	<!-- xsl param to enable social meta tag output onto the pages -->
	<xsl:param name="enable-social-meta-tag-output" select="true()" />
	<xsl:param name="dmc-debug" select="true()"/>

	<xsl:param name="override-og-type" select="ou:pcf-param('override-og-type') => normalize-space()"/>
	<xsl:param name="override-og-image" select="ou:pcf-param('override-og-image') => normalize-space()"/>
	<xsl:param name="override-og-image-alt" select="ou:pcf-param('override-og-image-alt') => normalize-space()"/>
	<xsl:param name="override-og-description" select="ou:pcf-param('override-og-description') => normalize-space()"/>
	<xsl:param name="override-twitter-card-description" select="ou:pcf-param('override-twitter-card-description') => normalize-space()"/>
	<xsl:param name="override-twitter-card-image" select="ou:pcf-param('override-twitter-card-image') => normalize-space()"/>
	<xsl:param name="override-twitter-card-image-alt" select="ou:pcf-param('override-twitter-card-image-alt') => normalize-space()"/>
	<xsl:param name="override-twitter-card-type" select="ou:pcf-param('override-twitter-card-type') => normalize-space()"/>
	<xsl:param name="ou:department-name" />
	<xsl:param name="ou:header-include-path" />
	<xsl:param name="ou:footer-include-path" />
	<xsl:param name="ou:pre-footer-path" />
	<xsl:param name="ou:navigation-end"/>
	<!--
Directory Variables (add "ou:" before variable name - in XSL only)
Example: <xsl:param name="ou:theme-color" /> ... Where "theme-color" is the Directory Variable name
-->

	<xsl:variable name="header-include-path" select="if ($ou:header-include-path != '') then $ou:header-include-path else '/_resources/includes/header.html'" />
	<xsl:variable name="footer-include-path" select="if ($ou:footer-include-path != '') then $ou:footer-include-path else '/_resources/includes/footer.html'" />

	<!-- email domain to encode -->
	<xsl:variable  name="email-domain-to-replace" select="'hccc.edu'" />
	<!-- email domain replace value, should school name -->
	<xsl:variable  name="email-domain-replacement"  select="'HUDSONCOUNTYCOMMUNITYCOLLEGE'" />

</xsl:stylesheet>