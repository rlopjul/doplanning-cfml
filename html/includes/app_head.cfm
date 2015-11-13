<!---
<cfoutput>
<cfif APPLICATION.title EQ "DoPlanning">
	<div style="float:left; padding-top:2px;">
		<a href="../html/index.cfm"><img src="../html/assets/logo_app.gif" alt="Inicio" title="Inicio"/></a>
	</div>
<cfelse>
	<div style="float:left;">
		<a href="../html/index.cfm" title="Inicio" class="btn"><i class="icon-home" style="font-size:16px"></i></a>
	</div>
</cfif>
<div style="float:right">
	<div style="float:right; margin-right:5px; padding-top:2px;" class="div_text_user_logged">
		<a href="../html/preferences.cfm" class="link_user_logged" title="Preferencias del usuario" lang="es">#getAuthUser()#</a>&nbsp;&nbsp;&nbsp;<a href="../html/logout.cfm" class="text_user_logged" title="Cerrar sesión" lang="es"><i class="icon-signout"></i> <span lang="es">Salir</span></a>
	</div>
</div>
</cfoutput>
--->

<!---
<ul class="nav nav-pills nav-stacked">
	<li class="active"><a href="#">Lo último</a></li>
	<li><a href="#">Árbol</a></li>
	<li><a href="#">Búsqueda</a></li>
	<li><a href="#">Usuario</a></li>
	<li><a href="#">Papelera</a></li>
	<li><a href="#">Administración</a></li>
</ul>
--->

<cfif find("error.cfm", CGI.SCRIPT_NAME) IS 0><!---error.cfm no necesita esto y puede dar problemas en errores de consultad de usuarios--->

  <cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
    <cfinvokeargument name="user_id" value="#SESSION.user_id#">
  </cfinvoke>

</cfif>

<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
</cfinvoke>

<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

<cfoutput>

<div class="overlay"></div>

<!-- Sidebar -->
<nav class="navbar navbar-inverse navbar-fixed-top" id="sidebar-wrapper" role="navigation">
    <ul class="nav sidebar-nav">
        <li class="sidebar-brand">
            <a href="https://doplanning.net" target="_blank">
               <img src="#APPLICATION.htmlPath#/assets/v3/logo_doplanning_menu.png" alt="DoPlanning" title="DoPlanning" />
            </a>
        </li>
        <li>
            <a href="last_items.cfm?abb=#SESSION.client_abb#"><i class="icon-home"></i> <span lang="es">Lo último</span></a>
        </li>
        <li>
            <a href="tree.cfm?abb=#SESSION.client_abb#"><i class="icon-sitemap"></i> <span lang="es">Árbol</span></a>
        </li>
        <li class="dropdown">
          <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-search"></i> <span lang="es">Búsqueda</span> <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu" style="padding-left:15px;">
            <!---<li class="dropdown-header">Dropdown heading</li>--->

            <li><a href="areas_search.cfm?abb=#SESSION.client_abb#" lang="es">Áreas</a></li>

      			<cfloop array="#itemTypesArray#" index="curItemTypeId">

      				<cfif curItemTypeId NEQ 13 AND curItemTypeId NEQ 14 AND curItemTypeId NEQ 15 AND curItemTypeId NEQ 16 AND ( curItemTypeId NEQ 7 OR APPLICATION.moduleConsultations IS true ) AND ( curItemTypeId NEQ 13 OR APPLICATION.moduleForms IS true ) AND ( curItemTypeId NEQ 8 OR APPLICATION.modulePubMedComments IS true ) AND ( curItemTypeId NEQ 20 OR APPLICATION.moduleDPDocuments IS true ) AND ( (curItemTypeId NEQ 2 AND curItemTypeId NEQ 4 AND curItemTypeId NEQ 9) OR APPLICATION.moduleWeb EQ true )>

                        <!---<cfif curItemTypeId NEQ 2>--->
                            <li><a href="#itemTypesStruct[curItemTypeId].namePlural#_search.cfm?abb=#SESSION.client_abb#" lang="es">#itemTypesStruct[curItemTypeId].labelPlural#</a></li>
                        <!---<cfelse>
                            <li><a href="#itemTypesStruct[curItemTypeId].namePlural#_search.cfm" lang="es">Elementos de contenido</a></li>
                        </cfif>--->

              </cfif>

            </cfloop>

            <li><a href="users_search.cfm?abb=#SESSION.client_abb#" lang="es">Usuarios</a></li>

          </ul>
        </li>
        <li class="dropdown">
          <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> <span lang="es">Usuario</span> <span class="caret"></span></a>
          <ul class="dropdown-menu" role="menu" style="padding-left:15px;">
            <!---<li class="dropdown-header">Dropdown heading</li>--->
            <li><a href="preferences_user_data.cfm"><i class="icon-list-alt"></i> <span lang="es">Datos personales</span></a></li>
            <li><a href="preferences_alerts.cfm"><i class="icon-envelope-alt"></i> <span lang="es">Notificaciones</span></a></li>
          </ul>
        </li>
        <li>
            <a href="bin.cfm?abb=#SESSION.client_abb#"><i class="icon-trash"></i> <span lang="es">Papelera</span></a>
        </li>

        <cfinvoke component="#APPLICATION.htmlComponentsPath#/Web" method="getWeb" returnvariable="getWebResult">
    			<cfinvokeargument name="path" value="intranet">
    		</cfinvoke>

        <cfset webQuery = getWebResult.query>

    		<cfif webQuery.recordCount GT 0>

          <cfif SESSION.client_abb NEQ "hcs">
            <li>
                <a href="#APPLICATION.path#/intranet/?abb=#SESSION.client_abb#" target="_blank"><i class="fa fa-archive"></i> <span lang="es">Intranet</span></a>
            </li>
          <cfelse>
            <li>
                <a href="http://intranet.hcs.es/" target="_blank"><i class="fa fa-archive"></i> <span lang="es">Intranet</span></a>
            </li>
          </cfif>

        </cfif>

        <li>
            <a href="admin/main.cfm?abb=#SESSION.client_abb#"><i class="icon-wrench"></i> <span lang="es">Administración</span></a>
        </li>

        <li>
            <a href="logout.cfm?abb=#SESSION.client_abb#"><i class="icon-signout"></i> <span lang="es">Cerrar sesión</span><br><!---<i>#getAuthUser()#</i>---></a>
        </li>
    </ul>
</nav>
<!-- /sidebar-wrapper -->

</cfoutput>

<script>

$(window).resize( function() {

    adjustMarginTop();

});

$(document).ready(function () {

  // Menu
  var trigger = $('.hamburger'),
      overlay = $('.overlay'),
     isClosed = false;

    trigger.click(function () {
      hamburger_cross();
    });

    function hamburger_cross() {

      if (isClosed == true) {
        overlay.hide();
        trigger.removeClass('is-open');
        trigger.addClass('is-closed');
        isClosed = false;

        $(".hamburger").attr("aria-expanded","false");

      } else {
        overlay.show();
        trigger.removeClass('is-closed');
        trigger.addClass('is-open');
        isClosed = true;

         $(".hamburger").attr("aria-expanded","true");
      }
  }

  $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
  });


  adjustMarginTop();

  // Alert
  $('#alertContainer .close').click(function(e) {

    hideAlertMessage();

  });

});

function adjustMarginTop() {

    if( $('#mainNavBarFixedTop').css('position') == "fixed" ) { <!--- si la cabecera está fija --->

        var mainContainerMarginTopPx = parseInt( $('.app_main_container').css('padding-top'), 10);

        if( $('#mainNavBarFixedTop').height() > mainContainerMarginTopPx ) {

             $('.app_main_container').css('padding-top', $('#mainNavBarFixedTop').height()+10);

        }

        <!---alert("mainNavBarFixedTop height "+$('#mainNavBarFixedTop').height())
        alert("app_main_container height "+$('.app_main_container').css('margin-top'));--->

    } else {

       $('.app_main_container').removeAttr('style');
    }

}


<!---
function showAlertMessage(msg, res){

  if($("#alertContainer span").length != 0)
    $("#alertContainer span").remove();

  if(res == true)
    $("#alertContainer").attr("class", "alert alert-success");
  else
    $("#alertContainer").attr("class", "alert alert-danger");

  $("#alertContainer button").after('<span>'+msg+'</span>');

  var maxZIndex = getMaxZIndex();

    $("#alertContainer").css('zIndex',maxZIndex+1);

  $("#alertContainer").fadeIn('slow');


  setTimeout(function(){

      hideAlertMessage();

      }, 9500);
}

function hideAlertMessage(){

  $("#alertContainer").fadeOut('slow', function() {
      $("#alertContainer span").remove();
  });

}
--->

</script>

<!--- Alert --->
<cfinclude template="#APPLICATION.htmlPath#/includes/main_alert.cfm">
