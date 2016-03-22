<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Don't output the XML specifier or apply any XML/HTML formatting. -->
    <xsl:output method="text" media-type="text/csv" />

    <!-- Identity template strips everything by default. -->
    <xsl:template match="node()|@*">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>

    <!-- Produce headers on the lowest common ancestor.  &#xa; produces a newline. -->
    <xsl:template match="/profile/userInterfaces">
        <xsl:text>"User Interface Name","Screen Name","Field Name","Bundle Code","Help Text"&#xa;</xsl:text>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>

    <!-- Produce a single record per <placement> in the source; look up the tree to find parent screen and UI names -->
    <!-- Note this matches object UIs only; remove the @type check to produce all UIs for all data types. -->
    <xsl:template match="/profile/userInterfaces/userInterface[@type='ca_objects']/screens/screen/bundlePlacements/placement">
        <xsl:variable name="placementLabel" select="normalize-space(settings/setting[@name='label'][@locale='en_AU']/text())" />
        <xsl:variable name="placementDescription" select="normalize-space(settings/setting[@name='description'][@locale='en_AU']/text())" />
        <xsl:variable name="elementCode" select="substring-after(./bundle/text(), 'ca_attribute_')" />
        <xsl:variable name="elementLabel" select="normalize-space(/profile/elementSets/metadataElement[@code=$elementCode]/labels/label[@locale='en_AU']/name/text())" />
        <xsl:variable name="elementDescription" select="normalize-space(/profile/elementSets/metadataElement[@code=$elementCode]/labels/label[@locale='en_AU']/description/text())" />
        <xsl:text>"</xsl:text>
        <xsl:value-of select="normalize-space(../../../../labels/label[@locale='en_AU']/name/text())" />
        <xsl:text>","</xsl:text>
        <xsl:value-of select="normalize-space(../../labels/label[@locale='en_AU']/name/text())" />
        <xsl:text>","</xsl:text>
        <xsl:if test="$placementLabel">
            <xsl:value-of select="$placementLabel" />
        </xsl:if>
        <xsl:if test="not($placementLabel)">
            <xsl:value-of select="$elementLabel" />
        </xsl:if>
        <xsl:text>","</xsl:text>
        <xsl:value-of select="bundle/text()" />
        <xsl:text>","</xsl:text>
        <xsl:if test="$placementDescription">
            <xsl:value-of select="$placementDescription" />
        </xsl:if>
        <xsl:if test="not($placementDescription)">
            <xsl:value-of select="$elementDescription" />
        </xsl:if>
        <xsl:text>"&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
