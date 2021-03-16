<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY % version SYSTEM "../src/version.ent">
	%version;
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:output method="text"
		indent="yes"
		omit-xml-declaration="yes"
	/>

	<xsl:variable name="quot">&quot;</xsl:variable>
	<xsl:variable name="objStart">{</xsl:variable>
	<xsl:variable name="objEnd">}</xsl:variable>
	<xsl:variable name="newline">__NEWLINE__</xsl:variable>
	<xsl:variable name="indent">__INDENT__</xsl:variable>

	<xsl:template match="manifest">
		<xsl:value-of select="$objStart" />
			<xsl:text>propertyEditors: [</xsl:text>
				<xsl:apply-templates select="propertyEditor" />
			<xsl:text>],</xsl:text>
			
			<xsl:text>css: [</xsl:text>
				<xsl:for-each select="css">
					<xsl:apply-templates select="." mode="quoted" />
					<xsl:if test="not(position() = last())">, </xsl:if>
				</xsl:for-each>
			<xsl:text>],</xsl:text>
			
			<xsl:text>javascript: [</xsl:text>
				<xsl:for-each select="javascript">
					<xsl:apply-templates select="." mode="quoted" />
					<xsl:if test="not(position() = last())">, </xsl:if>
				</xsl:for-each>
			<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="propertyEditor | field">
		<xsl:text>{</xsl:text>
			<xsl:apply-templates select="*" mode="json" />
		<xsl:text>}</xsl:text>
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="prevalues" mode="json">
		<xsl:value-of select="name()" />
		<xsl:text>: {</xsl:text>
			<xsl:text>fields: [</xsl:text>
				<xsl:apply-templates select="field" />
			<xsl:text>]</xsl:text>
		<xsl:text>}</xsl:text>
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<!-- == == == == == == -->

	<xsl:template match="view[contains(., '.')]" mode="json">
		<xsl:value-of select="name()" />
		<xsl:text>: &quot;</xsl:text>
		<xsl:apply-templates select="." mode="versioned" />
		<xsl:text>&quot;</xsl:text>
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="array">
		<xsl:value-of select="name()" />
		<xsl:text>: [</xsl:text>
			<xsl:apply-templates select="*" mode="json" />
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="*" mode="json" priority="-1">
		<xsl:value-of select="name()" />
		<xsl:text>: </xsl:text>
		<xsl:apply-templates select="text()" mode="quoted" />
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="*[@type = 'int']" mode="json" priority="-1">
		<xsl:value-of select="name()" />
		<xsl:text>: </xsl:text>
		<xsl:value-of select="." />
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="*[*]" mode="json" priority="-1">
		<xsl:value-of select="name()" />
		<xsl:text>: {</xsl:text>
			<xsl:apply-templates select="*" mode="json" />
		<xsl:text>}</xsl:text>
		<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

	<xsl:template match="css | javascript" mode="quoted">
		<xsl:text>&quot;</xsl:text>
		<xsl:apply-templates select="." mode="versioned" />
		<xsl:text>&quot;</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="quoted">
		<xsl:value-of select="concat($quot, ., $quot)" />
	</xsl:template>
	
	<xsl:template match="*" mode="versioned">
		<xsl:variable name="pluginpath" select="concat('/App_Plugins/', /manifest/propertyEditor/alias, '/')" />
		<xsl:variable name="extension" select="substring-after(., '.')" />
		<xsl:variable name="basename" select="substring-before(., '.')" />
		<xsl:value-of select="concat($pluginpath, $basename, '-&packageVersion;', '.', $extension)" />
	</xsl:template>
	
</xsl:stylesheet>
