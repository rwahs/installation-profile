<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes" />

    <!-- identity template copies everything forward by default. -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Copy existing displays, except those that are being generated, then generate the known / derived displays. -->
    <xsl:template match="displays">
        <xsl:element name="displays">
            <xsl:for-each select="./display">
                <xsl:if test="@code != 'library_object_display' and @code != 'memorial_object_display' and @code != 'museum_object_display' and @code != 'photograph_object_display'">
                    <xsl:apply-templates select="." />
                </xsl:if>
            </xsl:for-each>
            <xsl:call-template name="generateDisplay">
                <xsl:with-param name="display_label">Library Object display</xsl:with-param>
                <xsl:with-param name="display_code">library_object_display</xsl:with-param>
                <xsl:with-param name="ui_code">library_object_ui</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="generateDisplay">
                <xsl:with-param name="display_label">Memorial Object display</xsl:with-param>
                <xsl:with-param name="display_code">memorial_object_display</xsl:with-param>
                <xsl:with-param name="ui_code">memorial_object_ui</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="generateDisplay">
                <xsl:with-param name="display_label">Museum Object display</xsl:with-param>
                <xsl:with-param name="display_code">museum_object_display</xsl:with-param>
                <xsl:with-param name="ui_code">museum_object_ui</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="generateDisplay">
                <xsl:with-param name="display_label">Photograph Object display</xsl:with-param>
                <xsl:with-param name="display_code">photograph_object_display</xsl:with-param>
                <xsl:with-param name="ui_code">photograph_object_ui</xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <!-- Generate a single display based on the given parameters. -->
    <xsl:template name="generateDisplay">
        <xsl:param name="display_label" />
        <xsl:param name="display_code" />
        <xsl:param name="ui_code" />
        <xsl:element name="display">
            <xsl:attribute name="code"><xsl:value-of select="$display_code" /></xsl:attribute>
            <xsl:attribute name="type">ca_objects</xsl:attribute>
            <xsl:attribute name="system">1</xsl:attribute>
            <xsl:element name="labels">
                <xsl:element name="label">
                    <xsl:attribute name="locale">en_AU</xsl:attribute>
                    <xsl:element name="name">
                        <xsl:value-of select="$display_label" />
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="bundlePlacements">
                <xsl:for-each select="/profile/userInterfaces/userInterface[@code = $ui_code]/screens/screen/bundlePlacements/placement">
                    <xsl:element name="placement">
                        <xsl:attribute name="code"><xsl:value-of select="@code" /></xsl:attribute>
                        <xsl:element name="bundle">
                            <xsl:if test="starts-with(bundle/text(), 'ca_attribute_')">
                                <xsl:value-of select="concat('ca_objects.', substring-after(bundle/text(), 'ca_attribute_'))" />
                            </xsl:if>
                            <xsl:if test="not(starts-with(bundle/text(), 'ca_attribute_'))">
                                <xsl:if test="starts-with(bundle/text(), 'ca_')">
                                    <xsl:value-of select="bundle/text()" />
                                </xsl:if>
                                <xsl:if test="not(starts-with(bundle/text(), 'ca_'))">
                                    <xsl:value-of select="concat('ca_objects.', bundle/text())" />
                                </xsl:if>
                            </xsl:if>
                        </xsl:element>
                        <xsl:copy-of select="settings" />
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
