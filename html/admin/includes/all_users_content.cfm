<!---
page_type
1 area users
2 admin users
--->

<cfif NOT isDefined("page_type")>
	<cfset page_type = 1>
</cfif>


<cfoutput>
<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>
<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<!---<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>--->

<div class="div_head_menu">
	<div class="navbar navbar-default navbar-static-top navbar_admin" style="margin-bottom:8px;">
		<div class="container-fluid">
			<span class="navbar-brand" lang="es">Usuarios de la organización</span>
			<cfif SESSION.client_administrator IS SESSION.user_id>
				<a class="btn btn-primary btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_new.cfm');"><i class="icon-plus icon-white" style="font-size:14px"></i> <span lang="es">Nuevo usuario</span></a><!---color:##5BB75B;--->

				<cfif page_type IS 2>

					<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/all_administrators.cfm');"><i class="icon-group icon-white"></i> <span lang="es">Administradores</span></a>
					<!---<cfif SESSION.client_abb NEQ "hcs">--->
						<!---<div class="btn-group">--->
							<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/client_options.cfm');"><i class="icon-edit icon-white"></i> <span lang="es">Opciones de la organización</span></a>
						<!---</div>--->
					<!---</cfif>--->

					<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/users_export.cfm');" title="Exportar usuarios"><i class="icon-circle-arrow-down"></i> <span lang="es">Exportar usuarios</span></a>

					<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/users_import.cfm');"><i class="icon-edit icon-circle-arrow-up"></i> <span lang="es">Importar usuarios</span></a>

				</cfif>

			</cfif>
		</div>
	</div>
</div>

<!---
<div class="div_head_subtitle_area">

	<!---<a href="#CGI.SCRIPT_NAME#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>--->

</div>--->
</cfoutput>


<!--- SEARCH BAR --->
<cfinclude template="#APPLICATION.htmlPath#/includes/users_search_bar.cfm">

<cfif isDefined("URL.search")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" argumentcollection="#URL#" returnvariable="usersResponse">
		<cfif len(search_text) GT 0>
		<cfinvokeargument name="search_text" value="#search_text#">
		</cfif>
		<!---<cfif isNumeric(limit_to)>
		<cfinvokeargument name="limit" value="#limit_to#">
		</cfif>--->
	</cfinvoke>

	<cfset users = usersResponse.users>
	<cfset numUsers = ArrayLen(users)>

	<cfoutput>
	<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numUsers# <span lang="es"><cfif numUsers GT 1>Usuarios<cfelse>Usuario</cfif></span></div>
	</cfoutput>

	<div class="div_items">

		<cfif numUsers GT 0>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="outputUsersList">
				<cfinvokeargument name="users" value="#users#">
				<cfinvokeargument name="open_url_target" value="userAdminIframe">

				<cfif page_type IS 1>
					<cfinvokeargument name="filter_enabled" value="true">
					<cfinvokeargument name="select_enabled" value="true">
				</cfif>

				<cfinvokeargument name="showAdminFields" value="true">
			</cfinvoke>

		<cfelse>

			<script type="text/javascript">
				openUrlHtml2('empty.cfm','userAdminIframe');
			</script>

			<span lang="es">No se han encontrado usuarios.</span>

		</cfif>

	</div>

<cfelse>

	<script type="text/javascript">
		openUrlHtml2('empty.cfm','userAdminIframe');
	</script>

	<!---<p class="bg-info" style="margin:15px;padding:5px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca un texto y haga click en Buscar para listar usuarios de la organización.</span></p>--->

	<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca un texto y haga click en Buscar para listar usuarios de la organización.</span></div>

</cfif>

<script>

	function openAreaAssociateUsers() {

		var associateUsersIds = "";

		$('#usersTable tbody tr:visible input[type=checkbox]:checked').each(function() {

			if(associateUsersIds.length > 0)
				associateUsersIds = associateUsersIds+","+this.value;
			else
				associateUsersIds = this.value;

		});

		if(associateUsersIds.length > 0)
			parent.openAreaAssociateUsersModal(associateUsersIds);
		else
			parent.showAlertModal("No hay usuarios");

	}

	$(document).ready(function() {

		$('#addSelectedUsersNavBar').hide();

	    $('#usersTable tbody input[type=checkbox]').on('click', function(e) {

	    	stopPropagation(e);

	    	if( $('#usersTable tbody tr:visible input[type=checkbox]:checked').length > 0 )
				$('#addSelectedUsersNavBar').show();
			else
				$('#addSelectedUsersNavBar').hide();

	    });

	});
</script>

<nav class="navbar navbar-default navbar-fixed-bottom navbar_admin" id="addSelectedUsersNavBar">
  	<div class="container-fluid">

		<a class="btn btn-info btn-sm navbar-btn" onclick="openAreaAssociateUsers()"><i class="icon-plus icon-white"></i> <span lang="es">Asociar usuarios seleccionados al área</span></a>

  	</div>
</nav>
