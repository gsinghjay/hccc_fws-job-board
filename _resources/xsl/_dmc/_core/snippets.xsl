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
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="xs ou fn ouc">

	
	<xsl:template match="dmc">
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<xsl:apply-templates select="node()[not(name()=('','script_name','debug'))]" />
			</xsl:with-param>
			
			<xsl:with-param name="script-name" select="if(script_name!='') then script_name else 'generic'" />
			<xsl:with-param name="debug" select="if(debug='true') then true() else (if(debug='false') then false() else $dmc-debug)" />
		</xsl:call-template>
	</xsl:template>
	
	
	<!-- Blog assets -->
	<xsl:template match="blog" expand-text="yes">

		<xsl:variable name="filter-tags">
			<xsl:if test="@filtering = ('strict','loose')">
				<xsl:choose>
					<xsl:when test="@type='related' and ou:textual-content(@tags)=''">
						<xsl:value-of select="$tags" /><!-- for related listings if tags attribute is omitted use the current page tags instead. -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@tags" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		
		<xsl:variable name="dir">
			<xsl:choose>
				<xsl:when test="@dir=''">
					<xsl:value-of select="$blogs-listing-page" /><!-- when dir attribute is omitted use directory variable instead. -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@dir" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="filter-predicate" select="ou:get-filter-predicate($filter-tags, 'tags/tag', (@filtering = 'strict'))" />

		<xsl:variable name="xpath">
			<xsl:text>item</xsl:text>

			<xsl:if test="$dir!=''">
				<xsl:text>[starts-with(@href,'{replace($dir, '/[^/]+\.[^.]+$', '/')}')]</xsl:text>
			</xsl:if>

			<xsl:if test="@type='featured'">
				<xsl:text>[featured/text()='true']</xsl:text>
			</xsl:if>
			
			<xsl:if test="@author!=''">
				<xsl:text>[author/text() = '{@author}']</xsl:text>
			</xsl:if>

			<xsl:if test="string-length(@year)=4">
				<xsl:text>[contains(pubDate/text(), '{@year}')]</xsl:text>
			</xsl:if>

			<xsl:value-of select="$filter-predicate" />
		</xsl:variable>

		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<datasource>blogs</datasource>
				<xpath>{$xpath}</xpath>
				<type>{@type}</type>
				<max>{@limit}</max>
				<sort>date(pubDate) desc</sort>
				<heading>{@heading}</heading>
			</xsl:with-param>

			<xsl:with-param name="script-name">blogs</xsl:with-param>
			<xsl:with-param name="debug" select="$dmc-debug" />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="blog[@type='available-tags']" expand-text="yes">
		
		<xsl:variable name="dir">
			<xsl:choose>
				<xsl:when test="@dir=''">
					<xsl:value-of select="$blogs-listing-page" /><!-- when dir attribute is omitted use directory variable instead. -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@dir" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<datasource>blogs</datasource>
				<xpath>item[starts-with(@href,'{@dir}')]/tags/tag</xpath>
				<type>{@type}</type>
				<max>{@limit}</max>
				<heading>{@heading}</heading>
				<sort>.</sort>
				<distinct>true</distinct>
				<listing_page_url>{$blogs-listing-page}</listing_page_url>
			</xsl:with-param>

			<xsl:with-param name="script-name">blogs</xsl:with-param>
			<xsl:with-param name="debug" select="$dmc-debug" />
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>