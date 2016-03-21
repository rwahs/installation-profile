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
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../../../../labels/label[@locale='en_AU']/name/text()" />
        <xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="../../labels/label[@locale='en_AU']/name/text()" />
        <xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="settings/setting[@name='label'][@locale='en_AU']/text()" />
        <xsl:text>",</xsl:text>
        <xsl:value-of select="@code" />
        <xsl:text>",""&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
