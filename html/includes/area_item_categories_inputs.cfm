<cfoutput>

<!--- Categories --->

<!--- getAreaItemTypesOptions --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItemType" method="getAreaItemTypesOptions" returnvariable="getItemTypesOptionsResponse">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#"/>
</cfinvoke>

<cfset itemTypeOptions = getItemTypesOptionsResponse.query>

<cfif isNumeric(itemTypeOptions.category_area_id)>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

	<div class="row">

		<div class="col-md-12">

			<label class="control-label" for="categories_ids" lang="es">Categorías</label>

		</div>

	</div>

	<div class="row">

		<div class="col-sm-11 col-sm-offset-1" style="margin-bottom:10px">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getSubAreas" returnvariable="subAreas">
				<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif subAreas.recordCount GT 0>

				<cfif isDefined("itemCategories") AND itemCategories.recordCount GT 0>
					<cfset selectedAreasList = valueList(itemCategories.category_id)>
				<cfelseif isDefined("objectItem.categories_ids") AND isArray(objectItem.categories_ids)>
					<cfset selectedAreasList = arrayToList(objectItem.categories_ids)>
        <cfelseif isDefined("table.categories_ids") AND isArray(table.categories_ids)>
          <cfset selectedAreasList = arrayToList(table.categories_ids)>
				<cfelse>
					<cfset selectedAreasList = "">
				</cfif>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaHtml" method="outputSubAreasInput">
					<cfinvokeargument name="area_id" value="#itemTypeOptions.category_area_id#">
					<cfinvokeargument name="subAreas" value="#subAreas#">
					<cfif len(selectedAreasList) GT 0>
						<cfinvokeargument name="selected_areas_ids" value="#selectedAreasList#">
					</cfif>
					<cfinvokeargument name="recursive" value="false">
					<cfinvokeargument name="field_name" value="categories_ids"/>
					<cfinvokeargument name="field_input_type" value="checkbox">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<script>
				addRailoRequiredCheckBox("categories_ids[]", "Debe seleccionar al menos una categoría");
				</script>

				<p class="help-block" lang="es">Estas categorías permiten a los usuarios clasificar los elementos y filtrar las notificaciones por email que se reciben</p>

			<cfelse>

				<p class="help-block" lang="es">Este elemento tiene un área para categorías seleccionada pero esta área no tiene subareas para definir las categorías</p>

			</cfif>

		</div>

	</div>

</cfif>

</cfoutput>
