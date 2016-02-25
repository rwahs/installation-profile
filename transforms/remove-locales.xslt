<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--identity template copies everything forward by default-->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <!-- remove non en_AU <locale>-->
    <xsl:template match="locale[@country != 'AU']"/>
    <xsl:template match="locale[@country = 'AU']/@dontUseForCataloguing"/>
    <!--replace replace en_US labels with en_AU labels-->
    <xsl:template match="setting[@name = 'label']/@locale[. = 'en_US']">
        <xsl:attribute name="locale">en_AU</xsl:attribute>
    </xsl:template>
    <xsl:template match="setting[@name = 'add_label']/@locale[. = 'en_US']">
        <xsl:attribute name="locale">en_AU</xsl:attribute>
    </xsl:template>
    <xsl:template match="label/@locale[. = 'en_US']">
        <xsl:attribute name="locale">en_AU</xsl:attribute>
    </xsl:template>
    <!-- remove other labels-->
    <xsl:template match="setting[@name = 'label' and (@locale != 'en_US' or @locale != 'en_AU')]"/>
    <xsl:template match="setting[@name = 'add_label' and (@locale != 'en_US' or @locale != 'en_AU')]"/>
    <xsl:template match="label[@locale != 'en_US' and @locale != 'en_AU']"/>

    <xsl:template match="list/@system">
        <xsl:attribute name="system">1</xsl:attribute>
    </xsl:template>


    <!-- remove extra whitespace from the deleted labels-->
    <xsl:strip-space elements="locales labels"/>


</xsl:stylesheet>
