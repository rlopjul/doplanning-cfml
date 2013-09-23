<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Field">
	<cfset request_component = "FieldManager">


	<!--- ----------------------------------- getFieldTypes ------------------------------------- --->
	
	<cffunction name="getFieldTypes" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getFieldTypes">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getFieldTypes" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getField -------------------------------------- --->

	<!---Este método no hay que usarlo en páginas en las que su contenido se cague con JavaScript (páginas de html_content) porque si hay un error este método redirige a otra página. En esas páginas hay que obtener el Item directamente del AreaItemManager y comprobar si result es true o false para ver si hay error y mostrarlo correctamente--->

	<cffunction name="getField" output="false" returntype="query" access="public">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_table" type="numeric" required="false" default="false">

		<cfset var method = "getField">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getField" returnvariable="response">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_table" value="#arguments.with_table#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.field>
			
	</cffunction>


	<!--- ----------------------------------- getEmptyField -------------------------------------- --->

	<cffunction name="getEmptyField" output="false" returntype="query" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfset var method = "getField">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="getEmptyField" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>									
			
		</cftry>
		
		<cfreturn response.field>
			
	</cffunction>


	<!--- -------------------------------createFieldRemote-------------------------------------- --->
	
    <cffunction name="createFieldRemote" returntype="void" access="remote">
    	<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="field_type_id" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="false">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "createFieldRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="createField" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset msg = URLEncodedFormat("Campo creado")>

				<cflocation url="#arguments.return_path#&field=#response.field_id#&res=#response.result#&msg=#msg#" addtoken="no">
			<cfelse>
				<cfset msg = URLEncodedFormat(response.message)>

				<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">
			</cfif>

			<!---SI HAY UN ERROR AQUÍ DEBE ENVIAR EL FORMULARIO A LA PÁGINA DE VUELTA--->
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- -------------------------------updateFieldRemote-------------------------------------- --->
	
    <cffunction name="updateFieldRemote" returntype="void" access="remote">
    	<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="label" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="required" type="boolean" required="false" default="false">
        <cfargument name="default_value" type="string" required="true">
        <cfargument name="position" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "updateFieldRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="updateField" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Campo modificado">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&field=#arguments.field_id#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



	<!--- -------------------------------deleteFieldRemote-------------------------------------- --->
	
    <cffunction name="deleteFieldRemote" returntype="void" access="remote">
    	<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfargument name="return_path" type="string" required="yes">
		
		<cfset var method = "deleteFieldRemote">

		<cfset var response = structNew()>
		
		<cftry>
					
			<cfinvoke component="#APPLICATION.componentsPath#/FieldManager" method="deleteField" returnvariable="response">
				<cfinvokeargument name="field_id" value="#arguments.field_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Campo eliminado">
			</cfif>
			
			<cfset msg = URLEncodedFormat(response.message)>
			
			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">		
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>



</cfcomponent>