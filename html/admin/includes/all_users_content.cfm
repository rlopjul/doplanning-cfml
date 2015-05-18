<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8"></script>
<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<!---<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>--->

<div class="div_head_menu">
	<div class="navbar navbar-default navbar-static-top">
		<div class="container-fluid">
			<span class="navbar-brand">Usuarios de la organización</span>
			<cfif SESSION.client_administrator IS SESSION.user_id>
				<a class="btn btn-primary btn-sm navbar-btn" onclick="parent.loadModal('html_content/user_new.cfm');"><i class="icon-plus icon-white" style="font-size:14px"></i> Nuevo usuario</a><!---color:##5BB75B;--->
				

				<a class="btn btn-default btn-sm navbar-btn" onclick="parent.loadModal('html_content/all_administrators.cfm');"><i class="icon-group icon-white"></i> <span lang="es">Administradores</span></a>
				<!---<cfif SESSION.client_abb NEQ "hcs">--->
					<!---<div class="btn-group">--->
						<a class="btn btn-info btn-default navbar-btn" onclick="parent.loadModal('html_content/client_options.cfm');"><i class="icon-edit icon-white"></i> <span lang="es">Opciones de la organización</span></a>
					<!---</div>--->
				<!---</cfif>--->

				<a class="btn btn-default btn-sm navbar-btn" href="#APPLICATION.htmlComponentsPath#/User.cfc?method=exportUsersDownload" onclick="return downloadFileLinked(this,event)" title="Exportar usuarios"><i class="icon-circle-arrow-down"></i> Exportar usuarios</a>
			</cfif>
		</div>
	</div>
</div>

<!---<cfif SESSION.client_administrator IS SESSION.user_id>
<div class="btn-toolbar" style="margin-left:10px;margin-bottom:10px;">
	<div class="btn-group">
		
	</div>
</div>
</cfif>--->


<!---
<div class="div_head_subtitle_area">

	<!---<a href="#CGI.SCRIPT_NAME#" class="btn btn-default btn-sm" title="Actualizar" lang="es"><i class="icon-refresh"></i> <span lang="es">Actualizar</span></a>--->

</div>--->
</cfoutput>


<!--- SEARCH BAR --->
<cfinclude template="#APPLICATION.htmlPath#/includes/users_search_bar.cfm">

<cfif isDefined("URL.search")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUsers" returnvariable="usersResponse">
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
				<cfinvokeargument name="filter_enabled" value="true">
				<cfinvokeargument name="select_enabled" value="true">
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
	
	<p class="bg-info" style="margin:15px;padding:5px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Introduzca un texto y haga click en "Buscar" para listar usuarios de la organización.</span></p><!---text-info--->

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

<nav class="navbar navbar-default navbar-fixed-bottom" id="addSelectedUsersNavBar">
  	<div class="container-fluid">
  	
		<a class="btn btn-info btn-sm navbar-btn" onclick="openAreaAssociateUsers()"><i class="icon-plus icon-white"></i> Asociar usuarios seleccionados al área</a>

  	</div>
</nav>