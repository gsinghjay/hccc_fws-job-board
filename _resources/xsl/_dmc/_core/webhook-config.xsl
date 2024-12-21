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
				exclude-result-prefixes="xs ou ouc"
				expand-text="no">
	
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/variables.xsl"/> <!-- global variables -->
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/functions.xsl"/> <!-- global functions -->
	<xsl:import href="../../_shared/variables.xsl"/> <!-- customer variables -->
	
	<xsl:output omit-xml-declaration="yes" />
	
	<xsl:variable name="server-type" select="ou:pcf-param('server-type')" />
	
	<xsl:template match="/document">
		<xsl:choose>
			<xsl:when test="$server-type = 'php'">
				
				<xsl:processing-instruction name="php">

					require $_SERVER['DOCUMENT_ROOT'] . '/_resources/dmc/php/_core/class.rda.php'; // Real-time Data Aggregation
	
					$config = array(
						'ouc_base_url' => 'https://<xsl:value-of select="$ou:servername" />',
						'config_file' => '<xsl:value-of select="$ou:stagingpath" />',
						'config_site' => '<xsl:value-of select="$ou:site" />',
						'log' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('log'))" />',
						'skin' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('skin'))" />',
						'account' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('account'))" />',
						'username' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('username'))" />',
						'password' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('password'))" />',
						'next_webhook_url' => '<xsl:value-of select="ou:escape-single-quotes(ou:pcf-param('next-webhook-url'))" />',
						'actions' => array()
					);
					
					<xsl:for-each select="/document//parameter[starts-with(@name, 'active-')][option/@selected='true']">
						<xsl:variable name="site" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'site-')])[1])" />
						<xsl:variable name="trigger-path" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'trigger-path-')])[1])" />
						<xsl:variable name="publish-path" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'publish-path-')])[1])" />
						
						<xsl:if test="$site != '' and $trigger-path != '' and $publish-path != ''">
							$config['actions'][] = array(
								'site' => '<xsl:value-of select="ou:escape-single-quotes($site)" />',
								'trigger_path' => '<xsl:value-of select="ou:escape-single-quotes($trigger-path)" />',
								'publish_path' => '<xsl:value-of select="ou:escape-single-quotes($publish-path)" />'
							);
						</xsl:if>
					</xsl:for-each>

					$rda = new RDA($config);

					$rda->process();
	
				</xsl:processing-instruction>
			</xsl:when>
			<xsl:otherwise>

				<xsl:text disable-output-escaping="yes" expand-text="no">&lt;%@ </xsl:text> WebHandler Language="C#" Class="Handler" <xsl:text disable-output-escaping="yes" expand-text="no">%&gt;</xsl:text>

				using System.Web;
				using System.Collections.Specialized;
				using OUC;

				public class Handler : IHttpHandler {

					public void ProcessRequest (HttpContext context) {

						RDAConfiguration config = new RDAConfiguration();

						config.OUCBaseURL = "https://<xsl:value-of select="$ou:servername" />";
						config.configFile = "<xsl:value-of select="$ou:stagingpath" />";
						config.configSite = "<xsl:value-of select="$ou:site" />";
						config.log = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('log'))" />";
						config.skin = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('skin'))" />";
						config.account = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('account'))" />";
						config.username = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('username'))" />";
						config.password = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('password'))" />";
						config.nextWebhookURL = "<xsl:value-of select="ou:escape-double-quotes(ou:pcf-param('next-webhook-url'))" />";
						
						<xsl:for-each select="/document//parameter[starts-with(@name, 'active-')][option/@selected='true']">
							<xsl:variable name="site" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'site-')])[1])" />
							<xsl:variable name="trigger-path" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'trigger-path-')])[1])" />
							<xsl:variable name="publish-path" select="ou:textual-content((following-sibling::parameter[starts-with(@name,'publish-path-')])[1])" />
							
							<xsl:if test="$site != '' and $trigger-path != '' and $publish-path != ''">
								config.actions.Add(new NameValueCollection(){
									{"site","<xsl:value-of select="ou:escape-double-quotes($site)" />"},
									{"triggerPath","<xsl:value-of select="ou:escape-double-quotes($trigger-path)" />"},
									{"publishPath","<xsl:value-of select="ou:escape-double-quotes($publish-path)" />"}
								});
							</xsl:if>
						</xsl:for-each>
	
						RDA rda = new RDA(config);
						rda.process();

						context.Response.End();
					}

					public bool IsReusable {
						get {
							return false;
						}
					}
				}
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:function name="ou:escape-single-quotes">
		<xsl:param name="string" />
		
		<xsl:variable name="single-quote">'</xsl:variable>
		<xsl:variable name="escaped-single-quote">\\'</xsl:variable>
		
		<xsl:value-of select="replace($string, $single-quote, $escaped-single-quote)" disable-output-escaping="yes" />
	</xsl:function>
	
	<xsl:function name="ou:escape-double-quotes">
		<xsl:param name="string" />
		
		<xsl:variable name="double-quote">"</xsl:variable>
		<xsl:variable name="escaped-double-quote">\\"</xsl:variable>
		
		<xsl:value-of select="replace($string, $double-quote, $escaped-double-quote)" disable-output-escaping="yes" />
	</xsl:function>

</xsl:stylesheet>
