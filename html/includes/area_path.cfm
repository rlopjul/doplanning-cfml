<cfif app_version EQ "mobile">

	<cfif loggedUser.internal_user IS true>

		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
			<cfinvokeargument name="area_id" value="#area_id#">
			<cfinvokeargument name="separator" value=" > ">
			<cfinvokeargument name="cur_area_link_class" value="current_area">

			<cfinvokeargument name="with_base_link" value="area_items.cfm?area="/>
		</cfinvoke>

	<cfelse>

		<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getHighestAreaUserAssociated" returnvariable="getHighestAreaResponse">
			<cfinvokeargument name="area_id" value="#area_id#"/>
			<cfinvokeargument name="user_id" value="#SESSION.user_id#"/>
			<cfinvokeargument name="userType" value="users"/>
		</cfinvoke>

		<cfif getHighestAreaResponse.result IS true>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaPath" returnvariable="area_path">
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="separator" value=" > ">
				<cfinvokeargument name="from_area_id" value="#getHighestAreaResponse.highest_area_id#">
				<cfinvokeargument name="include_from_area" value="true">
				<cfinvokeargument name="cur_area_link_class" value="current_area">

				<cfinvokeargument name="with_base_link" value="area_items.cfm?area="/>
			</cfinvoke>

		</cfif>

	</cfif>

	<cfoutput>
		<div class="row">
			<div class="col-sm-12">

				<h3 class="sr-only" lang="es">Ruta del área:</h3>
				<p style="font-size:15px;margin-bottom:5px;">#area_path#<a onclick="loadAreaTree(#area_id#)" class="btn btn-link" style="padding-top:0;padding-left:10px;" title="Abrir árbol con ruta expandida" lang="es"><img src="#APPLICATION.htmlPath#/assets/v3/icons/plus.png" alt="Abrir árbol con ruta expandida" lang="es"/></a></p>

			</div>
		</div>

		<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal-bs3patch.css?v=1.2" rel="stylesheet">
		<link href="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/css/bootstrap-modal.css" rel="stylesheet">

		<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modal.js"></script>
		<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-modal/js/bootstrap-modalmanager.js"></script>
	</cfoutput>

	<script>
		<!---To enable the loading spinner in Bootstrap 3--->
		$.fn.modal.defaults.spinner = $.fn.modalmanager.defaults.spinner =
	    '<div class="loading-spinner" style="width: 200px; margin-left: -100px;">' +
	        '<div class="progress progress-striped active">' +
	            '<div class="progress-bar" style="width: 100%;"></div>' +
	        '</div>' +
	    '</div>';
	    <!--- To set modal max height --->
		$.fn.modal.defaults.maxHeight = function(){
		    return $(window).height() - 170;
		}
	</script>

	<script>
		// Modal
		var $modal = null;

		function loadAreaTree(areaId){

			$('body').modalmanager('loading');

			var noCacheNumber = generateRandom();

			/*if(url.indexOf("?") == -1)
				url = url+"?n"+noCacheNumber;
			else
				url = url+"&n"+noCacheNumber;*/

			var url = "html_content/tree_modal.cfm?area="+areaId;

			$modal.load(url, '', function(){
			  $modal.modal({width:740, backdrop:'static'});/*680*/
			});
		}

		$(document).ready(function () {

			// Modal
			$modal = $('#ajax-modal');

		});
	</script>

	<!--- Modal Window --->
	<div id="ajax-modal" class="modal container fade" role="dialog" style="width: 500px;" tabindex="-1"></div><!---hide funcionaba en bs2--->


</cfif>
