<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Row">
	<cfset request_component = "RowManager">


	<!--- ----------------------------------- getRow -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del RowManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getRow" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">

		<cfset var method = "getRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRow" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyRow -------------------------------------- --->

	<cffunction name="getEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true"/>
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getEmptyRow" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.row>
			
	</cffunction>



	<!--- ----------------------------------- fillEmptyRow -------------------------------------- --->

	<cffunction name="fillEmptyRow" output="false" returntype="query" access="public">
		<cfargument name="emptyRow" type="query" required="true"/>
		<cfargument name="fields" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="withDefaultValues" type="boolean" required="false">

		<cfset var method = "fillEmptyRow">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="fillEmptyRow" returnvariable="response">
				<cfinvokeargument name="emptyRow" value="#arguments.emptyRow#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="withDefaultValues" value="#arguments.withDefaultValues#">
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.row>
			
	</cffunction>


	<!--- ----------------------------------- getRowSelectedAreas -------------------------------------- --->

	<cffunction name="getRowSelectedAreas" output="false" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="false">
		<cfargument name="row_id" type="numeric" required="false">

		<cfset var method = "getRowSelectedAreas">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getRowSelectedAreas" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="field_id" value="#arguments.field_id#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>



	<!--- -------------------------------createRow-------------------------------------- --->
	
    <cffunction name="createRow" returntype="struct" access="public">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "createRow">

		<cfset var response = structNew()>
		
		<cftry>
			
			<!---<cfset arguments.action = "create">--->

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro guardado">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- -------------------------------updateRow-------------------------------------- --->
	
    <cffunction name="updateRow" returntype="struct" access="public">
    	<cfargument name="row_id" type="numeric" required="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "updateRow">

		<cfset var response = structNew()>
		
		<cftry>
			
			<!---<cfset arguments.action = "update">--->

			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro modificado">
			</cfif>
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- -------------------------------deleteRowRemote-------------------------------------- --->
	
    <cffunction name="deleteRowRemote" returntype="void" access="remote">
    	<cfargument name="row_id" type="numeric" required="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "deleteRowRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="deleteRow" returnvariable="response">
				<cfinvokeargument name="row_id" value="#arguments.row_id#"/>
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Registro eliminado">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- -------------------------------outputRowFormInputs-------------------------------------- --->
	
    <cffunction name="outputRowFormInputs" returntype="void" access="public" output="true">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row" type="object" required="true">
		<cfargument name="fields" type="query" required="true">
		<cfargument name="search_inputs" type="boolean" required="false">
		
		<cfset var method = "outputRowFormInputs">
		
		<cftry>
					
			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowHtml" method="outputRowFormInputs">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row" value="#arguments.row#">
				<cfinvokeargument name="fields" value="#arguments.fields#">
				<cfinvokeargument name="language" value="#SESSION.user_language#">
				<cfinvokeargument name="search_inputs" value="#arguments.search_inputs#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfcatch>
				<cfoutput>
					<div class="alert alert-danger">
						<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
					</div>
				</cfoutput>
				<cfinclude template="includes/errorHandlerNoRedirect.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>




</cfcomponent>