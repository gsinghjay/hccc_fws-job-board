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

	<!-- OU Calendar - Homepage Event List Test -->
	<xsl:template match="ouc:component[@name='ou-calendar-events-test']" expand-text="yes">
		<xsl:variable name="filter-predicate"
					  select="ou:get-filter-predicate(filter, 'categoryGroup/category', (ou:pcf-param('filter-option') = 'strict'))" />
		<xsl:variable name="xpath">
			<xsl:text>item</xsl:text>
			<xsl:value-of select="$filter-predicate" />
		</xsl:variable>
		<xsl:call-template name="dmc">
			<xsl:with-param name="options">
				<datasource>testcalevents</datasource>
				<xpath>item</xpath>
				<type>homepage_events_list</type>
				<max>{limit}</max>
			</xsl:with-param>

			<xsl:with-param name="script-name">calevents</xsl:with-param>
			<xsl:with-param name="debug" select="true()" />
		</xsl:call-template>
	</xsl:template>


	<!-- Contact Accordion -->
	<xsl:template match="ouc:component[@name='ou-contact-accordion']//div[@class='contact-accordion__col'][2]" mode="ouc-component">
		<div class="contact-accordion__col">
			<xsl:for-each select="./div[@class='acc']">
				<xsl:variable name="expand" select="if (position() = 1) then 'true' else 'false'"/>
				<xsl:variable name="hidden" select="if (position() = 1) then 'false' else 'true'"/>
				<xsl:variable name="display" select="if (position() = 1) then 'block' else 'none'"/>

				<div class="acc">
					<div class="acc__top">
						<xsl:choose>
							<xsl:when test=".//h3[@id='acc-title-1']/a/@href != ''">
								<h3 id="acc-title-{position()}" class="acc__title">
									<a href="#">
										<xsl:value-of select=".//h3[@id='acc-title-1']/text()"/>
									</a>
								</h3>
							</xsl:when>
							<xsl:otherwise>
								<h3 id="acc-title-{position()}" class="acc__title">
									<xsl:value-of select=".//h3[@id='acc-title-1']/text()"/>
								</h3>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<button class="acc__button" aria-labelledby="acc-title-{position()}" aria-expanded="{$expand}">
						<span></span>
					</button>

					<div class="acc__dropdown" aria-hidden="{$hidden}" style="display: {$display};">
						<p class="acc__details">
							<xsl:apply-templates select=".//p[@class='acc__details']/node()" />
						</p>

						<a class="acc__phone" href="tel:{replace(.//a[@class='acc__phone'], '\D+', '')}">
							<xsl:value-of select=".//a[@class='acc__phone']/text()"/>   
						</a>
						<xsl:value-of select="' '"/>
						<a class="acc__email" href="mailto:{.//a[@class='acc__email']}">
							<xsl:value-of select=".//a[@class='acc__email']/text()"/>
						</a>
					</div>
				</div>

			</xsl:for-each>
		</div>
	</xsl:template>
	<!-- /Contact Accordion -->
	

	
	<!-- Testimonial Carousel for Student Life and Leadership -->
<xsl:template match="ouc:component[@name='hccc-testimonial-carousel']">
    <div class="hccc-bs">
        <section class="hccc-bs-testimonials">
            <div class="container">
                <div id="hcccTestimonialCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover" data-bs-keyboard="true">
      
                    <div class="carousel-indicators">
                        <xsl:for-each select=".//article[contains(@class, 'carousel-item')]">
                            <button type="button" data-bs-target="#hcccTestimonialCarousel" data-bs-slide-to="{position()-1}">
                                <xsl:if test="position()=1">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                    <xsl:attribute name="aria-current">true</xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="aria-label">Slide <xsl:value-of select="position()"/></xsl:attribute>
                            </button>
                        </xsl:for-each>
                    </div>

                    <div class="carousel-inner">
                        <xsl:for-each select=".//article[contains(@class, 'carousel-item')]">
                            <div class="carousel-item{if (position()=1) then ' active' else ''}" data-bs-interval="10000">
                                <article class="hccc-bs-testimonial-item">
                                    <div class="row">
                                        <div class="col-md-4 hccc-bs-testimonial-image-wrapper">
                                            <img class="hccc-bs-testimonial-image rounded-circle" 
                                                 src="{.//img/@src}" 
                                                 alt="{.//img/@alt}" 
                                                 loading="lazy"/>
                                        </div>
                                        <div class="col-md-8">
                                            <blockquote class="hccc-bs-testimonial-content">
                                                <p class="hccc-bs-testimonial-quote">
                                                    <xsl:value-of select=".//p[@class='hccc-bs-testimonial-quote']/text()"/>
                                                </p>
                                                <footer class="hccc-bs-testimonial-author">
                                                    <xsl:value-of select=".//footer[@class='hccc-bs-testimonial-author']/text()"/>
                                                </footer>
                                            </blockquote>
                                        </div>
                                    </div>
                                </article>
                            </div>
                        </xsl:for-each>
                    </div>

      
                    <button class="carousel-control-prev" type="button" data-bs-target="#hcccTestimonialCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#hcccTestimonialCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </div>
        </section>
    </div>
</xsl:template>
<!-- /Testimonial Carousel for Student Life and Leadership -->

<!-- HCCC Timeline Component -->
<xsl:template match="ouc:component[@name='hccc-timeline']">
    <div class="hccc-bs">
        <div class="container-fluid">
            <div class="timeline-container">
                <div class="timeline">
                    <xsl:for-each select=".//year">
                        <div class="timeline-row">
                            <div class="timeline-segment">
                                <div class="year-marker">
                                    <xsl:value-of select="@value"/>
                                </div>
                                <div class="events-group">
                                    <xsl:for-each select=".//event">
                                        <div class="timeline-item card border-0 shadow-sm h-100 aspect-ratio-1x1 rounded-0">
                                            <img src="{image}" alt="{title}" class="card-img-top object-fit-cover rounded-0"/>
                                            <div class="card-body d-flex flex-column p-3">
                                                <div class="text-primary fw-semibold small mb-1">
                                                    <xsl:value-of select="date"/>
                                                </div>
                                                <h4 class="card-title h6 mb-1"><xsl:value-of select="title"/></h4>
                                                <p class="card-text small text-secondary mb-0"><xsl:value-of select="description"/></p>
                                            </div>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
    </div>

    <!-- Add the JavaScript for connecting lines -->
    <script>
        function adjustConnectingLines() {
            const yearGroups = document.querySelectorAll('.events-group');
            yearGroups.forEach(group => {
                const timelineItems = group.querySelectorAll('.timeline-item');
                timelineItems.forEach((item, index) => {
                    if (index === 0) return;
                    const lineContainer = document.createElement('div');
                    lineContainer.className = 'connecting-line-container';
                    const line = document.createElement('div');
                    line.className = 'connecting-line';
                    lineContainer.appendChild(line);
                    item.parentNode.insertBefore(lineContainer, item);
                });
            });
        }
        document.addEventListener('DOMContentLoaded', adjustConnectingLines);
    </script>
</xsl:template>
<!-- /HCCC Timeline Component -->
	


<!-- debug(STRUCTURE)
<xsl:template match="ouc:component[@name='hccc-fws-jobs']">
    <div>
        Debug: XML Structure
        <pre>
            <xsl:copy-of select="ou:include-file('/_resources/data/fws_jobs.xml')"/>
        </pre>
    </div>
</xsl:template>
-->
	

<!-- debug(OUTPUT): FWS Jobs Board Component
<xsl:template match="ouc:component[@name='hccc-fws-jobs']">
    <div>
        Debug: Output of `ou:include-file`:
        <xsl:copy-of select="ou:include-file('/_resources/data/fws_jobs.xml')"/>
    </div>
</xsl:template>
-->

<!-- FWS Jobs Board Component -->
<xsl:template match="ouc:component[@name='hccc-fws-jobs']">
    <xsl:choose>
        <!-- Handle staging mode -->
        <xsl:when test="not($ou:action = 'pub')">
            <div class="alert alert-info" role="alert">
                <strong>Staging Notice:</strong> This Federal Work Study Jobs component can only be viewed on the production server.
            </div>
        </xsl:when>
        
        <!-- Handle production mode -->
        <xsl:otherwise>
            <xsl:text disable-output-escaping="yes">&lt;?php 
            require_once($_SERVER['DOCUMENT_ROOT'] . '/_resources/dmc/php/fws_jobs.php');
            echo get_fws_jobs_dmc_output(array());
            ?&gt;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>






</xsl:stylesheet>