<!---Required vars

--->

<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
<cfset client_abb = SESSION.client_abb>
<cfset user_id = SESSION.user_id>
<cfset incidences_tb = "#client_abb#_incidences">
<cfquery datasource="#client_dsn#" name="incidences">
	SELECT *, DATE_FORMAT(incidences.creation_date,'%d-%m-%y %T') AS creation_date_formatted
	FROM #incidences_tb# AS incidences
	WHERE incidences.user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
	ORDER BY incidences.creation_date DESC;
</cfquery>
<cfquery datasource="#APPLICATION.dsn#" name="incidences_types">
	SELECT *
	FROM app_incidences_types AS incidences_types;
</cfquery>
<cfquery dbtype="query" name="incidences_list">
	SELECT *
	FROM incidences, incidences_types
	WHERE incidences.type_id = incidences_types.id
	ORDER BY incidences.creation_date DESC;
</cfquery>
<div style="clear:both;">
<table class="table_incidences">
	<tr style="background-color:#C8C8C8; height:22px;">
		<td style="width:80px;"><b>ID</b></td>
		<td><b>Asunto</b></td>
		<td><b>Tipo</b></td>
		<td><b>Fecha de registro</b></td>
		<td><b>Estado</b></td>
		<td><b>Fecha de resolución</b></td>
	</tr>
	<cfoutput>
	<cfloop query="incidences_list">
	<tr>
		<td colspan="6" style="height:2px;"></td>
	</tr>
	<tr class="incidence">
		<td>#client_abb##incidences_list.id#</td>
		<td>#incidences_list.title#</td>
		<td>#incidences_list.title_es#</td>
		<td>#incidences_list.creation_date_formatted#</td>
		<td><cfif incidences_list.status EQ "pending">Pendiente<cfelseif incidences_list.status EQ "resolved">Resuelta<cfelse>#incidences_list.status#</cfif></td>
		<td>#incidences_list.resolution_date#</td>
	</tr>	
	</cfloop>
	</cfoutput>
</table>
</div>