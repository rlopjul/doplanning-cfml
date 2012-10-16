<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfoutput>
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
<link href="#APPLICATION.path#/jquery/tablesorter/css/style.css" rel="stylesheet" type="text/css" media="all" />
</cfoutput>


<div class="div_head_title">
<cfoutput>
<div class="icon_title">
<a href="all_#lCase(itemTypeNameP)#.cfm"><img src="assets/icons/#lCase(itemTypeNameP)#.png" alt="#itemTypeNameEsP#"/></a>
</div>
<div class="head_title" style="padding-top:4px;"><a href="all_#itemTypeNameP#.cfm">#itemTypeNameEsP#</a></div>
</cfoutput>
</div>

<cfif isDefined("URL.from_user") AND isNumeric(URL.from_user)>
	<cfset user_in_charge = URL.from_user>
<cfelse>
	<cfset user_in_charge = "">
</cfif>

<cfif isDefined("URL.to_user") AND isNumeric(URL.to_user)>
	<cfset recipient_user = URL.to_user>
<cfelse>
	<cfif isDefined("SESSION.user_id")>
		<cfset recipient_user = SESSION.user_id>
	<cfelse>
		<cfset recipient_user = "">
	</cfif>
</cfif>

<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>


<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="xmlResponseContent">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfif isNumeric(user_in_charge)>
	<cfinvokeargument name="user_in_charge" value="#user_in_charge#">
	</cfif>
	<cfif itemTypeId IS 6 AND isNumeric(recipient_user)>
	<cfinvokeargument name="recipient_user" value="#recipient_user#">
	</cfif>
	<cfif isNumeric(limit_to)>
	<cfinvokeargument name="limit" value="#limit_to#">
	</cfif>
</cfinvoke>
	
<cfxml variable="xmlItems">
<cfoutput>
#xmlResponseContent#
</cfoutput>
</cfxml>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="xmlResponse">	
	<cfinvokeargument name="order_by" value="name">
	<cfinvokeargument name="order_type" value="asc">
</cfinvoke>

<cfxml variable="xmlUsers">
	<cfoutput>
	#xmlResponse.response.result.users#
	</cfoutput>
</cfxml>
<cfset numUsers = ArrayLen(xmlUsers.users.XmlChildren)>

<cfoutput>
<div style="clear:both;">
<form method="get" action="#CGI.SCRIPT_NAME#">
	<div style="float:left; margin-right:15px; margin-top:2px;">
		<span style="color:##666666; font-size:12px;">Del usuario:</span> <select name="from_user">
			<option value="">Todos</option>
			<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
				<cfset xmlUser = xmlUsers.users.user[xmlIndex]>
				<option value="#xmlUser.xmlAttributes.id#" <cfif xmlUser.xmlAttributes.id EQ user_in_charge>selected="selected"</cfif>>#xmlUser.family_name.xmlText# #xmlUser.name.xmlText#</option>
			</cfloop>
		</select>
	</div>
	<cfif itemTypeId IS 6>
	<div style="float:left; margin-right:15px; margin-top:2px;">
		<span style="color:##666666; font-size:12px;">Para el usuario:</span> <select name="to_user">
			<option value="">Todos</option>
			<cfloop index="xmlIndex" from="1" to="#numUsers#" step="1">
				<cfset xmlUser = xmlUsers.users.user[xmlIndex]>
				<option value="#xmlUser.xmlAttributes.id#" <cfif xmlUser.xmlAttributes.id EQ recipient_user>selected="selected"</cfif>>#xmlUser.family_name.xmlText# #xmlUser.name.xmlText#</option>
			</cfloop>
		</select>
	</div>
	</cfif>
	
	<div style="float:left; margin-right:10px; margin-top:2px;">
	<span style="color:##666666; font-size:12px;">Limitar resultados a </span><select name="limit">
	<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
	<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
	<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
	</select>
	</div>
	<input type="submit" value="Filtrar" />
</form>
</div>
</cfoutput>

<cfset numItems = ArrayLen(xmlItems.xmlChildren[1].XmlChildren)>
<cfif numItems GT 0>
	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;">Resultado: #numItems# <cfif numItems GT 1>#itemTypeNameEsP#<cfelse>#itemTypeNameEs#</cfif></div>
	</cfoutput>
	<div class="div_messages">
	
	<cfif itemTypeId IS NOT 6>
		<cfset current_url = "all_#lCase(itemTypeNameP)#.cfm?from_user=#user_in_charge#&limit=#limit_to#">
	<cfelse>
		<cfset current_url = "all_#lCase(itemTypeNameP)#.cfm?from_user=#user_in_charge#&to_user=#recipient_user#&limit=#limit_to#">
	</cfif>
	
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
		<cfinvokeargument name="xmlItems" value="#xmlItems#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="full_content" value="true">
		<cfinvokeargument name="return_page" value="#current_url#">
	</cfinvoke>
	</div>
<cfelse>
	<div class="div_messages">
	<cfoutput>
	<div class="div_text_result">No hay #lCase(itemTypeNameEsP)#.</div>
	</cfoutput>
	</div>
</cfif>


<cfset return_page = "index.cfm">
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
	<cfinvokeargument name="return_page" value="#return_page#">
</cfinvoke>