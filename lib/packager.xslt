<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % version SYSTEM "../src/version.ent">
	%version;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

	<xsl:output method="xml"
		indent="yes"
		omit-xml-declaration="no"
		cdata-section-elements="Design readme"
	/>

	<xsl:variable name="packageName" select="/umbPackage/info/package/name" />

	<!-- Identity transform -->
	<xsl:template match="/">
		<xsl:apply-templates select="* | text() | comment() | processing-instruction()" />
	</xsl:template>
		
	<xsl:template match="* | text()">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text() | comment() | processing-instruction()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="file[@ref]">
		<file>
			<guid><xsl:value-of select="@ref" /></guid>
			<orgPath><xsl:value-of select="concat('/App_Plugins/Vokseverk.', translate($packageName, ' ', ''))" /></orgPath>
			<orgName><xsl:value-of select="@ref" /></orgName>
		</file>
	</xsl:template>

</xsl:stylesheet>