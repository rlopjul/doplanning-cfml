<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />
</cfoutput>


<cfinclude template="#APPLICATION.htmlPath#/includes/area_id.cfm">

<cfset current_page = CGI.SCRIPT_NAME>

<cfoutput>
<div class="div_head_subtitle_area">
	
	<div class="div_head_subtitle_area_text">Usuarios del área</div>
	
</div>
</cfoutput>

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
	Selección de usuario
	</div>
	
	<div class="div_users">
	
	<cfif numUsers GT 0>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
			<cfinvokeargument name="xmlUsers" value="#xmlUsers#">
			<cfinvokeargument name="page_type" value="1">
		</cfinvoke>	

	<cfelse>
		No hay usuarios.
	</cfif>
	
	</div>

</form>