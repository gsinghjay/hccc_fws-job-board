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
				exclude-result-prefixes="xs ou ouc">

	<xsl:import href="/var/staging/OMNI-INF/stylesheets/ldp-forms/v2/forms.xsl"/> <!-- global xsl of the forms -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/ldp-forms/v2/datasets.xsl"/> <!-- global xsl of the datasets -->
	<xsl:param name="server-type">php</xsl:param> <!-- Either: php or asp (for checkboxes and drop-down menus)-->
	<!-- location of the captcha html from the configuration file -->
	<xsl:variable name="captcha-html-location" select="$domain || '/_resources/ldp/forms/ldp-forms.captcha.html'"/>
	<!-- default css classes for the buttons of submit and reset -->
	<xsl:param name="default-reset-btn-class">cta cta--button</xsl:param>
	<xsl:param name="default-submit-btn-class">cta cta--button</xsl:param>

	<!-- classes for the columns -->
	<xsl:param name="two-column-class">col-md-6</xsl:param> <!-- change this -->
	<xsl:param name="three-column-class">col-md-4</xsl:param> <!-- change this -->
	<xsl:param name="four-column-class">col-md-3</xsl:param> <!-- change this -->
	<xsl:param name="column-container-start">&lt;div class="row"&gt;</xsl:param> <!-- change this -->
	<xsl:param name="column-container-end">&lt;/div&gt;</xsl:param> <!-- change this -->

	<!-- match on the ouform element -->
	<xsl:template match="ouform">
		<div class="ou-form">
			<xsl:call-template name="status-output" />
			<xsl:variable name="re-btn-class" select="ou:find-btn-class(., 'reset_btn_classes', $default-reset-btn-class)" />
			<xsl:variable name="sub-btn-class" select="ou:find-btn-class(., 'submit_btn_classes', $default-submit-btn-class)" />
			<form>
				<xsl:call-template name="form-configuration">
					<xsl:with-param name="form-classes" select="if (output/form_advanced/text() => contains('form_classes'))
																then ou:get-adv(output/form_advanced,'form_classes') else ''" />
				</xsl:call-template>
				<xsl:apply-templates select="elements/element" mode="ouforms"/>
				<xsl:call-template name="bottom-form-elements" />
				<xsl:copy-of select="ou:make-ldp-form-button('submit', $sub-btn-class, ou:submit-text(output/submit_text))" />&nbsp;
				<xsl:copy-of select="ou:make-ldp-form-button('reset', $re-btn-class, 'Clear')" />
			</form>
		</div>
	</xsl:template>

	<!-- Single Line Input Field -->
	<xsl:template name="output-single-line-input">
		<xsl:call-template name="create-form-label" />
		<xsl:call-template name="single-line-input-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-single-line-attributes">
		<xsl:attribute name="class">form-control</xsl:attribute>
	</xsl:template>
	<!-- /Single Line Input Field -->

	<!-- multi line text field -->
	<xsl:template name="output-multi-line">
		<xsl:call-template name="create-form-label" />
		<xsl:call-template name="multi-line-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-multi-line-attributes">
		<xsl:attribute name="class">form-control</xsl:attribute>
	</xsl:template>
	<!-- /multi line text field -->

	<!-- Radio buttons -->
	<xsl:template name="radio-button-for-loop">
		<xsl:param name="field-name" />
		<xsl:param name="ele" />
		<xsl:variable name="id" select="generate-id()"/>
		<div class="form-check form__radio">
			<input class="form-check-input" id="{$id}" type="radio" name="{$field-name}" title="{@value}" value="{@value}">
				<xsl:call-template name="ldp-is-required-in-loop">
					<xsl:with-param name="ele" select="$ele" />
				</xsl:call-template>
				<xsl:if test="@selected = 'true'">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<label class="form-check-label" for="{$id}">
				<xsl:copy-of select="node()"/>
			</label>
		</div>
	</xsl:template>
	<xsl:template name="radio-button-for-loop-dataset">
		<xsl:param name="field-name" />
		<xsl:param name="ele" />
		<xsl:variable name="cur-opt" select="replace(normalize-space(.),'_D_','')" />
		<xsl:variable name="id" select="generate-id()"/>
		<div class="form-check form__radio">
			<input class="form-check-input" id="{$id}" type="radio" title="{$cur-opt}" name="{$field-name}" value="{$cur-opt}">
				<xsl:call-template name="ldp-is-required-in-loop">
					<xsl:with-param name="ele" select="$ele" />
				</xsl:call-template>
				<xsl:if test="contains(normalize-space(.),'_D_')">
					<xsl:attribute name="checked"></xsl:attribute>
				</xsl:if>
			</input>
			<label class="form-check-label" for="{$id}">
				<xsl:copy-of select="$cur-opt"/>
			</label>
		</div>
	</xsl:template>
	<xsl:template name="custom-radio-button-fieldset-attributes">
		<xsl:attribute name="class">form__item form--fieldset</xsl:attribute>
	</xsl:template>
	<!-- /Radio buttons -->

	<!-- Checkboxes -->
	<xsl:template name="checkbox-for-loop">
		<xsl:param name="field-name" />
		<xsl:param name="ele" />
		<xsl:variable name="id" select="generate-id()"/>
		<div class="form-check form__checkbox">
			<input class="form-check-input" id="{$id}" type="checkbox" name="{$field-name}" title="{@value}" value="{@value}">
				<xsl:if test="@selected = 'true'">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<label class="form-check-label" for="{$id}">
				<xsl:copy-of select="node()"/>
			</label>
		</div>
	</xsl:template>
	<xsl:template name="checkbox-for-loop-dataset">
		<xsl:param name="field-name" />
		<xsl:param name="ele" />
		<xsl:variable name="cur-opt" select="replace(normalize-space(.),'_D_','')" />
		<xsl:variable name="id" select="generate-id()"/>
		<div class="form-check form__checkbox">
			<input class="form-check-input" id="{$id}" type="checkbox" title="{$cur-opt}" name="{$field-name}" value="{$cur-opt}">
				<xsl:if test="contains(normalize-space(.),'_D_')">
					<xsl:attribute name="checked"></xsl:attribute>
				</xsl:if>
			</input>
			<label class="form-check-label" for="{$id}">
				<xsl:copy-of select="$cur-opt"/>
			</label>
		</div>
	</xsl:template>
	<xsl:template name="custom-checkbox-fieldset-attributes">
		<xsl:attribute name="class">form__item form--fieldset</xsl:attribute>
	</xsl:template>
	<!-- /Checkboxes -->

	<!-- Single Selects -->
	<xsl:template name="output-single-select">
		<xsl:call-template name="create-form-label" />
		<xsl:call-template name="single-select-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-single-select-attributes">
		<xsl:attribute name="class">form-control</xsl:attribute>
	</xsl:template>
	<!-- /Single Selects -->

	<!-- Multi-select -->
	<xsl:template name="output-multi-select">
		<xsl:call-template name="create-form-label" />
		<xsl:call-template name="multi-select-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-multi-select-attributes">
		<xsl:attribute name="class">form-control</xsl:attribute>
	</xsl:template>
	<!-- /Multi-select -->

	<!-- Date Time -->
	<xsl:template name="output-date-time-picker">
		<xsl:call-template name="create-form-label" />
		<xsl:call-template name="date-time-picker-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-date-time-picker-attributes">
		<xsl:attribute name="class">form-control</xsl:attribute>
	</xsl:template>
	<!-- /Date Time -->

	<!-- File Upload -->
	<xsl:template name="output-file-upload-input">
		<xsl:call-template name="create-form-label" />
		<br />
		<xsl:call-template name="file-upload-input-default" />
		<xsl:call-template name="help-block" />
	</xsl:template>
	<xsl:template name="custom-file-upload-attributes" />
	<!-- /File Upload -->

	<!-- template make a div around the form elements -->
	<xsl:template name="ldp-make-div">
		<xsl:param name="class" />
		<xsl:param name="ele" select="'div'" />
		<xsl:element name="{$ele}">
			<xsl:attribute name="id" select="'div_' || @name" />
			<xsl:attribute name="class" select="$class" />
			<xsl:apply-templates select="." mode="ouforms-input" />
		</xsl:element>
	</xsl:template>

<!-- Datasets -->
<xsl:template name="customer-custom-datasets">
	<xsl:param name="dataset-name" />
	<xsl:choose>
		<xsl:when test="$dataset-name = 'streets'">Main,Central,Park,West,Broadway</xsl:when>
		<xsl:when test="$dataset-name = 'custom-2'">opt1,opt2</xsl:when>
		<xsl:when test="$dataset-name = 'custom-3'">opt1,opt2</xsl:when>
		<xsl:otherwise><xsl:value-of select="'************************************************************************************,
 Dataset used that is not configured. Please Check Configuration before publishing...,
 ************************************************************************************'" />
</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!-- /Datasets -->

</xsl:stylesheet>