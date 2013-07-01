<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_items_content_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_head_subtitle_area">
	
	<!---<div class="div_head_subtitle_area_text"><strong>USUARIOS</strong><br/> del área</div>--->
	
	<a href="users.cfm?area=#area_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>
		
</div>
</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="usersResponse">
	<cfinvokeargument name="area_id" value="#area_id#">
</cfinvoke>

<cfxml variable="xmlUsers">
	<cfoutput>
	#usersResponse.usersXml#
	</cfoutput>
</cfxml>
<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>

<div class="div_users">
	
	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="xmlUsers" value="#xmlUsers#">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="user_in_charge" value="#objectArea.user_in_charge#">
			<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
				<cfinvokeargument name="show_area_members" value="true">
			</cfif>
		</cfinvoke>	

	<cfelse>
		<span lang="es">No hay usuarios.</span>
	</cfif>
	
</div>