<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAllAreasAdministrators" returnvariable="usersResponse">
</cfinvoke>

<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h4 lang="es">Usuarios administradores de áreas</h4>
</div>

<div class="modal-body">

	<cfif usersResponse.result IS false>
		<cfoutput>
			#usersResponse.message#
		</cfoutput>

	<cfelse>

		<cfset users = usersResponse.usersArray>
		<cfset numUsers = ArrayLen(users)>

		<span class="help-block" lang="es">Puede añadir o quitar administradores accediendo al área correspondiente</span>

		<div class="div_items">
			
			<cfif numUsers GT 0>

				<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputAdministratorsList">
					<cfinvokeargument name="users" value="#users#">
				</cfinvoke>	

			<cfelse>
				<span lang="es">No hay usuarios administradores asignados.</span>
			</cfif>
			
		</div>	
		
	</cfif>

</div>

<!--- Area Administrator Dissociate Modal --->
<cfinclude template="area_administrator_dissociate_modal.cfm" />