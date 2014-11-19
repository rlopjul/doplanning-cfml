<!---Copyright Era7 Information Technologies 2007-2010
	
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 13-01-2010

	03-06-2013 alucena: añadido language a loadComponent
	12-06-2013 alucena: quitado contentsCss porque por defecto ya carga /ckeditor/contents.css y si se define la ruta da problemas en los accesos externos del SAS que usa reescritura de URLs

--->
<cfcomponent displayname="CKEditorManager" output="true">

	<cfset component = "CKEditorManager">
	
	
	<!------>
	
	
	<!---    loadComponent     --->
	<cffunction name="loadComponent" output="true" access="public" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="width" type="numeric" required="false">
		<cfargument name="height" type="numeric" required="false">
		<cfargument name="toolbar" type="string" required="false" default="DP">
		<cfargument name="toolbarStartupExpanded" type="boolean" default="true">
		<cfargument name="language" type="string" required="false" default="#APPLICATION.defaultLanguage#"/>
		<cfargument name="readOnly" type="boolean" required="false" default="false">
		<cfargument name="toolbarCanCollapse" type="boolean" required="false" default="false">
	
		<cfoutput>
			
			<cfif SESSION.client_administrator EQ SESSION.user_id>
				<cfset arguments.toolbar = "DPAdmin">
			<cfelseif SESSION.client_abb EQ "hcs">
				<cfset arguments.toolbar = "DP_hcs">
			</cfif>
			<script type="text/javascript">
				CKEDITOR.replace('#arguments.name#', {toolbar:'#arguments.toolbar#', toolbarStartupExpanded:#arguments.toolbarStartupExpanded#, 
					toolbarCanCollapse:#arguments.toolbarCanCollapse#, readOnly:#arguments.readOnly#,
					language:'#arguments.language#'
					<cfif isDefined("arguments.width")>
					, width:#arguments.width#
					</cfif>
					<cfif isDefined("arguments.height")>
					, height:#arguments.height#
					</cfif>
					<cfif SESSION.client_administrator EQ SESSION.user_id>
					, forcePasteAsPlainText:false
					</cfif>	
				});
			</script>
			
		</cfoutput>
		<!---contentsCss:'#APPLICATION.htmlPath#/ckeditor/contents.css' (Por defecto, CKEditor ya carga esta página)
		Se quita la definición de la hoja de estilos porque por defecto carga esa hoja de estilos, y si se pasa este valor no se carga la hoja de estilos bien en páginas con reescritura de URLs como los accesos externos del SAS--->
		<!---, enterMode:CKEDITOR.ENTER_BR--->
		
	</cffunction>
</cfcomponent>