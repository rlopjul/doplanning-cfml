<cftry>

	<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

	<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
		<cfset table_id = URL[tableTypeName]>
	<cfelse>
		<cflocation url="area.cfm" addtoken="false">
	</cfif>	

	<!---Table fields--->
	<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="getTableFieldsResponse">
		<cfinvokeargument name="table_id" value="#table_id#">
		<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
		<cfinvokeargument name="with_types" value="true">
	</cfinvoke>

	<cfif getTableFieldsResponse.result IS false>
		<cfthrow message="#getTableFieldsResponse.message#">
	</cfif>

	<cfset fields = getTableFieldsResponse.tableFields>

	<div class="div_items">

		<cfoutput>
		<cfif fields.recordCount GT 0>

			<div id="submitDiv1" style="padding-left:2px;padding-top:2px;"><input type="submit" class="btn btn-primary" name="copy" value="Copiar campos" lang="es"/>
			</div>

			<cfset fields_selectable = true>
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/table_fields_list.cfm">

			<div style="height:10px;"><!--- ---></div>

			<div id="submitDiv2" style="padding-left:2px;"><input type="submit" class="btn btn-primary" name="copy" value="Copiar campos" lang="es"/>
				<!---<span class="divider">&nbsp;</span><a href="#return_page#" class="btn btn-default" lang="es">Cancelar</a>--->
			</div>

		<cfelse>				

			<div class="div_text_result"><span lang="es">No tiene campos para copiar.</span></div>

		</cfif>
		</cfoutput>

	</div>


	<cfcatch>

		<cfoutput>
			<div class="alert alert-danger">
				<i class="icon-warning-sign"></i> <span lang="es">#cfcatch.message#</span>
			</div>
		</cfoutput>

		<cfinclude template="#APPLICATION.htmlPath#/components/includes/errorHandlerNoRedirect.cfm">

	</cfcatch>

</cftry>