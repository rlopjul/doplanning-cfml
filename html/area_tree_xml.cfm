<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getMainTree" returnvariable="xmlGetMainTreeResponse">
</cfinvoke>
<cfsavecontent variable="xmlAreas"><cfoutput>#xmlGetMainTreeResponse.response.result.areas[1]#</cfoutput></cfsavecontent>

<!--- Define XSLT to repace the root node. --->
<cfsavecontent variable="strXSLData">
	<?xml version="1.0" encoding="ISO-8859-1"?>
	<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
		<!--- Define new root node name BELOW. --->
 
		<xsl:variable name="new-root-node">
			<xsl:text>root</xsl:text>
		</xsl:variable>
 
		<!--- Define new root node name ABOVE. --->
 
		<!--- --------------------------------------------- --->
 
		<!--- Match the root node. --->
		<xsl:template match="/*">
 
			<!--- Create a new element with new node name. --->
			<xsl:element name="{$new-root-node}">
 
				<!---
					Copy all attributes of the existing root
					node into the new root node.
				--->
				<xsl:for-each select="@*">
 
					<xsl:attribute name="{name()}">
						<xsl:value-of select="." />
					</xsl:attribute>
 
				</xsl:for-each>
 
				<!--- Copy all children of the root node. --->
				<xsl:copy-of select="*" />
 
			</xsl:element>
 
		</xsl:template>
 
	</xsl:transform>
</cfsavecontent>
 
<!--- Transform the XML. --->
<cfset xmlNew = XmlTransform( Trim( xmlAreas ), Trim( strXSLData ) ) />
 
<cfcontent type="text/xml" reset="yes"><cfoutput>#xmlNew#</cfoutput>