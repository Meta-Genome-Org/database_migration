<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <!-- Identity transform -->
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>

   <!-- Template to exclude fileExtension in metamaterial-img -->
   <xsl:template match="metamaterial-img/fileExtension">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="fileExtension">
      <fileExtension>.step</fileExtension>
   </xsl:template>
</xsl:stylesheet>
