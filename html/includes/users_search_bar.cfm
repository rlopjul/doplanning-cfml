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

<!---<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>--->

<cfoutput>
<div class="div_search_bar">

	<form method="get" name="search_form" action="#CGI.SCRIPT_NAME#">

		<cfif isDefined("URL.field")>
			<input type="hidden" name="field" value="#URL.field#" />
		</cfif>

		<div class="container">

			<div class="row">

				<div class="col-xs-5">
					<!---<div class="input-group">
					  <span class="input-group-addon"><i class="icon-search"></i></span>
					  <input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control"/>
					</div>--->
					<input type="text" name="text" id="text" value="#HTMLEditFormat(search_text)#" class="form-control" placeholder="Usuario" lang="es"/>
				</div>

				<div class="col-xs-1">
					<input type="submit" name="search" class="btn btn-primary" lang="es" value="Buscar" />
				</div>

			</div>

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

	</form>

</div>
</cfoutput>