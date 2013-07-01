<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_users_select_en.js" charset="utf-8" type="text/javascript"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">
</cfoutput>


<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">

<cfset current_page = CGI.SCRIPT_NAME>

<!---<cfoutput>
<div class="div_head_subtitle_area">
	<div class="div_head_subtitle_area_text">Usuarios del área</div>
</div>
</cfoutput>--->

<form action="users.cfm?area=#area_id#" method="post" style="padding:0; margin:0; clear:none;">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getAllAreaUsers" returnvariable="xmlResponse">	
		<cfinvokeargument name="area_id" value="#area_id#">
		<!---<cfinvokeargument name="order_by" value="#order_by#">
		<cfinvokeargument name="order_type" value="#order_type#">--->
	</cfinvoke>
	
	<cfxml variable="xmlUsers">
		<cfoutput>
		#xmlResponse.response.result.users#
		</cfoutput>
	</cfxml>
	<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>
	
	<div class="div_head_subtitle">
	<span lang="es">Selección de usuario</span>
	</div>
	
	<div class="div_users">
	
	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersSelectList">
			<cfinvokeargument name="xmlUsers" value="#xmlUsers#">
			<cfinvokeargument name="page_type" value="1">
		</cfinvoke>	

	<cfelse>
		<span lang="es">No hay usuarios.</span>
	</cfif>
	
	</div>
</form>
<br/>
<small style="margin-left:5px;" lang="es">En esta lista solo se incluyen los usuarios con acceso al área actual.</small>