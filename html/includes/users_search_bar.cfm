<cfif isDefined("URL.text")>
	<cfset search_text = URL.text>
	<cfset search_text_highlight = replace(search_text,' ','","',"ALL")>
	<cfoutput>
		<script type="text/javascript">
			$(document).ready(function() {
			  $(".text_item").highlight(["#search_text_highlight#"]);
			});
		</script>
	</cfoutput>
<cfelse>
	<cfset search_text = "">
</cfif>

<cfif isDefined("URL.typology_id")>
	<cfset selected_typology_id = URL.typology_id>
<cfelse>
	<cfset selected_typology_id = "">
</cfif>

<!---<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>--->

<cfoutput>

<script>

	function loadTypology(typologyId) {

		<cfif isDefined("URL.field")>
			goToUrl("#CGI.SCRIPT_NAME#?field=#URL.field#&typology_id="+typologyId);
		<cfelse>
			goToUrl("#CGI.SCRIPT_NAME#?typology_id="+typologyId);
		</cfif>
	}

</script>


<div class="div_search_bar">

	<cfform method="get" name="search_form" action="#CGI.SCRIPT_NAME#">

		<script>
			var railo_custom_form;

			if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
				railo_custom_form = new LuceeForms('search_form');
			else
				railo_custom_form = new RailoForms('search_form');
		</script>


		<cfif isDefined("URL.field")>
			<input type="hidden" name="field" value="#URL.field#" />
		</cfif>

		<div class="<cfif page_type IS 2>container<cfelse>container-fluid</cfif>">

			<!--- Users Typologies --->

			<cfset typologyTableTypeId = 4>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAllTypologies" returnvariable="getAllTypologiesResponse">
				<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
			</cfinvoke>
			<cfset typologies = getAllTypologiesResponse.query>

			<cfif typologies.recordCount GT 0>

				<div class="row">

					<div class="col-sm-12">

						<label for="typology_id" class="col-xs-5 col-sm-3 control-label" lang="es">Tipología</label>

						<div class="col-xs-7 col-sm-9">

							<select name="typology_id" id="typology_id" class="form-control" onchange="loadTypology($('##typology_id').val());">
								<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif> lang="es">Todas</option>
								<option value="null" <cfif selected_typology_id EQ "null">selected="selected"</cfif> lang="es">Básica</option>
								<cfif typologies.recordCount GT 0>
									<cfloop query="typologies">
										<option value="#typologies.id#" <cfif typologies.id IS selected_typology_id>selected="selected"</cfif>>#typologies.title#</option>
									</cfloop>
								</cfif>
							</select>

						</div>

					</div>

				</div>

				<div class="row">

					<div class="col-sm-12">

						<label for="text" class="col-xs-5 col-sm-4 col-md-3 control-label">Usuario</label>

						<div class="col-xs-7 col-sm-8 col-md-9">
							<input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control" placeholder="Texto usuario" lang="es"/>
						</div>

					</div>

				</div>

				<cfif isNumeric(selected_typology_id)>

					<!---Table fields--->
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="getFieldsResponse">
						<cfinvokeargument name="table_id" value="#selected_typology_id#"/>
						<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
						<cfinvokeargument name="with_types" value="true"/>
						<cfinvokeargument name="with_separators" value="true">
					</cfinvoke>

					<cfset fields = getFieldsResponse.tableFields>

					<cfif isDefined("URL.search") AND isDefined("URL.typology_id") AND URL.typology_id IS selected_typology_id><!---isDefined("URL.name") AND --->

						<cfset row = URL>

					<cfelse>

						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getEmptyRow" returnvariable="emptyRow">
							<cfinvokeargument name="table_id" value="#selected_typology_id#">
							<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
							<cfinvokeargument name="fields" value="#fields#">
						</cfinvoke>

						<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="fillEmptyRow" returnvariable="row">
							<cfinvokeargument name="emptyRow" value="#emptyRow#">
							<cfinvokeargument name="fields" value="#fields#">
							<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
							<cfinvokeargument name="withDefaultValues" value="false">
						</cfinvoke>

					</cfif>


					<!--- outputRowFormInputs --->
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowFormInputs">
						<cfinvokeargument name="table_id" value="#selected_typology_id#">
						<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#">
						<cfinvokeargument name="row" value="#row#">
						<cfinvokeargument name="fields" value="#fields#">
						<cfinvokeargument name="search_inputs" value="true">
						<cfinvokeargument name="displayType" value="horizontal">
					</cfinvoke>


				</cfif>

				<div class="row">

					<div class="col-xs-5 col-sm-4 col-md-3">

					</div>

					<div class="col-xs-7 col-sm-8 col-md-9">
						<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
					</div>

				</div>


			<cfelse>

				<div class="row">

					<div class="col-xs-5">
						<input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control" placeholder="Buscar usuario" lang="es"/>
					</div>

					<div class="col-xs-1">
						<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
					</div>

				</div>


			</cfif>



			<!---<div class="row">

				<label for="limit" class="col-xs-2 col-sm-2 control-label" lang="es">Nº resultados</label>

				<div class="col-xs-3 col-sm-2">
					<select name="limit" id="limit" class="form-control">
						<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
						<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
						<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
						<option value="5000" <cfif limit_to IS 5000>selected="selected"</cfif>>5000</option>
					</select>
				</div>

			</div>--->

			<!---<div class="row">

				<div class="col-sm-offset-2 col-sm-10">
					<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
				</div>

			</div>--->

		</div>

	</cfform>

</div>
</cfoutput>
