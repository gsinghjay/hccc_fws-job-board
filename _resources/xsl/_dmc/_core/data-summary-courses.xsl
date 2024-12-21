<?xml version="1.0" encoding="UTF-8"?>
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


<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:import href="../../common.xsl" />

	<!-- matching the document of the props file -->
	<xsl:template match="/document">

		<xsl:variable name="internal-doc" select="ou:get-internal-doc(ou:pcf-param('aggregation-path'))" />
		<xsl:variable name="external-doc" select="ou:get-external-doc(ou:pcf-param('external-xml-url'))" />

		<html lang="en">
			<head>
				<link href="//netdna.bootstrapcdn.com/bootswatch/3.1.0/cerulean/bootstrap.min.css" rel="stylesheet"/>
				<style>
					body{
					font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
					}
					.ox-regioneditbutton {
					display: none;
					}
				</style>
			</head>
			<body id="properties">
				<div class="container" style="max-width: 800px; margin: 20px 0 0 20px;">
					<h1>Data PCF</h1>
					<p>This will publish an XML to: <xsl:value-of select="$dirname || replace($ou:filename, '\..*$', '.xml')" /></p>
					<h2>Properties</h2>
					<dl>
						<xsl:apply-templates select="descendant::parameter"/>
					</dl>
				</div>
				<div style="display:none;">
					<ouc:div label="fake" group="fake" button="hide"/>
				</div>
				<div class="container" style="max-width: 800px; margin: 20px 0 0 20px;">
					<h2>Below is a list of courses in the Evelate JSON.</h2>
					<h4>Courses with a red ID need a course detail page.</h4>
					<table>
						<thead>
							<tr>
								<th>COURSE ID</th>
								<th>TITLE</th>
								<th>CODE</th>
								<th>RECOMMENDED FILE NAME</th>
							</tr>
						</thead>
						<tbody>

							<xsl:for-each select="$external-doc/items/program">
								<xsl:variable name="id" select="id" />
								<xsl:variable name="title" select="title" />
								<xsl:variable name="code" select="code" />
								<xsl:variable name="internal-item" select="$internal-doc/items/item[course-id/text() = $id]" />

								<xsl:if test="not($internal-item)">
									<tr>
										<td><h6 style="color:red"><xsl:value-of select="$id"/></h6></td>
										<td><xsl:value-of select="$title"/></td>
										<td><xsl:value-of select="$code"/></td>
										<td><xsl:value-of select="lower-case(replace(normalize-space(replace($title,'[^a-zA-Z0-9]',' ')),' ','-'))"/>.pcf</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</tbody>
					</table>


					<h2>Below is a list of courses in the CMS.</h2>
					<h4>Courses with a yellow ID have a detail page in the CMS but are not in the Elevate JSON.</h4>
					<table>
						<thead>
							<tr>
								<th>COURSE ID</th>
								<th>LOCATION</th>
							</tr>
						</thead>
						<tbody>

							<xsl:for-each select="$internal-doc/items/item">
								<xsl:variable name="course-id" select="./course-id" />
								<xsl:variable name="external-item" select="$external-doc/items/program[id/text() = $course-id]" />

									<tr>
										<xsl:if test="$external-item">
											<td><h6><xsl:value-of select="$course-id"/></h6></td>
										</xsl:if>
										<xsl:if test="not($external-item)">
											<td><h6 style="color:yellow"><xsl:value-of select="$course-id"/></h6></td>
										</xsl:if>
										<td><xsl:value-of select="./@href"/></td>
									</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</div>
			</body>
		</html>
	</xsl:template>

	<!-- matching a parameter that is not empty -->
	<xsl:template match="parameter[.!='']">
		<xsl:apply-templates select="@section"/>
		<dt><xsl:value-of select="@prompt"/></dt>
		<dd><xsl:value-of select="."/></dd>
	</xsl:template>

	<!-- matching a parameter that is empty -->
	<xsl:template match="parameter[.='']">
		<xsl:apply-templates select="@section"/>
		<dt><xsl:value-of select="@prompt"/></dt>
		<dd>[Empty]</dd>
	</xsl:template>

	<!-- matching a parameter with an option -->
	<xsl:template match="parameter[option]">
		<xsl:apply-templates select="@section"/>
		<dt><xsl:value-of select="@prompt"/></dt>
		<dd><xsl:value-of select="option[@selected='true']"/></dd>
	</xsl:template>

	<!-- matching a parameter with a JPG image -->
	<xsl:template match="parameter[contains(.,'jpg')]">
		<xsl:apply-templates select="@section"/>
		<dt><xsl:value-of select="@prompt"/></dt>
		<dd><img style="width:50%; height:auto" src="{.}"/></dd>
	</xsl:template>

	<!-- matching section attribute of parameter -->
	<xsl:template match="@section">
		<dt><h4><xsl:value-of select="."/></h4></dt>
	</xsl:template>

</xsl:stylesheet>