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
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				exclude-result-prefixes="xs ou ouc"
				expand-text="yes">

	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/template-matches.xsl"/> <!-- global template matches -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/variables.xsl"/> <!-- global variables -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/functions.xsl"/> <!-- global functions -->
	<xsl:import href="../_shared/variables.xsl"/> <!-- customer variables -->
	<xsl:import href="_core/functions.xsl"/> <!-- DMC functions -->
	<xsl:include href="_core/xml-beautify.xsl" />

	<xsl:template match="/document">
		<items>
			<xsl:apply-templates select="json-to-xml(unparsed-text(ou:pcf-param('external-json-url')))"/>
		</items>
	</xsl:template>

	<xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<xsl:variable name="internal-doc" select="ou:get-internal-doc(ou:pcf-param('aggregation-path'))" />
		<xsl:for-each select="array[@key='programs']/map/map[@key='program']" >
			<xsl:variable name="external-id" select="./*[@key='id']" />
			<program>
				<xsl:variable name="internal-item" select="$internal-doc/*:items/*:item[*:course-id/text() = $external-id]"/>
				<xsl:if test="$internal-item">
					<xsl:attribute name="href">
						<xsl:value-of select="$internal-item/@href"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="./map[@key='metadata']" />
				<id>{./*[@key='id']}</id>
				<code>{./*[@key='code']}</code>
				<title>{./*[@key='title']}</title>
				<xsl:apply-templates select="./map[@key='instructionalMethod']" />
				<department>{./*[@key='department']}</department>
				<program-summary-brief>{./*[@key='programSummaryBrief']}</program-summary-brief>
				<program-instances>
					<xsl:apply-templates select="./array[@key='programInstances']/map/map[@key='programInstance'][array[@key='services']/map/map[@key='service']/string[@key='title'] = 'Enroll and Pay']"/>
				</program-instances>
			</program>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="map[@key='metadata']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<metadata>
			<data-origin>{./*[@key='dataOrigin']}</data-origin>
			<created-on>{./*[@key='createdOn']}</created-on>
			<updated-on>{./*[@key='updatedOn']}</updated-on>
		</metadata>
	</xsl:template>

	<xsl:template match="map[@key='instructionalMethod']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<instructional-method>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</instructional-method>
	</xsl:template>

	<xsl:template match="array[@key='programInstances']/map/map[@key='programInstance']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<program-instance>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<program-instance-id>{./*[@key='programInstanceID']}</program-instance-id>
			<program-instance-title>{./*[@key='programInstanceTitle']}</program-instance-title>
			<instance-year>{./*[@key='instanceYear']}</instance-year>
			<start-date>{./*[@key='startDate']}</start-date>
			<end-date>{./*[@key='endDate']}</end-date>
			<credits>{./*[@key='credits']}</credits>
			<quota>{./*[@key='quota']}</quota>
			<places-left>{./*[@key='placesLeft']}</places-left>
			<waitlist>{./*[@key='waitlist']}</waitlist>
			<waitlist-places-left>{./*[@key='waitlistPlacesLeft']}</waitlist-places-left>
			<fee>{./*[@key='fee']}</fee>
			<graduation-year>{./*[@key='graduationYear']}</graduation-year>
			<xsl:apply-templates select="./map[@key='status']"/>
			<xsl:apply-templates select="./map[@key='location']"/>
			<xsl:apply-templates select="./map[@key='courseStream']"/>
			<xsl:apply-templates select="./map[@key='award']"/>
			<xsl:apply-templates select="./map[@key='feeCategory']"/>
			<xsl:apply-templates select="./map[@key='studentCategory']"/>
			<xsl:apply-templates select="./map[@key='organisation']"/>
			<program-instance-summary-brief>{./*[@key='programInstanceSummaryBrief']}</program-instance-summary-brief>
			<program-instance-summary-long>{./*[@key='programInstanceSummaryLong']}</program-instance-summary-long>
			<services>
				<xsl:apply-templates select="./array[@key='services']/map/map[@key='service'][string[@key='title'] = 'Enroll and Pay']"/>
			</services>
			<sections>
				<xsl:apply-templates select="./array[@key='sections']/map/map[@key='section']"/>
			</sections>
		</program-instance>
	</xsl:template>

	<xsl:template match="map[@key='status']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<status>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</status>
	</xsl:template>

	<xsl:template match="map[@key='location']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<location>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</location>
	</xsl:template>

	<xsl:template match="map[@key='courseStream']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<course-stream>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</course-stream>
	</xsl:template>

	<xsl:template match="map[@key='award']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<award>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</award>
	</xsl:template>

	<xsl:template match="map[@key='feeCategory']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<fee-category>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</fee-category>
	</xsl:template>

	<xsl:template match="map[@key='studentCategory']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<student-category>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</student-category>
	</xsl:template>

	<xsl:template match="map[@key='organisation']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<organisation>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
		</organisation>
	</xsl:template>

	<xsl:template match="array[@key='services']/map/map[@key='service']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<service>
			<id>{./*[@key='id']}</id>
			<code>{./*[@key='code']}</code>
			<title>{./*[@key='title']}</title>
			<start-date>{./*[@key='startDate']}</start-date>
			<end-date>{./*[@key='endDate']}</end-date>
			<url>{./*[@key='url']}</url>
		</service>
	</xsl:template>

	<xsl:template match="array[@key='sections']/map/map[@key='section']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<section>
			<id>{./*[@key='id']}</id>
			<section-id>{./*[@key='sectionID']}</section-id>
			<section-title>{./*[@key='sectionTitle']}</section-title>
			<course>
				<id>{./map[@key='course']/*[@key='id']}</id>
				<code>{./map[@key='course']/*[@key='code']}</code>
				<title>{./map[@key='course']/*[@key='title']}</title>
			</course>
			<course-type>
				<id>{./map[@key='courseType']/*[@key='id']}</id>
				<code>{./map[@key='courseType']/*[@key='code']}</code>
				<title>{./map[@key='courseType']/*[@key='title']}</title>
			</course-type>
			<credits>{./*[@key='credits']}</credits>
			<fees>
				<xsl:apply-templates select="./array[@key='fees']/map/map[@key='fee']"/>
			</fees>
			<documents>
				<xsl:apply-templates select="./array[@key='documents']/map/map[@key='document']"/>
			</documents>
			<roles>
				<xsl:apply-templates select="./array[@key='roles']/map/map[@key='role']"/>
			</roles>
			<tutorials>
				<xsl:apply-templates select="./array[@key='tutorials']/map/map[@key='tutorial']"/>
			</tutorials>
			<section-summary-brief>{./*[@key='sectionSummaryBrief']}</section-summary-brief>
			<section-summary-long>{./*[@key='sectionSummaryLong']}</section-summary-long>
		</section>
	</xsl:template>

	<xsl:template match="array[@key='fees']/map/map[@key='fee']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<fee>
			<category>{./*[@key='category']}</category>
			<category-description>{./*[@key='categoryDescription']}</category-description>
			<type>{./*[@key='type']}</type>
			<type-description>{./*[@key='typeDescription']}</type-description>
			<amount>{./*[@key='amount']}</amount>
		</fee>
	</xsl:template>

	<xsl:template match="array[@key='documents']/map/map[@key='document']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<document>
			<!-- 			no examples, dont know the schema -->
			<xsl:copy-of select="."/>
		</document>
	</xsl:template>

	<xsl:template match="array[@key='roles']/map/map[@key='role']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<role>
			<!-- 			no examples, dont know the schema -->
			<xsl:copy-of select="."/>
		</role>
	</xsl:template>

	<xsl:template match="array[@key='tutorials']/map/map[@key='tutorial']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
		<tutorial>
			<start-date>{./*[@key='startDate']}</start-date>
			<end-date>{./*[@key='endDate']}</end-date>
			<tutorial-time>{./*[@key='tutorialtime']}</tutorial-time>
			<location-description>{./*[@key='locationDescription']}</location-description>
			<venue-description>{./*[@key='venueDescription']}</venue-description>
			<attendance-group-description>{./*[@key='attendanceGroupDescription']}</attendance-group-description>
			<tutor>{./*[@key='tutor']}</tutor>
			<days-of-the-week>{./*[@key='daysOfTheWeek']}</days-of-the-week>
		</tutorial>
	</xsl:template>

</xsl:stylesheet>
