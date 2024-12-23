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
Implementation Skeleton - 10/09/2018

Common XSL
Imported by all page type-specific stylesheets, and imports utility stylesheets.
Defines html, xsl templates and functions used globally throughout the implementation
Defines outer html structure and common include content.
-->

<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="xsl xs ou fn ouc">

	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/template-matches.xsl"/>
	<!-- global template matches -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/variables.xsl"/>
	<!-- global variables -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/functions.xsl"/>
	<!-- global functions -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/breadcrumb.xsl"/>
	<!-- global breadcrumb functionality -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/standard-outputs.xsl"/>
	<!-- global standard outputs -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/click-tips.xsl"/>
	<!-- global click tips -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/social-meta-tag-output.xsl"/>
	<!-- global social meta tags -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/snippet-helper/v1/snippet-helper.xsl"/>
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/email-obfuscation/v1/email-obfuscation.xsl" /><!-- 	email obfuscation -->
	<!-- global snippet helper code -->
	<xsl:import href="_shared/variables.xsl"/>
	<!-- customer variables -->
	<xsl:import href="_shared/template-matches.xsl"/>
	<!-- customer snippets -->
	<xsl:import href="_shared/snippets.xsl"/>
	<!-- customer snippets -->
	<xsl:import href="_shared/functions.xsl"/>
	<!-- customer functions -->
	<xsl:import href="_shared/breadcrumb.xsl"/>
	<!-- customer breadcrumb functionality -->
	<xsl:import href="_shared/components.xsl"/>
	<!-- customer breadcrumb functionality -->
	<xsl:import href="_dmc/_core/functions.xsl"/>
	<!-- enable dmc functionality -->
	<xsl:import href="_shared/forms.xsl"/>
	<!-- forms -->
	<xsl:import href="_shared/galleries.xsl"/>
	<!-- galleries -->	
	<xsl:import href="_shared/param-expose.xsl"/> <!-- parameters --> 
	<xsl:import href="_shared/nested-nav.xsl"/> <!-- nested navigation -->



	<!-- HTML5 Declaration -->
	<xsl:output method="html" version="5.0" indent="yes" encoding="UTF-8" include-content-type="no"/>

	<xsl:template match="/document">
		<html lang="en">
			<head>
				<meta charset="UTF-8"/>
				<!-- charset encoding -->
				<meta http-equiv="x-ua-compatible" content="ie=edge"/>
				<!-- compatibility mode for IE / Edge -->
				<title>
					<xsl:value-of select="$page-title"/>
				</title>
				<!-- page title -->
				<xsl:if test="$is-pub">
					<link rel="canonical" href="{$page-pub-path}"/>
					<!-- canonical -->
				</xsl:if>
				<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
				<!-- viewport -->
				<xsl:call-template name="pcf-meta-data-output"/>
				<!-- copy meta tags from pcf, but only those with content -->
				<xsl:call-template name="form-headcode"/>
				<!-- forms -->
				<xsl:call-template name="common-headcode"/>
				<!-- common headcode scripts for the <head> -->
				<xsl:call-template name="template-headcode"/>
				<!-- each xsl has a unique version of this template -->
				<xsl:apply-templates select="headcode/node()"/>
				<!-- pcf -->
				<xsl:call-template name="ou-click-tip-css"/>
				<!-- css class for click tips -->
				<xsl:call-template name="editor-plugins-css"/>
				<xsl:call-template name="full-social-meta-tag-output"/>
				<!-- social meta tag output -->
				<xsl:call-template name="gallery-headcode"/>
				<!-- galleries -->
				<script type="text/javascript"> <!--
comments//-->
					var COMMENT_PAGE_URL ="<xsl:value-of select="$domain || $ou:path"/>";
					var COMMENT_PAGE_IDENTIFIER ="<xsl:value-of select="$ou:uuid"/>";
				</script>
				<xsl:call-template name="params-to-js"/>
				<script type="text/javascript" nonce="MZMZYgHrzd2NaSQHLYQDdA==">(function(){{var relativeUrl='/cse.js?hpg\x3d1\x26cx\x3d002056967016811561801:_tq9misyv9y';(function(){{var gcse = document.createElement('script');gcse.type = 'text/javascript';gcse.async = true;gcse.src = relativeUrl;var s = document.getElementsByTagName('script')[0];s.parentNode.insertBefore(gcse,s);}})();}})();</script><style>body{{background-color:#FFFFFF;color:#000000;font-family:arial,sans-serif}}.gs-webResult{{padding:2px 0;width:42em}}.gsc-results .gsc-cursor-box{{text-align:center}}#cse-search-form{{padding:0 20px;width:22em}}#cse-header{{display:-ms-flexbox;display:flex;-ms-flex-align:end;align-items:flex-end;padding:10px 4px}}#cse-footer{{clear:both;font-size:82%;text-align:center;padding:16px}}#DZPTFe{{display:none}}</style>
			</head>
			<body>
				<div class="wrapper">
					<xsl:call-template name="common-bodycode"/>
					<!-- common body scripts for the start of <body> -->
					<xsl:call-template name="template-bodycode"/>
					<!-- each xsl has a unique version of this template -->
					<xsl:apply-templates select="bodycode/node()"/>
					<!-- pcf -->
					<header role="banner">
						<xsl:call-template name="common-header"/>
						<!-- site header -->
						<xsl:call-template name="subheader"/>
						<!-- site subheader -->
					</header>
					<xsl:call-template name="common-alert"/>
					<!-- site alert -->
					<xsl:call-template name="page-content"/>
					<!-- each xsl has a unique version of this template -->
					<xsl:call-template name="common-footer"/>
					<!-- site footer -->
					<xsl:call-template name="common-footcode"/>
					<!-- common footcode scripts -->
					<xsl:call-template name="direct-edit"/>
					<!-- outputs the direct edit OU Campus object and direct-edit js -->
					<xsl:call-template name="template-footcode"/>
					<!-- each xsl has a unique version of this template -->
					<xsl:apply-templates select="footcode/node()"/>
					<!-- pcf -->
					<xsl:call-template name="ou-click-tip-modal"/>
					<!-- click tip modal -->
					<xsl:call-template name="editor-plugins-js"/>
					<xsl:call-template name="form-footcode"/>
					<!-- forms -->
					<xsl:call-template name="gallery-footcode"/>
					<!-- galleries -->
				</div>
				<xsl:if test="$ou:action = 'pub'">
					<xsl:processing-instruction name="php" expand-text="no">
						if (file_exists($_SERVER['DOCUMENT_ROOT'] . '/ou-alerts/alerts-config.alerts.html')) {
						include($_SERVER['DOCUMENT_ROOT'] . '/ou-alerts/alerts-config.alerts.html');
						}
						?</xsl:processing-instruction>
				</xsl:if>
				<xsl:call-template name="email-obfuscation-script-output" />
			</body>
		</html>
	</xsl:template>

	<xsl:template name="common-bodycode">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/bodycode.inc</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="common-headcode">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/headcode.inc</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="$is-edt">
			<link rel="stylesheet" href="//cdn.omniupdate.com/select-lists/v1/select-lists.min.css"/>
		</xsl:if>
		<!-- Add Timeline Component Resources -->
		<xsl:if test="//ouc:component[@label='Timeline Component']">
			<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/> -->
			<link href="/_resources/css/timeline-component.css" rel="stylesheet"/>
		</xsl:if>
		<xsl:if test="//ouc:component[@label='hccc-fws-jobs']">
			<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/> -->
			<link href="/_resources/css/fws_jobs.css" rel="stylesheet"/>
		</xsl:if>
		<xsl:if test="$ou:action = 'pub'">
			<xsl:processing-instruction name="php">
				if (file_exists($_SERVER['DOCUMENT_ROOT'] . '/ou-alerts/alerts-config.css.html')) {
				include($_SERVER['DOCUMENT_ROOT'] . '/ou-alerts/alerts-config.css.html');
				}
				?</xsl:processing-instruction>
		</xsl:if>
		<!-- Local Bootstrap and Carousel CSS -->
		<link href="/_resources/css/bootstrap.min.css" rel="stylesheet"/>
		<link href="/_resources/css/testimonial-carousel.css" rel="stylesheet"/>
		<link href="/_resources/css/fws_jobs.css" rel="stylesheet"/>
		<link href="/_resources/css/timeline-component.css" rel="stylesheet"/>
	</xsl:template>

	<xsl:template name="common-alert">
		<!--<xsl:call-template name="output-include">
<xsl:with-param name="path">/_resources/includes/alert.inc</xsl:with-param>
<xsl:with-param name="from-prod" select="true()"/>
</xsl:call-template>-->
	</xsl:template>

	<xsl:template name="common-header">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path" select="$header-include-path"/>
			<xsl:with-param name="from-prod" select="true()"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="subheader">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/cta-buttons.html</xsl:with-param>
			<xsl:with-param name="from-prod" select="true()" />
		</xsl:call-template>
	</xsl:template> 

	<xsl:template name="pre-footer">
		<!--<xsl:call-template name="output-include">
<xsl:with-param name="path"><xsl:value-of select="$ou:pre-footer-path"/></xsl:with-param>
<xsl:with-param name="from-prod" select="true()" />
</xsl:call-template>-->
	</xsl:template>

	<xsl:template name="common-footer">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path" select="$footer-include-path"/>
			<xsl:with-param name="from-prod" select="true()"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="common-footcode">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/footcode.inc</xsl:with-param>	
		</xsl:call-template>
		<!-- Add Timeline Component JavaScript
		<xsl:if test="//ouc:component[@label='Timeline Component']">
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
		</xsl:if> -->
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/analytics.inc</xsl:with-param>
			<xsl:with-param name="condition" select="$is-pub"/>
		</xsl:call-template>
		<xsl:if test="$is-edt">
			<!-- jQuery 1.5+ is required. Add it here if not already included. -->
			<script src="//cdn.omniupdate.com/select-lists/v1/select-lists.min.js" defer="defer"/>
		</xsl:if>
		<!-- Add Bootstrap JS -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	</xsl:template>
	<!-- template for side navigation display, use this template to output the side navigation with wrapping HTML -->
	<xsl:template name="side-navigation">
		<!-- 		<xsl:call-template name="output-navigation">
<xsl:with-param name="final-navigation-path" select="concat($dirname, '_nav.inc')"/>
<xsl:with-param name="kind" select="'php'"/>
<xsl:with-param name="script-loc" select="'/_resources/php/nested-navigation/sitenav.php'" />
</xsl:call-template> -->
		<xsl:call-template name="nav-builder"></xsl:call-template>
	</xsl:template>

	<xsl:template name="editor-plugins-css">
		<xsl:if test="$is-edt">
			<link rel="stylesheet" href="//cdn.omniupdate.com/select-lists/v1/select-lists.min.css"/>
			<link rel="stylesheet" href="//cdn.omniupdate.com/table-separator/v1/table-separator.css"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="editor-plugins-js">
		<xsl:if test="$is-edt">
			<!-- jQuery 1.5+ is required for Select Lists and Table Separator. Add it here if not already included. -->
			<script src="//cdn.omniupdate.com/select-lists/v1/select-lists.min.js" defer="defer"/>
			<script src="//cdn.omniupdate.com/table-separator/v1/table-separator.js" defer="defer"/>
		</xsl:if>
	</xsl:template>

	<!-- in case not defined in page type xsl, leave for debugging purposes -->
	<xsl:template name="page-content">
		<p>No template defined.</p>
	</xsl:template>
	<xsl:template name="template-headcode"/>
	<xsl:template name="template-footcode"/>
	<xsl:template name="template-bodycode"/>

</xsl:stylesheet>