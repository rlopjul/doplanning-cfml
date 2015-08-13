<cfoutput>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
</cfoutput>


<cfif isDefined("URL.from_user") AND isNumeric(URL.from_user)>
	<cfset user_log = URL.from_user>
<cfelse>
	<cfset user_log = "">
</cfif>


<cfif isDefined("URL.action")>
	<cfset action = URL.action>
<cfelse>
	<cfset action = "">
</cfif>


<cfif isDefined("URL.from_date")>
	<cfset from_date = URL.from_date>
<cfelse>
	<cfset previousday = DateAdd("d",-1,now())>
	<cfset from_date = "#DateFormat(previousday, "DD-MM-YYYY")#">
</cfif>

<cfif isDefined("URL.end_date")>
	<cfset end_date = URL.end_date>
<cfelse>
	<cfset end_date = "#DateFormat(now(), "DD-MM-YYYY")#">
</cfif>


<cfif isDefined("URL.limit") AND isNumeric(URL.limit)>
	<cfset limit_to = URL.limit>
<cfelse>
	<cfset limit_to = 100>
</cfif>


<cfinvoke component="#APPLICATION.componentsPath#/LogManager" method="getLogActions" returnvariable="getLogActionsResponse">	
</cfinvoke>

<cfset logActions = getLogActionsResponse.query>
<!---	<cfset numLogActions = logActions.RecordCount>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="getUsersResponse">	
	<!---<cfinvokeargument name="order_by" value="name">
	<cfinvokeargument name="order_type" value="asc">---->
</cfinvoke>

<cfset users = getUsersResponse.users>
<cfset numUsers = ArrayLen(users)>
	
<script type="text/javascript">
	
	$(function() {
	
		$('#from_date').datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  endDate: $('#end_date').val()	  
		});
		
		
		$('#end_date').datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked',
		  autoclose: true
		});
	
<!---		$.datepicker.setDefaults($.datepicker.regional['es']);
		
		var dates = $( ".input_datepicker" ).datepicker({ dateFormat: 'dd-mm-yy', 
			changeMonth: true,
			changeYear: true
			, onSelect: function( selectedDate ) {
				var option = this.id == "date_from" ? "minDate" : "maxDate",
				instance = $( this ).data( "datepicker" ),
				date = $.datepicker.parseDate(
					instance.settings.dateFormat ||
					$.datepicker._defaults.dateFormat,
					selectedDate, instance.settings );
					//dates.not( this ).datepicker( "option", option, date );
					if(this.id == "date_from")
						$( "##date_end" ).datepicker( "option", option, date );
					else if(this.id == "date_end")
						$( "##date_from" ).datepicker( "option", option, date );
				}
			});--->
		
	});
	
	
	function setEndDate(){
		$('#from_date').datepicker('setEndDate', $('#end_date').val());
	}

	function setFromDate(){
		$('#end_date').datepicker('setStartDate', $('#from_date').val());
	}

	
</script>



<cfoutput>
<div class="div_search_bar"><!---style="clear:both; padding-left:2px;"--->
<form method="get" class="form-horizontal" action="#CGI.SCRIPT_NAME#">
	
	
	<div class="row">

		<label for="from_user" class="col-sm-2 control-label" lang="es">Usuario</label> 
		
		<div class="col-sm-10">
			<select name="from_user" id="from_user" class="form-control">
				<option value="" lang="es">Todos</option>
				<cfloop index="objectUser" array="#users#">	
					
					<option value="#objectUser.id#" <cfif objectUser.id EQ user_log>selected="selected"</cfif>>#objectUser.family_name# #objectUser.name#</option>
					
				</cfloop>
			</select>
		</div>

	</div>
	
	<div class="row">

		<label for="action" class="col-sm-2 control-label" lang="es">Acción</label> 

		<div class="col-sm-10">
			<select name="action" id="action" class="form-control">
				<option value="" lang="es">Todas</option>
				<cfloop query="logActions">	
					<option <cfif logActions.name EQ action>selected="selected"</cfif> value="#logActions.name#" >#logActions.action_es#</option>
				</cfloop>
			</select>
		</div>	

	</div>

	<div class="row">

		<label for="from_date" class="col-xs-2 col-sm-2 control-label" lang="es">Fecha desde</label>

		<div class="col-xs-4 col-sm-4">		 		
			<input type="text" name="from_date" id="from_date" class="input_datepicker" value="#from_date#" onchange="setFromDate()">
		</div>

		<label for="end_date" class="col-xs-2 col-sm-2 control-label" lang="es">Fecha hasta</label> 

		<div class="col-xs-4 col-sm-4">
			<input type="text" name="end_date" id="end_date" value="#end_date#" class="input_datepicker" onchange="setEndDate()"/>
		</div>

	</div>
		
	<div class="row">

		<label for="limit" class="col-xs-2 col-sm-2 control-label" lang="es">Nº resultados</label> 

		<div class="col-xs-4 col-sm-2">
			<select name="limit" id="limit" class="form-control">
				<option value="100" <cfif limit_to IS 100>selected="selected"</cfif>>100</option>
				<option value="500" <cfif limit_to IS 500>selected="selected"</cfif>>500</option>
				<option value="1000" <cfif limit_to IS 1000>selected="selected"</cfif>>1000</option>
			</select>
		</div>

	</div>

	<div class="row">
		<div class="col-sm-offset-2 col-sm-10"> 
			<input type="submit" name="search" class="btn btn-primary" lang="es" value="Filtrar" style="margin-top:30px;" />
		</div>
	</div>

	<!---<span style="font-size:10px" lang="es">Formato DD-MM-AAAA. Ejemplo:</span><span style="font-size:10px"> #DateFormat(now(), "DD-MM-YYYY")#</span>--->
</form>
</div>
</cfoutput>