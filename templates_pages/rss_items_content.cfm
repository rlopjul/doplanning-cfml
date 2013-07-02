<cfsetting enablecfoutputonly="yes">

<cfinclude template="#APPLICATION.path#/templates_pages/udf_url.cfm">

<cfsavecontent variable="xml"><cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
	<channel>
		<title><![CDATA[#rss_title#]]></title>
		<link><![CDATA[#source_page_url#]]></link>
		<atom:link href="http://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" rel="self" type="application/rss+xml" />
		<description><![CDATA[]]></description>
		<language><![CDATA[es]]></language>
		<copyright><![CDATA[ASNC]]></copyright>
		<image>
			<title><![CDATA[#rss_title#]]></title>
			<url>
			<cfif areaTypeRequired EQ "web">
			http://#CGI.SERVER_NAME##APPLICATION.path#/assets/logo_asnc.jpg
			<cfelse>
			http://#CGI.SERVER_NAME##APPLICATION.path#/assets/logo_asnc_intranet.jpg
			</cfif></url>
			<link>#source_page_url#</link>
		</image>
		<cfloop query="items">
			
			<cfif isDefined("itemTypeId")>
				<cfset item_type_id = itemTypeId>
			<cfelse>
				<cfset item_type_id = items.type_id>
			</cfif>
			
			<cfset item_url_title = titleToUrl(items.title)>
			
			<cfswitch expression="#item_type_id#">
				<cfcase value="2">
					<cfset item_category = "Entradas">
					<cfset item_link = base_url&"page.cfm?id=#items.area_id###entry-#items.id#">
				</cfcase>
				<cfcase value="3">
					<cfset item_category = "Enlaces">
					<cfset item_link = base_url&"page.cfm?id=#items.area_id###link-#items.id#">
				</cfcase>
				<cfcase value="4">
					<cfset item_category = "Noticias">
					<cfset item_link = base_url&"noticia.cfm?id=#items.id#&title=#item_url_title#">
				</cfcase>
				<cfcase value="5">
					<cfset item_category = "Eventos">
					<cfset item_link = base_url&"evento.cfm?id=#items.id#&title=#item_url_title#">
				</cfcase>
				<cfcase value="10">
					<cfset item_category = "Documentos">
					<cfset item_link = base_url&"page.cfm?id=#items.area_id###document-#items.id#">
				</cfcase>
			</cfswitch>
			
			<item><title><![CDATA[<cfif isDefined("items.title")>#items.title#<cfelse>#items.name#</cfif>]]></title>
				<link><![CDATA[#item_link#]]></link>
				<guid><![CDATA[#item_link#]]></guid>
				<category><![CDATA[#item_category#]]></category>
				<description><![CDATA[#items.description#]]></description>
				<cfif isDefined("items.creation_date")>
					<cfset idate = items.creation_date>
				<cfelse><!---Documents--->
					<cfset idate = items.association_date>
				</cfif>
				<pubDate><![CDATA[#dateFormat(idate,"ddd, dd mmm yyyy")# #timeFormat(idate,"HH:mm:ss")# +0200]]></pubDate>
			</item>
		</cfloop>
	</channel>
</rss>
</cfoutput>
</cfsavecontent>
<cfcontent type="text/xml">
<cfif CGI.HTTP_USER_AGENT CONTAINS "MSIE">
	<cfheader name="Content-Type" value="application/rss+xml" charset="UTF-8">
	<cfheader name="content-disposition" value="attachment; filename=page_rss.xml" charset="UTF-8">
<cfelse>
	<cfheader name="Content-Type" value="text/xml" charset="UTF-8">
</cfif>
<cfoutput>#StripCR(xml)#</cfoutput>