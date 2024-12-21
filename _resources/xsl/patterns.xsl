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
Implementations Skeleton - 08/24/2018

Interior XSL
Defines the basic interior page
-->

<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:ouc="http://omniupdate.com/XSL/Variables" expand-text="yes"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:import href="common.xsl"/>

	<xsl:template name="template-headcode"/>
	<xsl:template name="template-footcode">
	</xsl:template>

	<xsl:template name="page-content">
		<xsl:param name="heading" select="normalize-space($page-heading)"/>
		<xsl:param name="banner-src" select="ou:pcf-param('banner-src') => normalize-space()"/>
		<xsl:param name="banner-text" select="ou:pcf-param('banner-text') => normalize-space()"/>
		<xsl:param name="intro-text" select="ou:pcf-param('intro') => normalize-space()"/>
		<xsl:param name="sidebar" select="ou:pcf-param('sidebar')[normalize-space(.)]"/>

		<main role="main" id="main" class="main">

			<xsl:call-template name="hero">
				<xsl:with-param name="banner-src" select="$banner-src"/>
				<xsl:with-param name="banner-text" select="$banner-text"/>
				<xsl:with-param name="heading" select="$heading"/>
			</xsl:call-template>
			<!-- see breadcrumbs xsl -->
			<section class="breadcrumbs">
				<div class="breadcrumbs__inner">
					<xsl:call-template name="output-breadcrumbs"/>
				</div>
			</section>

			<!-- Page content will go here -->
			<div class="container container--cols">
				<xsl:if test="$sidebar => count() > 0">
					<div class="container__left">
						<xsl:call-template name="sidebar">
							<xsl:with-param name="sidebar" select="$sidebar"/>
						</xsl:call-template>
					</div>
				</xsl:if>
				<div class="container__right">
					<xsl:if test="$intro-text != ''">
						<section class="page-intro">{$intro-text}</section>
					</xsl:if>
					<section class="wysiwyg">
						<xsl:apply-templates select="ouc:div[@label = 'main-content']"/>
					</section>
				</div>
			</div>
		</main>

	</xsl:template>

	<xsl:template name="sidebar">
		<xsl:param name="sidebar" select="ou:pcf-param('sidebar')[normalize-space(.)]"/>
		<section class="section-nav">
			<div class="section-nav__inner"><button class="section-nav__button" aria-expanded="false"><span><span>In This Section</span><span class="plus-minus"><span></span><span></span></span></span></button>
				<xsl:if test="$sidebar = 'side-navigation'">
					<nav class="section-nav__dropdown">
						<xsl:call-template name="side-navigation"/>
					</nav>
				</xsl:if>
			</div>
		</section>
	</xsl:template>

	<xsl:template name="hero">
		<xsl:param name="banner-src" select="ou:pcf-param('banner-src') => normalize-space()"/>
		<xsl:param name="banner-text" select="ou:pcf-param('banner-text') => normalize-space()"/>
		<xsl:param name="heading" select="normalize-space($page-heading)"/>

		<xsl:choose>
			<xsl:when test="$banner-src">
				<section class="hero-inner">
					<div class="hero-inner__img">
						<img src="{iri-to-uri($banner-src)}" alt="{$banner-text}"/>
					</div>
					<div class="hero-inner__container">
						<div class="text-block">
							<h1>{$heading}</h1>
						</div>
					</div>
				</section>
			</xsl:when>
			<xsl:otherwise>
				<section class="hero-inner hero-inner--no-img">
					<div class="hero-inner__lines">
						<span/>
						<span/>
						<span/>
					</div>
					<div class="hero-inner__container">
						<div class="text-block">
							<xsl:if test="$heading">
								<h1>{$heading}</h1>
							</xsl:if>
						</div>
					</div>
				</section>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
