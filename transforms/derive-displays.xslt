<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- This XSLT is terrible, but it works. -->
  <xsl:output indent="yes"/>

  <!-- Identity template copies everything forward by default. -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- Don't munge the CDATA sections in UI placement template settings. -->
  <xsl:template match="/profile/userInterfaces/userInterface/screens/screen/bundlePlacements/placement/settings/setting[substring(@name, string-length(@name) - 6) = 'emplate']">
    <xsl:element name="setting">
      <xsl:copy-of select="@name" />
      <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
      <xsl:value-of select="text()" disable-output-escaping="yes"/>
      <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
    </xsl:element>
  </xsl:template>

  <!-- Copy existing displays, except those that are being generated, then generate the known / derived displays. -->
  <xsl:template match="displays">
    <xsl:element name="displays">
      <xsl:for-each select="./display">
        <xsl:if test="@code != 'library_object_display' and
                      @code != 'memorial_object_display' and
                      @code != 'museum_object_display' and
                      @code != 'photograph_object_display' and
                      @code != 'standard_entity_display' and
                      @code != 'subject_list_display' and
                      @code != 'conservation_display' and
                      @code != 'places_display' and
                      @code != 'standard_storage_locations_display' and
                      @code != 'movement_cataloguers_display'">
          <xsl:apply-templates select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Library Object display</xsl:with-param>
        <xsl:with-param name="display_code">library_object_display</xsl:with-param>
        <xsl:with-param name="ui_code">library_object_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_objects</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Memorial Object display</xsl:with-param>
        <xsl:with-param name="display_code">memorial_object_display</xsl:with-param>
        <xsl:with-param name="ui_code">memorial_object_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_objects</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Museum Object display</xsl:with-param>
        <xsl:with-param name="display_code">museum_object_display</xsl:with-param>
        <xsl:with-param name="ui_code">museum_object_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_objects</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Photograph Object display</xsl:with-param>
        <xsl:with-param name="display_code">photograph_object_display</xsl:with-param>
        <xsl:with-param name="ui_code">photograph_object_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_objects</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Standard Entity display</xsl:with-param>
        <xsl:with-param name="display_code">standard_entity_display</xsl:with-param>
        <xsl:with-param name="ui_code">standard_entity_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_entities</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Subject List display</xsl:with-param>
        <xsl:with-param name="display_code">subject_list_display</xsl:with-param>
        <xsl:with-param name="ui_code">subject_list_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_occurrences</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Conservation display</xsl:with-param>
        <xsl:with-param name="display_code">conservation_display</xsl:with-param>
        <xsl:with-param name="ui_code">conservation_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_occurrences</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Places display</xsl:with-param>
        <xsl:with-param name="display_code">places_display</xsl:with-param>
        <xsl:with-param name="ui_code">places_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_places</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Standard Storage Locations display</xsl:with-param>
        <xsl:with-param name="display_code">standard_storage_locations_display</xsl:with-param>
        <xsl:with-param name="ui_code">standard_storage_locations_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_storage_locations</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="generateDisplay">
        <xsl:with-param name="display_label">Movement Cataloguers display</xsl:with-param>
        <xsl:with-param name="display_code">movement_cataloguers_display</xsl:with-param>
        <xsl:with-param name="ui_code">movement_cataloguers_ui</xsl:with-param>
        <xsl:with-param name="base_data_type">ca_movements</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- Generate a single display based on the given parameters. -->
  <xsl:template name="generateDisplay">
    <xsl:param name="display_label"/>
    <xsl:param name="display_code"/>
    <xsl:param name="ui_code"/>
    <xsl:param name="base_data_type"/>
    <xsl:element name="display">
      <xsl:attribute name="code">
        <xsl:value-of select="$display_code"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="$base_data_type"/>
      </xsl:attribute>
      <xsl:attribute name="system">1</xsl:attribute>
      <xsl:element name="labels">
        <xsl:element name="label">
          <xsl:attribute name="locale">en_AU</xsl:attribute>
          <xsl:element name="name">
            <xsl:value-of select="$display_label"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:copy-of select="/profile/userInterfaces/userInterface[@code = $ui_code]/typeRestrictions" />
      <xsl:copy-of select="/profile/userInterfaces/userInterface[@code = $ui_code]/groupAccess" />
      <xsl:element name="bundlePlacements">
        <xsl:for-each select="/profile/userInterfaces/userInterface[@code = $ui_code]/screens/screen/bundlePlacements/placement">
          <xsl:element name="placement">
            <xsl:attribute name="code">
              <xsl:value-of select="@code"/>
            </xsl:attribute>
            <xsl:element name="bundle">
              <xsl:if test="starts-with(bundle/text(), 'ca_attribute_')">
                <xsl:value-of select="concat($base_data_type, '.', substring-after(bundle/text(), 'ca_attribute_'))"/>
              </xsl:if>
              <xsl:if test="not(starts-with(bundle/text(), 'ca_attribute_'))">
                <xsl:if test="starts-with(bundle/text(), 'ca_')">
                  <xsl:value-of select="bundle/text()"/>
                </xsl:if>
                <xsl:if test="not(starts-with(bundle/text(), 'ca_'))">
                  <xsl:value-of select="concat($base_data_type, '.', bundle/text())"/>
                </xsl:if>
              </xsl:if>
            </xsl:element>
            <xsl:element name="settings">
              <xsl:for-each select="settings/setting">
                <xsl:if test="substring(@name, string-length(@name) - 6) = 'emplate'">
                  <xsl:element name="setting">
                    <xsl:copy-of select="@name" />
                    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                    <xsl:value-of select="text()" disable-output-escaping="yes"/>
                    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="substring(@name, string-length(@name) - 6) != 'emplate'">
                  <xsl:copy-of select="."/>
                </xsl:if>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
