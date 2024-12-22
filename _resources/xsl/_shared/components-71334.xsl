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

<!--
Implementation Skeleton - 10/12/2019
Global Components XSL
This file contains templates and functions that control default behavior for standard OU Components
-->

<xsl:stylesheet version="3.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="xs ou fn ouc">

	<!-- A template match for getting rid of the stray P element that wraps around a component when it is in Blue Pill Mode -->
	<xsl:template match="p[ouc:component][text()[normalize-space(.)] => empty()][count(element()) = 1]">
		<xsl:apply-templates select="element()"/>
	</xsl:template>

	<!-- Create a mode for working with OU standard component practices -->
	<xsl:mode name="ouc-component" on-no-match="shallow-copy"/>

	<!-- A match for ouc:component element in the unnamed namespace. This match changes the mode name to ouc-component. -->
	<xsl:template match="ouc:component">		
		<xsl:apply-templates mode="ouc-component"/>
	</xsl:template>
	<xsl:template match="@data-ouc-test" mode="ouc-component"/>
	<xsl:template match="element()[@data-ouc-test and normalize-space(@data-ouc-test) = '']" mode="ouc-component"/>
	<xsl:template match="@data-ouc-not" mode="ouc-component"/>
	<xsl:template match="element()[normalize-space(@data-ouc-not) != '']" mode="ouc-component"/>
	<xsl:template match="element()[@data-ouc-justedit]" mode="ouc-component"/>

	<!---template match for testimonials component -->

	<!-- 	<xsl:template match="component[@name='testimonials']" expand-text="yes">
<xsl:variable name="quantity" select="quantity"/>
<section>
<h1>Testimonials</h1>
<div id="carouselTestimonials" class="carousel slide" data-ride="carousel">
<div class="carousel-inner">
<xsl:call-template name="dmc">
<xsl:with-param name="options">
<datasource>testimonials</datasource>
<items_per_page>{quantity/node()}</items_per_page>
<xpath>items/item</xpath>
<type>testimonials</type>
<querystring_control>true</querystring_control>
</xsl:with-param>
<xsl:with-param name="script-name">testimonials</xsl:with-param>
<xsl:with-param name="debug" select="true()" />
</xsl:call-template>
</div>
<a class="carousel-control-prev" href="#carouselTestimonials" role="button" data-slide="prev"> <span class="carousel-control-prev-icon" aria-hidden="true"></span> <span class="sr-only">Previous</span> </a> <a class="carousel-control-next" href="#carouselTestimonials" role="button" data-slide="next"> <span class="carousel-control-next-icon" aria-hidden="true"></span> <span class="sr-only">Next</span> </a></div>
</section>
</xsl:template> -->

	<!-- 	<xsl:template match="landing-news-component" mode="ouc-component" expand-text="yes">
<xsl:variable name="title" select="@title"/>
<xsl:variable name="feed" select="@feed"/>
<xsl:variable name="filters" select="@tags"/>
<xsl:variable name="param" select="'all'"/>
<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
<xsl:variable name="xpath">
<xsl:text>channel/item</xsl:text>
<xsl:if test="$filters != '' and $feed != ''">
<xsl:text>[</xsl:text>
<xsl:for-each select="tokenize($filters, ',')">
<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
<xsl:if test="position() != last()">
<xsl:value-of select="$logical-operator"/>
</xsl:if>
</xsl:for-each>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:variable>
<xsl:call-template name="dmc">
<xsl:with-param name="options">
<items_per_page>3</items_per_page>
<datasource>{$feed}</datasource>
<xpath>{$xpath}</xpath>
<type>news_items</type>
<title>{$title}</title>
<sort>date(pubDate) desc</sort>
</xsl:with-param>
<xsl:with-param name="script-name">rss</xsl:with-param>
<xsl:with-param name="debug" select="$dmc-debug" />
</xsl:call-template>
</xsl:template> -->

	<!-- 	<xsl:template match="landing-events-component" mode="ouc-component" expand-text="yes">
<xsl:variable name="title" select="@title"/>
<xsl:variable name="feed" select="@feed"/>
<xsl:variable name="filters" select="@tags"/>
<xsl:variable name="param" select="'all'"/>
<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
<xsl:variable name="xpath">
<xsl:text>channel/item</xsl:text>
<xsl:if test="$filters != '' and $feed != ''">
<xsl:text>[</xsl:text>
<xsl:for-each select="tokenize($filters, ',')">
<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
<xsl:if test="position() != last()">
<xsl:value-of select="$logical-operator"/>
</xsl:if>
</xsl:for-each>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:variable>
<xsl:call-template name="dmc">
<xsl:with-param name="options">
<items_per_page>3</items_per_page>
<datasource>{$feed}</datasource>
<xpath>{$xpath}</xpath>
<type>event_items</type>
<title>{$title}</title>
<sort>date(pubDate) desc</sort>
</xsl:with-param>
<xsl:with-param name="script-name">events</xsl:with-param>
<xsl:with-param name="debug" select="$dmc-debug" />
</xsl:call-template>
</xsl:template> -->




	<xsl:template match="ou-component-news-items" expand-text="yes">
		<xsl:variable name="title" select="title"/>
		<xsl:variable name="feed" select="feed"/>
		<xsl:variable name="filters" select="tags"/>
		<xsl:variable name="param" select="conditional"/>
		<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
		<xsl:variable name="xpath">
			<xsl:text>channel/item</xsl:text>
			<xsl:if test="$filters != '' and $feed != ''">
				<xsl:text>[</xsl:text>
				<xsl:for-each select="tokenize($filters, ',')">
					<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
					<xsl:if test="position() != last()">
						<xsl:value-of select="$logical-operator"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<items_per_page>3</items_per_page>
				<datasource>{$feed}</datasource>
				<xpath>{$xpath}</xpath>
				<type>news_items</type>
				<title>{$title}</title>
				<sort>date(pubDate) desc</sort>
			</xsl:with-param>
			<xsl:with-param name="script-name">news</xsl:with-param>
			<!-- 						<xsl:with-param name="debug" select="$dmc-debug" /> -->
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="ou-component-event-items" expand-text="yes">
		<xsl:variable name="title" select="title"/>
		<xsl:variable name="feed" select="feed"/>
		<xsl:variable name="filters" select="tags"/>
		<xsl:variable name="param" select="conditional"/>
		<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
		<xsl:variable name="xpath">
			<xsl:text>channel/item</xsl:text>
			<xsl:if test="$filters != '' and $feed != ''">
				<xsl:text>[</xsl:text>
				<xsl:for-each select="tokenize($filters, ',')">
					<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
					<xsl:if test="position() != last()">
						<xsl:value-of select="$logical-operator"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<items_per_page>3</items_per_page>
				<datasource>{$feed}</datasource>
				<xpath>{$xpath}</xpath>
				<type>event_items</type>
				<title>{$title}</title>
				<sort>date(pubDate) desc</sort>
			</xsl:with-param>
			<xsl:with-param name="script-name">events</xsl:with-param>
			<!-- 			<xsl:with-param name="debug" select="$dmc-debug" /> -->
		</xsl:call-template>
	</xsl:template>





	<xsl:template match="ou-component-faculty-items" expand-text="yes">
		<xsl:variable name="title" select="title"/>
		<xsl:variable name="feed" select="feed"/>
		<xsl:variable name="filters" select="tags"/>
		<xsl:variable name="param" select="conditional"/>
		<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
		<xsl:variable name="xpath">
			<xsl:text>items/item</xsl:text>
			<xsl:if test="$filters != '' and $feed != ''">
				<xsl:text>[</xsl:text>
				<xsl:for-each select="tokenize($filters, ',')">
					<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
					<xsl:if test="position() != last()">
						<xsl:value-of select="$logical-operator"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name="dmc" >
			<xsl:with-param name="options">
				<items_per_page>3</items_per_page>
				<datasource>{$feed}</datasource>
				<xpath>{$xpath}</xpath>
				<type>faculty_snap_shot</type>
				<title>{$title}</title>
			</xsl:with-param>
			<xsl:with-param name="script-name">faculty</xsl:with-param>
			<!-- 						<xsl:with-param name="debug" select="$dmc-debug" /> -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ou-component-testimonial-items" expand-text="yes">
		<xsl:variable name="title" select="title"/>
		<xsl:variable name="feed" select="feed"/>
		<xsl:variable name="filters" select="tags"/>
		<xsl:variable name="param" select="conditional"/>
		<xsl:variable name="logical-operator" select="if($param = 'all') then ' and ' else ' or '"/>
		<xsl:variable name="xpath">
			<xsl:text>items/item</xsl:text>
			<xsl:if test="$filters != '' and $feed != ''">
				<xsl:text>[</xsl:text>
				<xsl:for-each select="tokenize($filters, ',')">
					<xsl:value-of select="'category=&quot;' || normalize-space(.) || '&quot;'"/>
					<xsl:if test="position() != last()">
						<xsl:value-of select="$logical-operator"/>
					</xsl:if>
				</xsl:for-each>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<items_per_page>3</items_per_page>
				<datasource>{$feed}</datasource>
				<xpath>items/item</xpath>
				<type>testimonials_feature</type>
				<title>{$title}</title>
			</xsl:with-param>
			<xsl:with-param name="script-name">testimonials</xsl:with-param>
			<!-- 			<xsl:with-param name="debug" select="$dmc-debug" /> -->
		</xsl:call-template>
	</xsl:template>


	<!-- OU Calendar - Homepage Event List -->
	<xsl:template match="ouc:component[@name='ou-calendar-events']" expand-text="yes">
		<xsl:variable name="filter-predicate"
					  select="ou:get-filter-predicate(filter, 'categoryGroup/category', (ou:pcf-param('filter-option') = 'strict'))" />
		<xsl:variable name="xpath">
			<xsl:text>item</xsl:text>
			<xsl:value-of select="$filter-predicate" />
		</xsl:variable>
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<datasource>events</datasource>
				<xpath>{$xpath}</xpath>
				<type>homepage_events_list</type>
				<max>{limit}</max>
			</xsl:with-param>

			<xsl:with-param name="script-name">events</xsl:with-param>
<!-- 			<xsl:with-param name="debug" select="true()" /> -->
		</xsl:call-template>
	</xsl:template>











</xsl:stylesheet>