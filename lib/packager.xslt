<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % packageInfo SYSTEM "../src/package.ent">
	%packageInfo;
]>
<!--
	This transforms a template package.xml file into the one used in the package.
	Primarily using this to make it easier to "version" the files, thus making it
	a zillion times easier to make sure Umbraco is using the latest build when
	trying to debug the package/property editor.
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:msbuild="http://schemas.microsoft.com/developer/msbuild/2003"
	exclude-result-prefixes="str"
>

	<xsl:output method="xml"
		indent="yes"
		omit-xml-declaration="no"
		cdata-section-elements="Design readme"
	/>

	<xsl:variable name="packageAlias" select="'&packageNamespace;&packageSafeName;'" />
	<xsl:variable name="folderPrefix" select="/umbPackage/files/@folderPrefix" />
	<xsl:variable name="version" select="'v&packageVersion;'" />

	<!-- Identity transform -->
	<xsl:template match="/">
		<xsl:apply-templates select="* | text() | processing-instruction()" />
	</xsl:template>

	<xsl:template match="* | text()">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text() | processing-instruction()" />
		</xsl:copy>
	</xsl:template>

	<!-- No output for these -->
	<xsl:template match="comment() | processing-instruction()" />

	<!-- The `<files>` element has a `@folderPrefix` attribute we don't want to copy -->
	<xsl:template match="files">
		<files>
			<xsl:apply-templates />
		</files>
	</xsl:template>

	<xsl:template match="file[@path]">
		<file>
			<guid><xsl:value-of select="@name" /></guid>
			<orgPath><xsl:value-of select="@path" /></orgPath>
			<orgName><xsl:value-of select="@name" /></orgName>
		</file>
	</xsl:template>

	<xsl:template match="file[@ref]">
		<file>
			<guid><xsl:value-of select="@ref" /></guid>
			<orgPath>
				<xsl:value-of select="concat('/App_Plugins/', $packageAlias)" />
			</orgPath>
			<orgName>
				<!-- These are mutually exclusive: -->
				<xsl:apply-templates select="@ref[../@versioned = 'no']" />
				<xsl:apply-templates select="@ref[not(../@versioned = 'no')]" mode="versioned" />
			</orgName>
		</file>
	</xsl:template>

	<xsl:template match="language[@ref]">
		<file>
			<guid><xsl:value-of select="@ref" /></guid>
			<orgPath>
				<xsl:value-of select="concat('/App_Plugins/', $packageAlias, '/lang')" />
			</orgPath>
			<orgName><xsl:value-of select="@ref" /></orgName>
		</file>
	</xsl:template>

	<xsl:template match="@ref" mode="versioned">
		<xsl:variable name="parts" select="str:split(., '.')" />
		<xsl:for-each select="$parts">
			<xsl:if test="not(position() = 1) and not(position() = last())">.</xsl:if>
			<xsl:if test="not(position() = last())">
				<xsl:value-of select="." />
			</xsl:if>
			<xsl:if test="position() = last()">
				<xsl:value-of select="concat('-', $version, '.', .)" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- Nuget specific for creating the .targets file -->
	<xsl:template match="msbuild:PackageAliasContentFiles">
		<xsl:element name="&packageNamespace;&packageSafeName;ContentFiles" namespace="http://schemas.microsoft.com/developer/msbuild/2003">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text()" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="msbuild:PackageAliasContentFilesPath">
		<xsl:element name="&packageNamespace;&packageSafeName;ContentFilesPath" namespace="http://schemas.microsoft.com/developer/msbuild/2003">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text()" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="msbuild:PackageAliasContentFilesDir">
		<xsl:element name="&packageNamespace;&packageSafeName;ContentFilesDir" namespace="http://schemas.microsoft.com/developer/msbuild/2003">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="* | text()" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
