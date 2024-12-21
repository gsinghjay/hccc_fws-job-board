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
Implementation Skeleton - 08/24/2018

Snippets XSL
Customer Snippets
-->

<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" expand-text="yes"
				exclude-result-prefixes="xs ou fn ouc">

	<!--// Pattern WYSIWYG -->

	<xsl:template match="table[@data-snippet = 'ou-image-caption']" expand-text="yes">
		<xsl:variable name="image" select="ou:get-value(tbody/tr/td[@data-name = 'image'])"/>
		<xsl:variable name="caption" select="ou:get-value(tbody/tr/td[@data-name = 'caption'])"/>
		<xsl:variable name="class" select="ou:get-value(tbody/tr/td[@data-name = 'style'])"/>
		<figure class="img-inline img-inline--full">
			<xsl:if test="$class">
				<xsl:attribute name="class">img-inline {$class}</xsl:attribute>
			</xsl:if>
			<img>
				<xsl:apply-templates select="$image/attribute()"/>
			</img>
			<xsl:if test="$caption">
				<figcaption>
					<xsl:apply-templates select="$caption"/>
				</figcaption>
			</xsl:if>
		</figure>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-video-caption']" expand-text="yes">
		<xsl:variable name="video" select="tbody/tr/td[@data-name = 'video']"/>
		<xsl:variable name="image" select="ou:get-value(tbody/tr/td[@data-name = 'image'])"/>
		<xsl:variable name="caption" select="ou:get-value(tbody/tr/td[@data-name = 'caption'])"/>

		<xsl:variable name="video-src">
			<xsl:choose>
				<xsl:when test="$video/descendant::video/@src">{tbody/tr[1]/td[1]/descendant::video/@src}?enablejsapi=1</xsl:when>
				<xsl:when test="$video/descendant::iframe/@src">{tbody/tr[1]/td[1]/descendant::iframe/@src}?enablejsapi=1</xsl:when>
				<xsl:otherwise>{$video/text()}?enablejsapi=1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="vid-inline vid-inline--full">
			<div class="vid-inline__container">
				<div class="vid-inline__cover" tabindex="0">
					<img>
						<xsl:apply-templates select="$image/attribute()"/>
					</img>
				</div>
				<div class="vid-inline__embed">
					<iframe tabindex="-1" src="{$video-src}" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen="allowfullscreen"> </iframe>
				</div>
			</div>
			<xsl:if test="$caption">
				<div class="vid-inline__caption">
					<xsl:apply-templates select="$caption"/>
				</div>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-quote']" expand-text="yes">
		<xsl:variable name="quote" select="ou:get-value(tbody/tr/td[@data-name = 'quote'])"/>
		<xsl:variable name="author" select="ou:get-value(tbody/tr/td[@data-name = 'author'])"/>
		<xsl:variable name="info" select="ou:get-value(tbody/tr/td[@data-name = 'info'])"/>

		<blockquote class="quote quote--full">
			<div class="quote__copy">
				<xsl:apply-templates select="$quote"/>
			</div>
			<xsl:if test="$info or $author">
				<footer class="quote__footer">
					<xsl:if test="$author">
						<div class="quote__attr">
							<xsl:apply-templates select="$author"/>
						</div>
					</xsl:if>
					<xsl:if test="$info">
						<div class="quote__info">{$info}</div>
					</xsl:if>
				</footer>
			</xsl:if>
		</blockquote>

	</xsl:template>

	<!--// Pattern WYSIWYG -->

	<xsl:template match="table[@data-snippet = 'ou-3-up-cards']" expand-text="yes">
		<div class="card-group">
			<div class="card">
				<img class="card-img-top">
					<xsl:copy-of select="tbody/tr[1]/td[1]/descendant::img/attribute()[not(name() = ('width', 'height', 'class'))]"/>
				</img>
				<div class="card-body">
					<p style="font-size:24px;" class="card-title">{ou:textual-content(tbody/tr[2]/td[1])}</p>
					<p class="card-text">{ou:textual-content(tbody/tr[3]/td[1])}</p>
				</div>
			</div>
			<div class="card">
				<img class="card-img-top">
					<xsl:copy-of select="tbody/tr[1]/td[2]/descendant::img/attribute()[not(name() = ('width', 'height', 'class'))]"/>
				</img>
				<div class="card-body">
					<p style="font-size:24px;" class="card-title">{ou:textual-content(tbody/tr[2]/td[2])}</p>
					<p class="card-text">{ou:textual-content(tbody/tr[3]/td[2])}</p>
				</div>
			</div>
			<div class="card">
				<img class="card-img-top">
					<xsl:copy-of select="tbody/tr[1]/td[3]/descendant::img/attribute()[not(name() = ('width', 'height', 'class'))]"/>
				</img>
				<div class="card-body">
					<p style="font-size:24px;" class="card-title">{ou:textual-content(tbody/tr[3]/td[3])}</p>
					<p class="card-text">{ou:textual-content(tbody/tr[3]/td[3])}</p>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-testimonials']">
		<section>
			<div id="carouselExampleCaptions" class="carousel slide" data-ride="carousel">
				<div class="carousel-inner">
					<xsl:apply-templates select="tbody/tr"/>
				</div>
				<a class="carousel-control-prev" href="#carouselExampleCaptions" role="button" data-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"/>
					<span class="sr-only">Previous</span>
				</a>
				<a class="carousel-control-next" href="#carouselExampleCaptions" role="button" data-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"/>
					<span class="sr-only">Next</span>
				</a>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-testimonials']/tbody/tr">
		<div class="carousel-item">
			<xsl:if test="position() = 1">
				<xsl:attribute name="class">carousel-item active</xsl:attribute>
			</xsl:if>
			<img class="d-block w-100" src="{td[3]/descendant::img/@src}" alt="{td[3]/descendant::img/@alt}"/>
			<div class="carousel-caption d-none d-md-block">
				<p style="font-size:20px;">{td[1]/node()}</p>
				<p>
					<em>"{td[2]/node()}"</em>
				</p>
			</div>
		</div>
	</xsl:template>



	<xsl:template match="table[@data-snippet = 'ou-program-finder-cta']">
		<xsl:variable name="link" select="tbody/tr[3]/td[1]/descendant::a/@href"/>
		<xsl:variable name="link-text" select="tbody/tr[3]/td[1]/descendant::a/."/>
		<div class="card text-center">
			<div class="card-body">
				<p style="font-size:20px;" class="card-title">
					<xsl:value-of select="tbody/tr[1]/td[1]/."/>
				</p>
				<p class="card-text">
					<xsl:value-of select="tbody/tr[2]/td[1]/."/>
				</p>
				<a href="{$link}" class="btn btn-primary"><xsl:apply-templates select="tbody/tr[3]/td[1]/descendant::a/attribute()[name() != 'class']"/>{$link-text}</a>
			</div>
		</div>
	</xsl:template>


	<xsl:template match="table[@data-snippet = 'ou-stats']">
		<div class="row row-cols-1 row-cols-md-3 ou-padding">
			<div class="col mb-4">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">
							<xsl:value-of select="tbody/tr[1]/td[1]"/>
						</h5>
						<p class="card-text">
							<xsl:value-of select="tbody/tr[2]/td[1]"/>
						</p>
					</div>
				</div>
			</div>
			<div class="col mb-4">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">
							<xsl:value-of select="tbody/tr[1]/td[2]"/>
						</h5>
						<p class="card-text">
							<xsl:value-of select="tbody/tr[2]/td[2]"/>
						</p>
					</div>
				</div>
			</div>
			<div class="col mb-4">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">
							<xsl:value-of select="tbody/tr[1]/td[3]"/>
						</h5>
						<p class="card-text">
							<xsl:value-of select="tbody/tr[2]/td[3]"/>
						</p>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>


	<xsl:template match="table[@class = 'ou-snippet-two-column-content']">
		<div class="row mx-md-n5">
			<div class="col px-md-5">
				<div class="p-3 border bg-light">
					<xsl:apply-templates select="tbody/tr[1]/td[1]/node()"/>
				</div>
			</div>
			<div class="col px-md-5">
				<div class="p-3 border bg-light">
					<xsl:apply-templates select="tbody/tr[1]/td[2]/node()"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="table[@class = 'ou-snippet-three-column-content']">
		<div class="container">
			<div class="row">
				<div class="col-sm">
					<xsl:apply-templates select="tbody/tr[1]/td[1]/node()"/>
				</div>
				<div class="col-sm">
					<xsl:apply-templates select="tbody/tr[1]/td[2]/node()"/>
				</div>
				<div class="col-sm">
					<xsl:apply-templates select="tbody/tr[1]/td[3]/node()"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="table[@class = 'ou-snippet-tabs']">
		<!-- 		<xsl:variable name="uq" select="generate-id(.)" /> -->
		<ul class="nav nav-tabs" id="myTab" role="tablist">
			<xsl:for-each select="tbody/tr">
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="id" select="td[1]/."/>
				<li class="nav-item">
					<a class="nav-link" id="{$id}-tab" data-toggle="tab" href="#{$id}" role="tab" aria-controls="{$id}" aria-selected="false">
						<xsl:if test="$pos = 1">
							<xsl:attribute name="class">nav-link active</xsl:attribute>
							<xsl:attribute name="aria-expanded">true</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="td[1]/node()"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<div class="tab-content" id="myTabContent">
			<xsl:for-each select="tbody/tr">
				<xsl:variable name="pos" select="position()"/>
				<xsl:variable name="id" select="td[1]/."/>
				<div class="tab-pane fade show" id="{$id}" role="tabpanel" aria-labelledby="{$id}-tab">
					<xsl:if test="$pos = 1">
						<xsl:attribute name="class">tab-pane fade show active</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="td[2]/node()"/>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>



	<xsl:template match="table[@class = 'ou-snippet-data-tables']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="table[@class = 'ou-snippet-blockquote']">
		<blockquote class="blockquote">
			<p class="mb-0">
				<xsl:apply-templates select="tbody/tr[1]/td[1]/node()"/>
			</p>
		</blockquote>
	</xsl:template>


	<xsl:template match="table[@data-snippet = 'ou-columns']">
		<xsl:param name="rows" select="tbody/tr[@data-name = 'row'][ou:not-empty(.)]"/>

		<xsl:variable name="row-width">12</xsl:variable>

		<xsl:for-each select="$rows">
			<xsl:variable name="columns" select="count(td[@data-name = 'content'])"/>
			<xsl:variable name="col-width" select="$row-width idiv $columns"/>

			<div class="row">
				<xsl:for-each select="td[@data-name = 'content']">
					<div class="col-md-{$col-width}">
						<xsl:apply-templates select="node()"/>
					</div>
				</xsl:for-each>
			</div>
		</xsl:for-each>
	</xsl:template>

	<!-- Accordion Element -->
	<xsl:template match="table[@data-snippet = 'ou-accordion']">
		<xsl:param name="expand-panel" select="ou:get-value(tbody/tr/td[@data-name = 'expand-panel'])"/>
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="ou:textual-content(tbody/tr[2]/td[@data-name='intro']/node())"/>

		<xsl:variable name="accordion-id" select="'accordion-' || generate-id()"/>
		<xsl:if test="$items[ou:get-value(td[@data-name = 'heading'])]">
			<section class="section accordion">
				<xsl:if test='$header'>
					<div class="section__header accordion__header">
						<h2>{$header}</h2>
					</div>
				</xsl:if>
				<xsl:if test='$intro'>
					<div class="section__intro accordion__intro">{$intro}</div>
				</xsl:if>
				<div class="accordion__all"><button class="accordion__expand-all">Expand All</button> <button class="accordion__collapse-all">Collapse All</button></div>
				<div class="accordion__items">
					<xsl:for-each select="$items">
						<xsl:variable name="heading" select="ou:get-value(td[@data-name = 'heading'])"/>
						<xsl:variable name="content" select="ou:get-value(td[@data-name = 'content'])"/>
						<xsl:if test="$heading">
							<div class="accordion__item">
								<button class="accordion__toggle" aria-expanded="false">
									<xsl:choose>
										<xsl:when test="$expand-panel = position()">
											<xsl:attribute name="aria-expanded">true</xsl:attribute>
											<xsl:attribute name="class">accordion__toggle js-expanded</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="aria-expanded">false</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>{$heading}<span class="accordion__icon"></span> </button>
								<div class="accordion__content">
									<xsl:if test="$expand-panel = position()">
										<xsl:attribute name="style">display: block;</xsl:attribute>
									</xsl:if>
									<xsl:apply-templates select="$content"/>
									<button class="accordion__top">Back to Top</button></div>
							</div>

						</xsl:if>
					</xsl:for-each>
				</div>
			</section>
		</xsl:if>
	</xsl:template>




	<xsl:template match="table[@data-snippet = 'ou-tabs']">
		<xsl:param name="tab-shown" select="ou:get-value(tbody/tr/td[@data-name = 'tab-shown'])"/>
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<xsl:variable name="valid-tab-shown" as="xs:numeric">
			<xsl:choose>
				<xsl:when test="$tab-shown and ou:get-value($items[$tab-shown]/td[@data-name = 'heading'])">
					<xsl:copy-of select="$tab-shown"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$items[ou:get-value(td[@data-name = 'heading'])]">
			<xsl:variable name="nav-id" select="'tab-' || generate-id() || '-nav'"/>
			<xsl:variable name="content-id" select="'tab-' || generate-id() || '-content'"/>
			<div>
				<ul class="nav nav-tabs" role="tablist">
					<xsl:for-each select="$items">
						<xsl:variable name="heading" select="ou:get-value(td[@data-name = 'heading'])"/>
						<xsl:variable name="item-id" select="'item-' || generate-id()"/>
						<xsl:variable name="tab-id" select="$item-id || '-tab'"/>

						<li class="nav-item">
							<a class="nav-link" id="{$tab-id}" data-toggle="tab" href="#{$item-id}" role="tab" aria-controls="{$item-id}" aria-selected="false">
								<xsl:if test="position() = $valid-tab-shown">
									<xsl:attribute name="class">nav-link active</xsl:attribute>
									<xsl:attribute name="aria-selected">true</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="$heading"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>

				<div class="tab-content">
					<xsl:for-each select="$items">
						<xsl:variable name="heading" select="ou:get-value(td[@data-name = 'heading'])"/>
						<xsl:variable name="content" select="ou:get-value(td[@data-name = 'content'])"/>

						<xsl:variable name="item-id" select="'item-' || generate-id()"/>
						<xsl:variable name="tab-id" select="$item-id || '-tab'"/>

						<xsl:if test="$heading">
							<div class="tab-pane fade" id="{$item-id}" role="tabpanel" aria-labelledby="{$tab-id}">
								<xsl:if test="position() = $valid-tab-shown">
									<xsl:attribute name="class">tab-pane fade show active</xsl:attribute>
								</xsl:if>
								<xsl:apply-templates select="$content"/>
							</div>
						</xsl:if>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
	</xsl:template>


	<xsl:template match="table[@data-snippet = 'ou-image-card']">
		<div class="card mb-3" style="max-width: 540px;">
			<div class="row no-gutters">
				<div class="col-md-4">
					<xsl:variable name="image" select="tbody[1]/tr[1]/td[1]/descendant::img/@src"/>
					<xsl:variable name="image-alt" select="tbody[1]/tr[1]/td[1]/descendant::img/@alt"/>
					<img src="{$image}" class="card-img" alt="{$image-alt}"/>
				</div>
				<div class="col-md-8">
					<div class="card-body">
						<p style="font-size:18px;" class="card-title">
							<xsl:value-of select="tbody/tr[2]/td[1]/."/>
						</p>
						<p class="card-text">
							<xsl:apply-templates select="tbody/tr[3]/td[1]/node()"/>
						</p>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="table[@class = 'ou-snippet-space']">
		<span class="ou-space"/>
	</xsl:template>

	<xsl:template match="table[@class = 'ou-snippet-space-2x']">
		<span class="ou-space-2x"/>
	</xsl:template>


	<!-- Banner with 1 Stat -->
	<xsl:template match="table[@class = 'ou-banner-stat']" expand-text="yes">
		<xsl:variable name="intro" select="ou:textual-content(tbody/tr[1]/td[@data-name='intro']/node())"/>

		<!-- Banner Variables -->
		<xsl:variable name="bg-img" select="tbody/tr[4]/td[@data-name='bg']/descendant::img/@src"/>
		<xsl:variable name="number" select="tbody/tr[4]/td[@data-name='number']/node()"/>
		<xsl:variable name="number-graphic" select="tbody/tr[4]/td[@data-name='num-graphic']/node()"/>
		<xsl:variable name="caption" select="tbody/tr[4]/td[@data-name='caption']/node()"/>
		<xsl:variable name="cta" select="tbody/tr[4]/td[@data-name='cta']/descendant::a"/>


		<!-- Stat Variables -->
		<xsl:variable name="stat-img" select="tbody/tr[7]/td[@data-name='image']/descendant::img/@src"/>
		<xsl:variable name="stat-number" select="tbody/tr[7]/td[@data-name='number']/node()"/>
		<xsl:variable name="stat-caption" select="tbody/tr[7]/td[@data-name='caption']/node()"/>
		<xsl:variable name="stat-cta" select="tbody/tr[7]/td[@data-name='cta']/descendant::a"/>


		<section class="focus-section">
			<xsl:if test="$intro !=''">
				<h2>{$intro}</h2>
			</xsl:if>
			<div class="focus-section__intro" style="background-image: url({$bg-img});">
				<xsl:if test="$number-graphic = 'true'">
					<xsl:attribute name="class">focus-section__intro numbers</xsl:attribute>
				</xsl:if>
				<div class="text-holder">
					<xsl:if test="$number !=''">
						<span class="focus-section__number"><span>{$number}</span></span>
					</xsl:if>
					<xsl:if test="$caption !=''">
						<p>{$caption}</p>
					</xsl:if>
					<xsl:if test="$cta != ''">
						<a href="{$cta/@href}" class="cta cta--button">
							<xsl:apply-templates select="$cta/attribute()"/>
							{$cta}</a>
					</xsl:if>
				</div>
			</div>
			<div class="focus-section__holder">
				<div class="focus-section__visual" style="background-image: url({$stat-img});"></div>
				<div class="focus-section__info">
					<div class="focus-section__info-holder">
						<xsl:if test="$stat-number !=''">
							<span class="focus-section__number">{$stat-number}</span>
						</xsl:if>
						<xsl:if test="$stat-caption !=''">
							<p>{$stat-caption}</p>
						</xsl:if>
						<xsl:if test="$stat-cta != ''">
							<a href="{$stat-cta/@href}" class="cta cta--button">
								<xsl:apply-templates select="$stat-cta/attribute()"/>
								{$stat-cta}</a>
						</xsl:if>
					</div>
				</div>
			</div>
		</section>

	</xsl:template>


	<!-- Banner with 2 Stats -->
	<xsl:template match="table[@class = 'ou-banner-stat-2']" expand-text="yes">
		<xsl:variable name="items" select="tbody/tr[@data-name='item']"/>

		<xsl:variable name="intro" select="ou:textual-content(tbody/tr[1]/td[@data-name='intro']/node())"/>

		<!-- Banner Variables -->
		<xsl:variable name="bg-img" select="tbody/tr[4]/td[@data-name='bg']/descendant::img/@src"/>
		<xsl:variable name="number" select="tbody/tr[4]/td[@data-name='number']/node()"/>
		<xsl:variable name="number-graphic" select="tbody/tr[4]/td[@data-name='num-graphic']/node()"/>
		<xsl:variable name="caption" select="tbody/tr[4]/td[@data-name='caption']/node()"/>
		<xsl:variable name="cta" select="tbody/tr[4]/td[@data-name='cta']/descendant::a"/>


		<section class="focus-section">
			<xsl:if test="$intro !=''">
				<h2>{$intro}</h2>
			</xsl:if>
			<div class="focus-section__intro" style="background-image: url({$bg-img});">
				<xsl:if test="$number-graphic = 'true'">
					<xsl:attribute name="class">focus-section__intro numbers</xsl:attribute>
				</xsl:if>
				<div class="text-holder">
					<xsl:if test="$number !=''">
						<span class="focus-section__number"><span>{$number}</span></span>
					</xsl:if>
					<xsl:if test="$caption !=''">
						<p>{$caption}</p>
					</xsl:if>
					<xsl:if test="$cta != ''">
						<a href="{$cta/@href}" class="cta cta--button">
							<xsl:apply-templates select="$cta/attribute()"/>
							{$cta}</a>
					</xsl:if>
				</div>
			</div>
			<div class="focus-section__holder">
				<xsl:for-each select="$items">
					<!-- Stat Variables -->
					<xsl:variable name="stat-number" select="td[@data-name='number']/node()"/>
					<xsl:variable name="stat-caption" select="td[@data-name='caption']/node()"/>
					<xsl:variable name="stat-cta" select="td[@data-name='cta']/descendant::a"/>
					<div class="focus-section__info">
						<div class="focus-section__info-holder">
							<xsl:if test="$stat-number !=''">
								<span class="focus-section__number">{$stat-number}</span>
							</xsl:if>
							<xsl:if test="$stat-caption !=''">
								<p>{$stat-caption}</p>
							</xsl:if>
							<xsl:if test="$stat-cta != ''">
								<a href="{$stat-cta/@href}" class="cta cta--button">
									<xsl:apply-templates select="$stat-cta/attribute()"/>
									{$stat-cta}</a>
							</xsl:if>
						</div>
					</div>	
				</xsl:for-each>
			</div>
		</section>

	</xsl:template>

	<!-- Alternating Stats Snippet -->
	<xsl:template match="table[@class = 'ou-banner-alter-stat']" expand-text="yes">
		<xsl:variable name="items" select="tbody/tr[@data-name='item']"/>

		<xsl:variable name="intro" select="ou:textual-content(tbody/tr[1]/td[@data-name='intro']/node())"/>


		<section class="focus-section">
			<xsl:if test="$intro !=''">
				<h2>{$intro}</h2>
			</xsl:if>
			<div class="focus-section__row-block">
				<xsl:for-each select="$items">
					<!-- Stat Variables -->
					<xsl:variable name="position" select="td[@data-name='position']/node()"/>
					<xsl:variable name="number" select="td[@data-name='number']/node()"/>
					<xsl:variable name="image" select="td[@data-name='image']/descendant::img/@src"/>
					<xsl:variable name="caption" select="td[@data-name='caption']/node()"/>
					<xsl:variable name="cta" select="td[@data-name='cta']/descendant::a"/>
					<xsl:choose>
						<xsl:when test="$position = 'right'">
							<div class="focus-section__row">
								<div class="focus-section__info">
									<div class="focus-section__info-holder"><span class="focus-section__number">{$number}</span>
										<xsl:if test="$caption !=''">
											<p>{$caption}</p>
										</xsl:if>
									</div>
								</div>
								<div class="focus-section__visual" style="background-image: url('{$image}');">&nbsp;</div>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="focus-section__row">
								<div class="focus-section__visual" style="background-image: url('{$image}');">&nbsp;</div>
								<div class="focus-section__info">
									<div class="focus-section__info-holder"><span class="focus-section__number">{$number}</span>
										<xsl:if test="$caption !=''">
											<p>{$caption}</p>
										</xsl:if>
										<xsl:if test="$cta != ''">
											<a href="{$cta/@href}" class="cta cta--button">
												<xsl:apply-templates select="$cta/attribute()"/>
												{$cta}</a>
										</xsl:if>
									</div>
								</div>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</div>
		</section>

	</xsl:template>


	<!-- Apply Section -->
	<xsl:template match="table[@class = 'ou-apply-section']">
		<xsl:variable name="image" select="ou:get-value(tbody/tr/td[@data-name = 'image'])/@src"/>
		<xsl:variable name="buttons" select="tbody/tr/td[@data-name = 'buttons']"/>
		<xsl:variable name="title" select="ou:get-value(tbody/tr/td[@data-name = 'title'])"/>
		<section class="apply-section" style="background-image: url({$image});">
			<div class="apply-section__content">
				<h2>{$title}</h2>
				<ul>
					<xsl:for-each select="$buttons//li">
						<li>
							<a href="#" class="cta cta--button">
								<xsl:apply-templates select="a/attribute()[name() != 'class'] | a/node()"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</div>
		</section>
	</xsl:template>




	<!-- Success Stories -->
	<xsl:template match="table[@class = 'ou-banner-success-stories']" expand-text="yes">
		<xsl:variable name="items" select="tbody/tr[@data-name='item']"/>

		<div class="students-success__stories-block">
			<xsl:for-each select="$items">
				<!-- Stat Variables -->
				<xsl:variable name="image" select="td[@data-name='image']/descendant::img"/>
				<xsl:variable name="name" select="td[@data-name='name']/node()"/>
				<xsl:variable name="quote" select="td[@data-name='quote']/node()"/>
				<div class="students-success__stories-box">
					<div class="students-success__stories-visual">
						<div class="students-success__stories-visual-holder">
							<div class="students-success__stories-visual-wrapper">
								<xsl:apply-templates select="$image"/>
							</div>
						</div>
					</div>
					<div class="students-success__content">
						<blockquote>
							<xsl:if test="$name !=''">
								<cite>{$name}</cite>
							</xsl:if>
							<xsl:if test="$quote !=''">
								<q>{$quote}</q>
							</xsl:if>
						</blockquote>
					</div>
				</div>
			</xsl:for-each>
			<ul class="pagination">
				<xsl:for-each select="$items">
					<li><span></span></li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>


	<!-- Stories Revised Version from 'Pathways'. This includes bg color -->

	<xsl:template match="table[@class = 'ou-stories-section']" expand-text="yes">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>
		<!-- Top Element Variables -->
		<xsl:variable name="header" select="tbody/tr/td[@data-name = 'header']/node()"/>
		<xsl:variable name="intro" select="tbody/tr/td[@data-name = 'intro']/node()"/>
		<xsl:variable name="bg-color" select="tbody/tr/td[@data-name = 'bg-color']/node()"/>
		<section class="stories-section">
			<xsl:if test="$bg-color = 'teal'">
				<xsl:attribute name="class">stories-section stories-section_teal</xsl:attribute>
			</xsl:if>
			<div class="container-holder">
				<xsl:if test="$header or $intro">
					<div class="stories-section__heading">
						<xsl:if test="$header">
							<h2>{$header}</h2>
						</xsl:if>
						<xsl:apply-templates select="$intro"/>
					</div>
				</xsl:if>
			</div>
			<ul class="stories-section__list">
				<xsl:for-each select="$items">
					<xsl:variable name="image" select="ou:get-value(td[@data-name = 'image'])/descendant::img/@src"/>
					<xsl:variable name="link" select="td[@data-name = 'image']/descendant::a"/>
					<xsl:variable name="title" select="ou:get-value(td[@data-name = 'title'])"/>
					<li>
						<a href="{$link}" style="background-image: url({$image});">
							<xsl:apply-templates select="$link/attribute()[name() != 'style']"/>
							<h3>{$title}</h3>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</section>
	</xsl:template>



	<xsl:template match="table[@class='ou-calendar-3-up']">
		<section class="section events3up">
			<div class="section__header events3up__header">
				<h2>{tbody/tr[@data-row='heading']/td}</h2>
			</div>
			<div class="section__intro events3up__intro">
				{tbody/tr[@data-row='summary']/td}
			</div>
			<div class="column column--three">

				<!-- dmc -->
				<xsl:variable name="filter-predicate"
							  select="ou:get-filter-predicate(tbody/tr[@data-row='filter']/td, 'categoryGroup/category', true())" />

				<xsl:variable name="xpath">
					<xsl:text>item</xsl:text>
					<xsl:value-of select="$filter-predicate" />
				</xsl:variable>

				<xsl:call-template name="dmc">
					<xsl:with-param name="options">
						<datasource>events</datasource>
						<xpath>{$xpath}</xpath>
						<type>generic_events_list</type>
						<max>3</max>
					</xsl:with-param>

					<xsl:with-param name="script-name">events</xsl:with-param>
<!-- 										<xsl:with-param name="debug" select="true()" /> -->
				</xsl:call-template>


			</div>
			<xsl:if test="tbody/tr[@data-row='button']/td/a/@href != ''">
				<div class="section__cta events3up__section-cta">
					<a class="cta cta--button" href="{tbody/tr[@data-row='button']/td/a/@href}">More Events</a>
				</div>
			</xsl:if>
		</section>
	</xsl:template>

	<!-- jsingh: DEFAULT column layout, DO NOT TOUCH -->
	
	<xsl:template match="table[@class = 'ou-snippet-column-content']">
		<!-- # of Columns -->
		<xsl:variable name="col-qty" select="count(tbody/tr[4]/td[@data-name='content'])"/>
		<xsl:variable name="col-num">
			<xsl:choose>
				<xsl:when test="$col-qty = 2">two</xsl:when>
				<xsl:otherwise>three</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>

		<!-- Column 1 Variables -->
		<xsl:variable name="img-col1" select="tbody/tr[4]/td[1]/descendant::img"></xsl:variable>
		<xsl:variable name="img-link-col1" select="tbody/tr[4]/td[1]/descendant::a"></xsl:variable>
		<xsl:variable name="header-col1" select="tbody/tr[5]/td[1]"></xsl:variable>		

		<!-- Column 2 Variables -->
		<xsl:variable name="img-col2" select="tbody/tr[4]/td[2]/descendant::img"></xsl:variable>
		<xsl:variable name="img-link-col2" select="tbody/tr[4]/td[2]/descendant::a"></xsl:variable>
		<xsl:variable name="header-col2"  select="tbody/tr[5]/td[2]"></xsl:variable>

		<!-- Column 3 Variables -->
		<xsl:variable name="img-col3" select="tbody/tr[4]/td[3]/descendant::img"></xsl:variable>
		<xsl:variable name="img-link-col3" select="tbody/tr[4]/td[3]/descendant::a"></xsl:variable>
		<xsl:variable name="header-col3"  select="tbody/tr[5]/td[3]"></xsl:variable>

		<section class="section gen{$col-qty}col">
			<xsl:if test="$header != ''">
				<div class="section__header gen{$col-qty}col__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test="$intro != ''">
				<div class="section__intro gen{$col-qty}col__intro">{$intro}</div>
			</xsl:if>
			<div class="column column--{$col-num}">
				<div class="column__col">
					<xsl:if test="$img-col1/@src != ''">
						<div class="column__img">
							<xsl:choose>
								<xsl:when test="$img-link-col1/@href != ''">
									<a href="{$img-link-col1/@href}"><img src="{$img-col1/@src}" alt="{$img-col1/@alt}" /></a>
								</xsl:when>
								<xsl:otherwise>
									<img src="{$img-col1/@src}" alt="{$img-col1/@alt}" />
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:if>
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col1/node() !=''">
							<div class="column__title">
								<h3><xsl:choose>
									<xsl:when test="$header-col1/descendant::a/@href != ''">
										<a href="{$header-col1/descendant::a/@href}">{$header-col1/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col1)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[1]/node()'>
							<div class="column__body"><xsl:apply-templates select="tbody/tr[6]/td[1]/node()"/></div>
						</xsl:if>
					</div>
				</div>
				<div class="column__col">
					<xsl:if test="$img-col2/@src != ''">
						<div class="column__img">
							<xsl:choose>
								<xsl:when test="$img-link-col2/@href != ''">
									<a href="{$img-link-col2/@href}"><img src="{$img-col2/@src}" alt="{$img-col2/@alt}" /></a>
								</xsl:when>
								<xsl:otherwise>
									<img src="{$img-col2/@src}" alt="{$img-col2/@alt}" />
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:if>
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col2/node() !=''">
							<div class="column__title">
								<h3><xsl:choose>
									<xsl:when test="$header-col2/descendant::a/@href != ''">
										<a href="{$header-col2/descendant::a/@href}">{$header-col2/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col2)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[2]/node()'>
							<div class="column__body"><xsl:apply-templates select="tbody/tr[6]/td[2]/node()"/></div>
						</xsl:if>
					</div>
				</div>
				<xsl:if test="$col-qty = 3">
					<div class="column__col">
						<xsl:if test="$img-col3/@src != ''">
							<div class="column__img">
								<xsl:choose>
									<xsl:when test="$img-link-col3/@href != ''">
										<a href="{$img-link-col3/@href}"><img src="{$img-col3/@src}" alt="{$img-col3/@alt}" /></a>
									</xsl:when>
									<xsl:otherwise>
										<img src="{$img-col3/@src}" alt="{$img-col3/@alt}" />
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</xsl:if>
						<div>
							<xsl:if test='$col-qty = 3'>
								<xsl:attribute name="class">column__content</xsl:attribute>	
							</xsl:if>
							<xsl:if test="$header-col3/node() !=''">
								<div class="column__title">
									<h3><xsl:choose>
										<xsl:when test="$header-col3/descendant::a/@href != ''">
											<a href="{$header-col3/descendant::a/@href}">{$header-col3/descendant::a}</a>
										</xsl:when>
										<xsl:otherwise>
											{ou:textual-content($header-col3)}
										</xsl:otherwise>
										</xsl:choose>
									</h3>
								</div>
							</xsl:if>
							<xsl:if test='tbody/tr[6]/td[3]/node()'>
								<div class="column__body"><xsl:apply-templates select="tbody/tr[6]/td[3]/node()"/></div>
							</xsl:if>
						</div>
					</div>
				</xsl:if>
			</div>
		</section>
	</xsl:template>
	
	<!-- jsingh: removed image from the default 2 and 3 column layouts -->
	
	<xsl:template match="table[@class = 'ou-snippet-column-content-noimg']">
		<!-- # of Columns -->
		<xsl:variable name="col-qty" select="count(tbody/tr[4]/td[@data-name='content'])"/>
		<xsl:variable name="col-num">
			<xsl:choose>
				<xsl:when test="$col-qty = 2">two</xsl:when>
				<xsl:otherwise>three</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>

		<!-- Column 1 Variables -->
		<xsl:variable name="header-col1" select="tbody/tr[4]/td[1]"></xsl:variable>		

		<!-- Column 2 Variables -->
		<xsl:variable name="header-col2"  select="tbody/tr[4]/td[2]"></xsl:variable>

		<!-- Column 3 Variables -->
		<xsl:variable name="header-col3"  select="tbody/tr[4]/td[3]"></xsl:variable>

		<section class="section gen-noimg{$col-qty}col">
			<xsl:if test="$header != ''">
				<div class="section__header gen-noimg{$col-qty}col__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test="$intro != ''">
				<div class="section__intro gen-noimg{$col-qty}col__intro">{$intro}</div>
			</xsl:if>
			<div class="column column--{$col-num}">
				<div class="column__col">				
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col1/node() !=''">
							<div class="column__title">
								<h3><xsl:choose>
									<xsl:when test="$header-col1/descendant::a/@href != ''">
										<a href="{$header-col1/descendant::a/@href}">{$header-col1/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col1)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[1]/node()'>
						   <div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[1]/node()"/></div>
						</xsl:if>
					</div>
				</div>
				<div class="column__col">		
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col2/node() !=''">
							<div class="column__title">
								<h3><xsl:choose>
									<xsl:when test="$header-col2/descendant::a/@href != ''">
										<a href="{$header-col2/descendant::a/@href}">{$header-col2/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col2)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[2]/node()'>
						   <div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[2]/node()"/></div>
						</xsl:if>
					</div>
				</div>

				<xsl:if test="$col-qty = 3"> 
					<div class="column__col">				
						<div>
							<xsl:if test='$col-qty = 3'>
								<xsl:attribute name="class">column__content</xsl:attribute>	
							</xsl:if>

							<xsl:if test="$header-col3/node() !=''">
								<div class="column__title">
									<h3>
										<xsl:choose>
											<xsl:when test="$header-col3/descendant::a/@href != ''">
												<a href="{$header-col3/descendant::a/@href}">{$header-col3/descendant::a}</a>
											</xsl:when>
											<xsl:otherwise>
												{ou:textual-content($header-col3)}
											</xsl:otherwise>
										</xsl:choose>
									</h3>
								</div>
							</xsl:if>
							<xsl:if test='tbody/tr[5]/td[3]/node()'>
								<div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[3]/node()"/></div>
							</xsl:if>
						</div>
					</div>

				</xsl:if>							
			</div>
		</section>
	</xsl:template>
	
	<!-- jsingh: removed image, header, and intro text from 2-3 col layouts -->
	
	<xsl:template match="table[@class = 'ou-snippet-column-content-noheader']">
		<!-- # of Columns -->
		<xsl:variable name="col-qty" select="count(tbody/tr[4]/td[@data-name='content'])"/>
		<xsl:variable name="col-num">
			<xsl:choose>
				<xsl:when test="$col-qty = 2">two</xsl:when>
				<xsl:otherwise>three</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Column 1 Variables -->
		<xsl:variable name="header-col1" select="tbody/tr[4]/td[1]"></xsl:variable>		

		<!-- Column 2 Variables -->
		<xsl:variable name="header-col2" select="tbody/tr[4]/td[2]"></xsl:variable>

		<!-- Column 3 Variables -->
		<xsl:variable name="header-col3" select="tbody/tr[4]/td[3]"></xsl:variable>
		
		<!-- Content Column Variables -->
		<xsl:variable name="content-col1" select="tbody/tr[6]/td[1]/node()"></xsl:variable>
		<xsl:variable name="content-col2" select="tbody/tr[6]/td[2]/node()"></xsl:variable>
		<xsl:variable name="content-col3" select="tbody/tr[6]/td[3]/node()"></xsl:variable>


		<section class="section gen-noimg{$col-qty}col">
			<div class="column column--{$col-num}">
				<div class="column__col" style="border: 1px solid #ccc; padding: 15px; margin: 10px; background-color: #2b3990; color: white;">				
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col1/node() !=''">
							<div class="column__title" style="font-weight: bold; font-size: 18px;">
								<h3><xsl:choose>
									<xsl:when test="$header-col1/descendant::a/@href != ''">
										<a href="{$header-col1/descendant::a/@href}">{$header-col1/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col1)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[1]/node()'>
						   <div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[1]/node()"/></div>
						</xsl:if>
						<xsl:if test="$content-col1">
							<div class="column__body" style="margin-top: 10px;"><xsl:apply-templates select="$content-col1"/></div>
						</xsl:if>

					</div>
				</div>
				<div class="column__col" style="border: 1px solid #ccc; padding: 15px; margin: 10px; background-color: #2b3990; color: white;">	
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col2/node() !=''">
							<div class="column__title" style="font-weight: bold; font-size: 18px;">
								<h3><xsl:choose>
									<xsl:when test="$header-col2/descendant::a/@href != ''">
										<a href="{$header-col2/descendant::a/@href}">{$header-col2/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col2)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
						<xsl:if test='tbody/tr[5]/td[2]/node()'>
						   <div class="column__body" style="margin-top: 10px;"><xsl:apply-templates select="tbody/tr[5]/td[2]/node()"/></div>
						</xsl:if>
						<xsl:if test="$content-col2">
							<div class="column__body" style="margin-top: 10px;"><xsl:apply-templates select="$content-col2"/></div>
						</xsl:if>
					</div>
				</div>

				<xsl:if test="$col-qty = 3"> 
					<div class="column__col" style="border: 1px solid #ccc; padding: 15px; margin: 10px; background-color: #2b3990; color: white;">				
						<div>
							<xsl:if test='$col-qty = 3'>
								<xsl:attribute name="class">column__content</xsl:attribute>	
							</xsl:if>

							<xsl:if test="$header-col3/node() !=''">
								<div class="column__title" style="font-weight: bold; font-size: 18px;">
									<h3>
										<xsl:choose>
											<xsl:when test="$header-col3/descendant::a/@href != ''">
												<a href="{$header-col3/descendant::a/@href}">{$header-col3/descendant::a}</a>
											</xsl:when>
											<xsl:otherwise>
												{ou:textual-content($header-col3)}
											</xsl:otherwise>
										</xsl:choose>
									</h3>
								</div>
							</xsl:if>
							<xsl:if test='tbody/tr[5]/td[3]/node()'>
								<div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[3]/node()"/></div>
							</xsl:if>
							<xsl:if test="$content-col3">
								<div class="column__body" style="margin-top: 10px;"><xsl:apply-templates select="$content-col3"/></div>
							</xsl:if>
						</div>
					</div>

				</xsl:if>							
			</div>
		</section>
	</xsl:template>
	
	<!-- jsingh: COL Major Cards -->
	
	<xsl:template match="table[@class = 'ou-snippet-column-content-major-cards']">
<!-- # of Columns -->
	<xsl:variable name="col-qty" select="count(tbody/tr[4]/td[@data-name='content'])"/>
	<xsl:variable name="col-num">
		<xsl:choose>
			<xsl:when test="$col-qty = 2">two</xsl:when>
			<xsl:otherwise>three</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Column 1 Variables -->
	<xsl:variable name="header-col1" select="tbody/tr[4]/td[1]"></xsl:variable>		
	<xsl:variable name="image-col1" select="tbody/tr[5]/td[1]/img"/>

	<!-- Column 2 Variables -->
	<xsl:variable name="header-col2" select="tbody/tr[4]/td[2]"></xsl:variable>
	<xsl:variable name="image-col2" select="tbody/tr[5]/td[2]/img"/>

	<!-- Column 3 Variables -->
	<xsl:variable name="header-col3" select="tbody/tr[4]/td[3]"></xsl:variable>
	<xsl:variable name="image-col3" select="tbody/tr[5]/td[3]/img"/>

	<!-- Content Column Variables -->
	<xsl:variable name="content-col1" select="tbody/tr[6]/td[1]/node()"></xsl:variable>
	<xsl:variable name="content-col2" select="tbody/tr[6]/td[2]/node()"></xsl:variable>
	<xsl:variable name="content-col3" select="tbody/tr[6]/td[3]/node()"></xsl:variable>

	<section class="section gen-noimg{$col-qty}col">
		<div class="column column--{$col-num}">
			<div class="column__col" style="border: 1px solid #ccc; background-color: #2b3990; color: white; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);">			
				<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col1/node() !=''">
							<div class="column__title" style="font-weight: bold; font-size: 18px; padding: 15px; margin: 0px;">
								<h3><xsl:choose>
									<xsl:when test="$header-col1/descendant::a/@href != ''">
										<a href="{$header-col1/descendant::a/@href}" style="color: #fff200; text-decoration: none;">{$header-col1/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col1)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
					
					<xsl:if test="$image-col1">
						<div class="column__image" style ="padding: 0px; margin: 0px;">
							<img src="{$image-col1/@src}" alt="{$image-col1/@alt}"/>
						</div>
					</xsl:if>
						<xsl:if test='tbody/tr[5]/td[1]/node()'>
						   <div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[1]/node()"/></div>
						</xsl:if>
						<xsl:if test="$content-col1">
							<div class="column__body" style="padding: 15px; margin: 5px;"><xsl:apply-templates select="$content-col1"/></div>
						</xsl:if>

					</div>
				</div>
				<div class="column__col" style="border: 1px solid #ccc; background-color: #2b3990; color: white; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);">	
					<div>
						<xsl:if test='$col-qty = 3'>
							<xsl:attribute name="class">column__content</xsl:attribute>	
						</xsl:if>
						<xsl:if test="$header-col2/node() !=''">
							<div class="column__title" style="font-weight: bold; font-size: 18px; padding: 15px; margin: 0px;">
								<h3><xsl:choose>
									<xsl:when test="$header-col2/descendant::a/@href != ''">
										<a href="{$header-col2/descendant::a/@href}" style="color: #fff200; text-decoration: none;">{$header-col2/descendant::a}</a>
									</xsl:when>
									<xsl:otherwise>
										{ou:textual-content($header-col2)}
									</xsl:otherwise>
									</xsl:choose>
								</h3>
							</div>
						</xsl:if>
											<xsl:if test="$image-col2">
						<div class="column__image" style ="padding: 0px; margin: 0px;">
							<img src="{$image-col2/@src}" alt="{$image-col2/@alt}"/>
						</div>
					</xsl:if>
						<xsl:if test='tbody/tr[5]/td[2]/node()'>
						   <div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[2]/node()"/></div>
						</xsl:if>
						<xsl:if test="$content-col2">
							<div class="column__body" style="padding: 15px; margin: 5px;"><xsl:apply-templates select="$content-col2"/></div>
						</xsl:if>
					</div>
				</div>

				<xsl:if test="$col-qty = 3"> 
					<div class="column__col" style="border: 1px solid #ccc; background-color: #2b3990; color: white; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);">			
						<div>
							<xsl:if test='$col-qty = 3'>
								<xsl:attribute name="class">column__content</xsl:attribute>	
							</xsl:if>

							<xsl:if test="$header-col3/node() !=''">
								<div class="column__title" style="font-weight: bold; font-size: 18px; padding: 15px; margin: 0px;">
									<h3>
										<xsl:choose>
											<xsl:when test="$header-col3/descendant::a/@href != ''">
												<a href="{$header-col3/descendant::a/@href}" style="color: #fff200; text-decoration: none;">{$header-col3/descendant::a}</a>
											</xsl:when>
											<xsl:otherwise>
												{ou:textual-content($header-col3)}
											</xsl:otherwise>
										</xsl:choose>
									</h3>
								</div>
							</xsl:if>
												<xsl:if test="$image-col3">
						<div class="column__image" style ="padding: 0px; margin: 0px;">
							<img src="{$image-col3/@src}" alt="{$image-col3/@alt}"/>
						</div>
					</xsl:if>
							<xsl:if test='tbody/tr[5]/td[3]/node()'>
								<div class="column__body"><xsl:apply-templates select="tbody/tr[5]/td[3]/node()"/></div>
							</xsl:if>
							<xsl:if test="$content-col3">
								<div class="column__body" style="padding: 15px; margin: 5px;"><xsl:apply-templates select="$content-col3"/></div>
							</xsl:if>
						</div>
					</div>

				</xsl:if>							
			</div>
		</section>
	</xsl:template>

	<!-- Tabs-Test -->
    <xsl:template match="table[@class='omni-tabs-test']">
        <xsl:variable name="uq" select="generate-id(.)" />
        <ul class="nav nav-tabs">
            <xsl:for-each select="tbody/tr">
                <xsl:variable name="pos" select="position()" />
                <li>
                    <xsl:if test="$pos = 1"><xsl:attribute name="class">active</xsl:attribute></xsl:if>
                    <a data-toggle="tab" href="#{$uq}-{$pos}"><xsl:value-of select="td[1]" /></a>
                </li>
            </xsl:for-each>
        </ul>
        <div class="tab-content">
            <xsl:for-each select="tbody/tr">
                <xsl:variable name="pos" select="position()" />
                <div id="{$uq}-{$pos}" class="tab-pane fade">
                    <xsl:if test="$pos = 1"><xsl:attribute name="class">tab-pane fade in active</xsl:attribute></xsl:if>
                    <xsl:apply-templates select="td[2]/node()" />
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <!-- /Tabs-Test -->

	<!-- Carousel Snippet -->

	<xsl:template match="table[@class='ou-carousel-gallery']">
		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>

		<section class="section carousel">
			<xsl:if test="$header !=''">
				<div class="section__header carousel__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test="$intro != ''">
				<div class="section__intro carousel__intro">{$intro}</div>
			</xsl:if>
			<div class="carousel__wrapper">
				<xsl:apply-templates select="tbody/tr[3]/td[@data-type='asset']/gallery/images/image"></xsl:apply-templates>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="table[@class='ou-carousel-gallery']/tbody/tr/td/gallery/images/image">
		<div class="carousel__item">
			<div class="carousel__img">
				<xsl:choose>
					<xsl:when test="link !=''"><a href="{link}"> <img src="{@url}" alt="{description}" /></a></xsl:when>
					<xsl:otherwise><img src="{@url}" alt="{description}" /></xsl:otherwise>
				</xsl:choose>
			</div>
			<xsl:if test="caption !=''">
				<div class="carousel__caption">{caption}</div>
			</xsl:if>
		</div>

	</xsl:template>


	<!-- Image List Snippet -->

	<xsl:template match="table[@class='ou-image-list']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>

		<section class="section genimglist">
			<xsl:if test='$header !=""'>
				<div class="section__header genimglist__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test='$intro !=""'>
				<div class="section__intro genimglist__intro">{$intro}</div>
			</xsl:if>
			<div class="genimglist__wrap">
				<xsl:for-each select="$items">
					<xsl:variable name="image-link" select="td[1]">
					</xsl:variable>
					<!-- 					<xsl:variable name="image" select="td[1]/descendant::img"/> -->
					<xsl:variable name="title" select="td[@data-name = 'title']"/>
					<xsl:variable name="subtitle" select="ou:textual-content(td[@data-name = 'subtitle'])"/>
					<xsl:if test="$image-link/descendant::img/@src != ''">
						<div class="genimglist__item">
							<div class="genimglist__img">
								<xsl:choose>
									<xsl:when test="$image-link/descendant::a/@href !=''">
										<xsl:apply-templates select="$image-link/descendant::a"/>
									</xsl:when>
									<xsl:otherwise>
										<img src="{$image-link/descendant::img/@src}" alt="{$image-link/descendant::img/@alt}"/>
									</xsl:otherwise>
								</xsl:choose>
							</div>
							<div class="genimglist__content">
								<div class="genimglist__title">
									<h3>
										<xsl:choose>
											<xsl:when test="$title/descendant::a/@href != ''">
												<xsl:apply-templates select="$title/descendant::a"/>
											</xsl:when>
											<xsl:otherwise><xsl:apply-templates select="ou:textual-content($title)"/></xsl:otherwise>
										</xsl:choose>
									</h3>
								</div>
								<div class="genimglist__subtitle">{$subtitle}</div>
								<div class="genimglist__body"><xsl:apply-templates select="td[@data-name='content']"/></div>
							</div>
						</div>
					</xsl:if>
				</xsl:for-each>
			</div>
		</section>
	</xsl:template>

	<!-- Program List Snippet -->

	<xsl:template match="table[@class='ou-program-list']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>

		<section class="section program-list">
			<xsl:if test='$header !=""'>
				<div class="section__header program-list__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test='$intro !=""'>
				<div class="section__intro program-list__intro">{$intro}</div>
			</xsl:if>
			<div class="program-list__content">
				<xsl:for-each select="$items">
					<xsl:variable name="link" select="td[@data-name = 'link']/descendant::a"/>
					<xsl:variable name="type" select="ou:textual-content(td[@data-name = 'type'])"/>
					<div class="program-list__item">
						<div class="program-list__program"><xsl:apply-templates select="$link"/></div>
						<div class="program-list__type">{$type}</div>
					</div>
				</xsl:for-each>
			</div>
		</section>
	</xsl:template>

	<!-- Story Snippet -->

	<xsl:template match="table[@class='ou-story']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>
		<xsl:variable name="image-link" select="tbody/tr[3]/td[@data-name='image']"/>
		<xsl:variable name="subtitle" select="ou:textual-content(tbody/tr[6]/td[@data-name='subtitle']/node())"/>

		<section class="section story-display">
			<xsl:if test="$header !=''">
				<div class="section__header story-display__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test="$intro !=''">
				<div class="section__intro story-display__intro">{$intro}</div>
			</xsl:if>
			<div class="story-display__wrap">
				<div class="story-display__img">
					<xsl:choose>
						<xsl:when test="$image-link/descendant::a/@href !=''">
							<xsl:apply-templates select="$image-link/descendant::a"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="{$image-link/descendant::img/@src}" alt="{$image-link/descendant::img/@alt}"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="story-display__content">
					<div class="story-display__quote">{tbody/tr[4]/td[@data-name='quote']/node()}</div>
					<div class="story-display__title">{tbody/tr[5]/td[@data-name='title']/node()}</div>
					<div class="story-display__subtitle">{$subtitle}</div>
					<div class="story-display__caption"><xsl:apply-templates select="tbody/tr[7]/td[@data-name='caption']/node()"/></div>
				</div>
			</div>
		</section>
	</xsl:template>

	<!-- Stats Interior Patterns Snippet -->

	<xsl:template match="table[@class='ou-stats']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:textual-content(tbody/tr[1]/td[@data-name='header']/node())"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name='intro']/node()"/>
		<xsl:variable name="cta-btm" select="tbody/tr[3]/td[@data-name='cta']/descendant::a"/>

		<section class="section stat3up">
			<xsl:if test='$header !=""'>
				<div class="section__header stat3up__header">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test='$intro !=""'>
				<div class="section__intro stat3up__intro">{$intro}</div>
			</xsl:if>
			<div class="column slick slick--arrow">
				<xsl:for-each select="$items">
					<xsl:variable name="number" select="ou:textual-content(td[@data-name = 'number']/node())"/>
					<xsl:variable name="caption" select="ou:textual-content(td[@data-name = 'caption']/node())"/>
					<xsl:variable name="cta" select="td[@data-name='cta']/descendant::a"/>
					<div class="column__col stat3up__item">
						<div class="stat3up__number">{$number}</div>
						<div class="stat3up__caption">{$caption}</div>
						<xsl:if test="$cta !=''">
							<div class="stat3up__cta"><xsl:apply-templates select="$cta"/></div>
						</xsl:if>
					</div>
				</xsl:for-each>
			</div>
			<xsl:if test="$cta-btm !=''">
				<div class="section__cta stat3up__section-cta"><a class="cta cta--button" href="{$cta-btm/@href}">{$cta-btm}</a></div>
			</xsl:if>
		</section>
	</xsl:template>

	<!-- Stats Full Width Snippet --> 

	<xsl:template match="table[@class = 'ou-stats-pathway']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>

		<!-- Top Element Variables -->
		<xsl:variable name="header" select="ou:get-value(tbody/tr[1]/td[@data-name = 'header'])"/>
		<xsl:variable name="intro" select="tbody/tr[2]/td[@data-name = 'intro']/node()"/>
		<xsl:variable name="cta-btm" select="tbody/tr[3]/td[@data-name = 'cta']/descendant::a"/>

		<section class="stats-section">
			<xsl:if test='$header != ""'>
				<div class="stats-section__heading">
					<h2>{$header}</h2>
				</div>
			</xsl:if>
			<xsl:if test='$intro != ""'>
				<p>{$intro}</p>
			</xsl:if>
			<ul class="stats-section__list">
				<xsl:for-each select="$items">
					<xsl:variable name="number" select="ou:get-value(td[@data-name = 'number'])"/>
					<xsl:variable name="caption" select="ou:get-value(td[@data-name = 'caption'])"/>
					<xsl:variable name="cta" select="td[@data-name = 'cta']/descendant::a"/>
					<li>
						<span class="stats-section__number">{$number}</span>
						<p>{$caption}</p>
						<xsl:if test="$cta != ''">
							<a class="cta cta--button">
								<xsl:apply-templates select="$cta/attribute()[name() != 'class'] | $cta/node()"/>
							</a>
						</xsl:if>
					</li>
				</xsl:for-each>
			</ul>
			<xsl:if test="$cta-btm != ''">
				<div class="section__cta stat3up__section-cta">
					<a class="cta cta--button">
						<xsl:apply-templates select="$cta-btm/attribute()[name() != 'class'] | $cta-btm/node()"/>
					</a>
				</div>
			</xsl:if>
		</section>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-pathwaylist']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item'][ou:get-value(td[@data-name = 'heading'])]" as="element(tr)*"/>
		<xsl:if test="$items">
			<ul class="pathway-grid">
				<xsl:for-each select="$items">
					<xsl:variable name="cert" select="ou:get-value(td[@data-name = 'cert'])"/>
					<xsl:variable name="science" select="ou:get-value(td[@data-name = 'science'])"/>
					<xsl:variable name="arts" select="ou:get-value(td[@data-name = 'arts'])"/>
					<xsl:variable name="fine" select="ou:get-value(td[@data-name = 'fine'])"/>
					<xsl:variable name="online" select="ou:get-value(td[@data-name = 'online'])"/>
					<xsl:variable name="evening" select="ou:get-value(td[@data-name = 'evening'])"/>
					<xsl:variable name="applied" select="ou:get-value(td[@data-name = 'applied'])"/>
					<xsl:variable name="heading" select="ou:get-value(td[@data-name = 'heading'])"/>
					<li>
						<a href="#">
							<xsl:apply-templates select="$heading/attribute()"/>
							<h2>
								<xsl:apply-templates select="$heading/text()"/>
							</h2>
							<ul class="icons">
								<xsl:if test="$cert = 'Yes' or $science = 'Yes' or $arts = 'Yes' or $fine = 'Yes' or $applied = 'Yes' or $online = 'Yes' or $evening = 'Yes'">

									<xsl:if test="$arts = 'Yes'">
										<li>
											<img src="{{f:37265145}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$fine = 'Yes'">
										<li>
											<img src="{{f:37265116}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$science = 'Yes'">
										<li>
											<img src="{{f:37265138}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$online = 'Yes'">
										<li>
											<img src="{{f:37265120}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$cert = 'Yes'">
										<li>
											<img src="{{f:37265142}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$evening = 'Yes'">
										<li>
											<img src="{{f:37265114}}" alt=""/>
										</li>
									</xsl:if>
									<xsl:if test="$applied = 'Yes'">
										<li>
											<img src="{{f:37265143}}" alt=""/>
										</li>
									</xsl:if>

								</xsl:if>
							</ul>
						</a>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-container-holder']">
		<xsl:variable name="content" select="ou:get-value(tbody/tr/td[@data-name = 'content'])"/>
		<div class="container-holder">
			<xsl:apply-templates select="$content"/>
		</div>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-cta-list-buttons']">
		<xsl:variable name="content" select="ou:get-value(tbody/tr/td[@data-name = 'content'])"/>
		<ul class="cta-list">
			<xsl:apply-templates select="$content"/>
		</ul>
	</xsl:template>


	<xsl:template match="table[@class='ou-faculty-list']">
		<xsl:param name="items" select="tbody/tr[@data-name = 'item']"/>
		<div class="faculty faculty--listing">
			<section class="faculty__list">
				<xsl:for-each select="$items">
					<xsl:variable name="name" select="td[@data-name = 'name']"/>
					<xsl:variable name="title" select="td[@data-name = 'title']/node()"/>
					<xsl:variable name="email" select="td[@data-name='email']/node()"/>
					<xsl:variable name="phone" select="td[@data-name='phone']/node()"/>
					<xsl:variable name="image" select="td[@data-name='image']"/>
					<div class="faculty__item">
						<xsl:if test="$image/descendant::img/@src !=''">
							<div class="faculty__image">
								<xsl:apply-templates select="$image/descendant::img"/>
							</div>
						</xsl:if>
						<div class="faculty__contact">
							<xsl:if test="$name/descendant::a/@href !=''">
								<p class="faculty__name"><xsl:apply-templates select="$name/descendant::a"/></p>
							</xsl:if>
							<xsl:if test="$title !=''">
								<p class="faculty__title">{$title}</p>
							</xsl:if>
							<xsl:if test="$email !=''">
								<p class="faculty__email"><a href="mailto:{$email}">{$email}</a>
								</p>
							</xsl:if>
							<xsl:if test="$phone !=''">
								<p class="faculty__phone">{$phone}</p>
							</xsl:if>
						</div>
					</div>	
				</xsl:for-each>
			</section>
		</div>
	</xsl:template>


	<xsl:template match="table[@data-snippet = 'ou-pathway-list']" expand-text="yes">
		<xsl:variable name="intro" select="ou:get-value(tbody/tr/td[@data-name = 'intro'])"/>
		<div class="container-holder">
			<xsl:if test="$intro">
				<section class="page-intro">
					<xsl:apply-templates select="$intro"/>
				</section>
			</xsl:if>
			<ul class="pathway-list">
				<xsl:for-each select="tbody/tr[@data-name = 'content']">
					<xsl:variable name="icon" select="ou:get-value(td[@data-name = 'icon'])"/>
					<xsl:variable name="text" select="ou:get-value(td[@data-name = 'text'])"/>
					<li>
						<xsl:apply-templates select="$icon"/>
						<span>{$text}</span>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="table[@data-snippet = 'ou-pathwaykey']">
		<xsl:param name="heading" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'heading'])"/>
		<xsl:param name="intro" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'intro'])"/>
		<xsl:param name="cert" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'cert'])"/>
		<xsl:param name="science" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'science'])"/>
		<xsl:param name="arts" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'arts'])"/>
		<xsl:param name="fine" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'fine'])"/>
		<xsl:param name="online" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'online'])"/>
		<xsl:param name="evening" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'evening'])"/>
		<xsl:param name="applied" select="ou:get-value(tbody/tr[@data-name = 'data']/td[@data-name = 'applied'])"/>
		<div class="container-holder">
			<xsl:if test="$heading">
				<h2>
					<xsl:value-of select="$heading"/>
				</h2>
			</xsl:if>
			<xsl:if test="$intro">
				<section class="page-intro">
					<xsl:apply-templates select="$intro"/>
				</section>
			</xsl:if>
			<xsl:if test="$cert = 'Yes' or $science = 'Yes' or $arts = 'Yes' or $fine = 'Yes' or $online = 'Yes' or $evening = 'Yes' or $applied = 'Yes'">
				<ul class="pathway-list">
					<xsl:if test="$arts = 'Yes'">
						<li>
							<img src="{{f:37265145}}" alt=""/>
							<span>Associate in Arts</span>
						</li>
					</xsl:if>
					<xsl:if test="$fine = 'Yes'">
						<li>
							<img src="{{f:37265116}}" alt=""/>
							<span>Associate in Fine Arts</span>
						</li>
					</xsl:if>
					<xsl:if test="$science = 'Yes'">
						<li>
							<img src="{{f:37265138}}" alt=""/>
							<span>Associate in Science</span>
						</li>
					</xsl:if>
					<xsl:if test="$online = 'Yes'">
						<li>
							<img src="{{f:37265133}}" alt=""/>
							<span>Online options available</span>
						</li>
					</xsl:if>
					<xsl:if test="$cert = 'Yes'">
						<li>
							<img src="{{f:37265142}}" alt=""/>
							<span>Certificate</span>
						</li>
					</xsl:if>
					<xsl:if test="$evening = 'Yes'">
						<li>
							<img src="{{f:37265131}}" alt=""/>
							<span>Can be completed in the evening</span>
						</li>
					</xsl:if>
					<xsl:if test="$applied = 'Yes'">
						<li>
							<img src="{{f:37265143}}" alt=""/>
							<span>Associate of Applied Science</span>
						</li>
					</xsl:if>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>








</xsl:stylesheet>
