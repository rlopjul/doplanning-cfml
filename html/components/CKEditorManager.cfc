<!---Copyright Era7 Information Technologies 2007-2010
	
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 13-01-2010

--->
<cfcomponent displayname="CKEditorManager" output="true">

	<cfset component = "CKEditorManager">
	
	
	<!------>
	
	
	<!---    loadComponent     --->
	<cffunction name="loadComponent" output="true" access="public" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="width" type="numeric" required="no">
		<cfargument name="height" type="numeric" required="no">
		<cfargument name="toolbar" type="string" required="no" default="DP">
		<cfargument name="toolbarStartupExpanded" type="boolean" default="true">
	
		<cfoutput>
			
			<script type="text/javascript">
				CKEDITOR.replace('#arguments.name#', {toolbar:'#arguments.toolbar#', toolbarStartupExpanded:#arguments.toolbarStartupExpanded#, contentsCss:'#APPLICATION.htmlPath#/ckeditor/contents.css'
					<cfif isDefined("arguments.width")>
					, width:#arguments.width#
					</cfif>
					<cfif isDefined("arguments.height")>
					, height:#arguments.height#
					</cfif>});
			</script>
			<!--- --->
		</cfoutput>
		<!---, enterMode:CKEDITOR.ENTER_BR--->
		
	</cffunction>
</cfcomponent>