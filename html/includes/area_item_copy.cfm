<!---Required vars: 
	itemTypeId
	return_path

--->
<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("FORM.areas_ids")>

	<!---<cfset item_id = FORM.item_id>--->
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="copyItemToAreas" returnvariable="resultCopyItem">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<!---<cfinvokeargument name="item_id" value="#item_id#">--->
		<cfinvokeargument name="areas_ids" value="#FORM.areas_ids#">
		
		<cfinvokeargument name="title" value="#FORM.title#">
		<cfif isDefined("FORM.link")>
			<cfinvokeargument name="link" value="#FORM.link#">
		</cfif>
		<cfif isDefined("FORM.link_target")>
			<cfinvokeargument name="link_target" value="#FORM.link_target#">
		</cfif>
        <cfinvokeargument name="description" value="#FORM.description#">
		<cfif isDefined("FORM.Filedata")><!---Filedata puede no estar definido si ya existe un archivo--->
        	<cfinvokeargument name="Filedata" value="#FORM.Filedata#">
		</cfif>
		<cfif isDefined("FORM.imagedata")><!---imagedata puede no estar definido si ya existe un archivo de imagen--->
        	<cfinvokeargument name="imagedata" value="#FORM.imagedata#">
		</cfif>
		<cfif isDefined("FORM.copy_attached_file_id")>
			<cfinvokeargument name="copy_attached_file_id" value="#FORM.copy_attached_file_id#">
		</cfif>
		<cfif isDefined("FORM.copy_attached_image_id")>
			<cfinvokeargument name="copy_attached_image_id" value="#FORM.copy_attached_image_id#">
		</cfif>
		<cfif isDefined("FORM.notify_by_sms")>
			<cfinvokeargument name="notify_by_sms" value="#FORM.notify_by_sms#">
		</cfif>
		<cfif isDefined("FORM.post_to_twitter")>
			<cfinvokeargument name="post_to_twitter" value="#FORM.post_to_twitter#">
		</cfif>
		<cfif isDefined("FORM.creation_date")>
			<cfinvokeargument name="creation_date" value="#FORM.creation_date#">
		</cfif>
		<cfif isDefined("FORM.start_date")>
			<cfinvokeargument name="start_date" value="#FORM.start_date#">
		</cfif>
		<cfif isDefined("FORM.end_date")>
			<cfinvokeargument name="end_date" value="#FORM.end_date#">
		</cfif>
		<cfif isDefined("FORM.start_hour") AND isDefined("FORM.start_minute")>
			<cfinvokeargument name="start_hour" value="#FORM.start_hour#">
			<cfinvokeargument name="start_minute" value="#FORM.start_minute#">
		</cfif>
		<cfif isDefined("FORM.end_hour") AND isDefined("FORM.end_minute")>
			<cfinvokeargument name="end_hour" value="#FORM.end_hour#">
			<cfinvokeargument name="end_minute" value="#FORM.end_minute#">
		</cfif>
		<cfif isDefined("FORM.place")>
			<cfinvokeargument name="place" value="#FORM.place#">
		</cfif>
		<cfif isDefined("FORM.recipient_user")>
			<cfinvokeargument name="recipient_user" value="#FORM.recipient_user#">
		</cfif>
		<cfif isDefined("FORM.estimated_value")>
			<cfinvokeargument name="estimated_value" value="#FORM.estimated_value#">
		</cfif>
		<cfif isDefined("FORM.real_value")>
			<cfinvokeargument name="real_value" value="#FORM.real_value#">
		</cfif>
		<cfif isDefined("FORM.done")>
			<cfinvokeargument name="done" value="#FORM.done#">
		</cfif>
		<cfif isDefined("FORM.position")>
			<cfinvokeargument name="position" value="#FORM.position#">
		</cfif>       
		<cfif isDefined("FORM.display_type_id")>
			<cfinvokeargument name="display_type_id" value="#FORM.display_type_id#">
		</cfif>
		<cfif isDefined("FORM.iframe_url")>
			<cfinvokeargument name="iframe_url" value="#FORM.iframe_url#">
		</cfif>
		<cfif isDefined("FORM.iframe_display_type_id")>
			<cfinvokeargument name="iframe_display_type_id" value="#FORM.iframe_display_type_id#">
		</cfif>   
		<cfif isDefined("FORM.identifier")>
			<cfinvokeargument name="identifier" value="#FORM.identifier#">
		</cfif>
		<!---<cfinvokeargument name="return_path" type="string" required="yes">--->
	</cfinvoke>
	<cfset msg = resultCopyItem.message>
	<cfset res = resultCopyItem.result>
	
	<!---
	<cfif NOT isDefined("FORM.sourceItemTypeId")>
		<cflocation url="#return_path##itemTypeNameP#.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelse><!---Devuelve a la lista de mensajes porque se ha copiado desde un elemento distinto del elemento de destino--->
		<cfset itemTypeId = FORM.sourceItemTypeId>
		<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
		<cflocation url="#return_path##itemTypeNameP#.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>--->
	<cflocation url="#return_path#area_items.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">

</cfif>

<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
	
	<cfset return_page = "#return_path##itemTypeName#.cfm?#itemTypeName#=#item_id#">
	
<cfelseif isDefined("URL.sourceItemTypeId") AND isNumeric(URL.sourceItemTypeId)>
	
	<cfset sourceItemTypeId = URL.sourceItemTypeId>
	
	<cfswitch expression="#sourceItemTypeId#">
		
		<cfcase value="1">
			<cfset sourceItemTypeName = "message">
		</cfcase>
		
		<cfcase value="2">
			<cfset sourceItemTypeName = "entry">
		</cfcase>
		
		<cfcase value="3">
			<cfset sourceItemTypeName = "link">
		</cfcase>
		
		<cfcase value="4">
			<cfset sourceItemTypeName = "news">
		</cfcase>
		
		<cfcase value="5">
			<cfset sourceItemTypeName = "event">
		</cfcase>
		
		<cfcase value="6">
			<cfset sourceItemTypeName = "task">
		</cfcase>
		
		<cfcase value="7">
			<cfset sourceItemTypeName = "consultation">
		</cfcase>
	
	</cfswitch>
	
	<cfset item_id = URL[sourceItemTypeName]>
	<cfset return_page = "#return_path##sourceItemTypeName#.cfm?#sourceItemTypeName#=#item_id#">

<cfelse>
	<cflocation url="#APPLICATION.htmlPath#/" addtoken="no">
</cfif>

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>

<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

<link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.min.css" rel="stylesheet" />
<script src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js?v=3"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js"></script>

<!--- <link href="#APPLICATION.path#/jquery/jstree/themes/dp/style.css" rel="stylesheet" type="text/css" /> --->
<!--- <script type="text/javascript">
	var applicationId = "#APPLICATION.identifier#";
</script> --->

<script src="#APPLICATION.htmlPath#/scripts/tree.min.js?v=3.1"></script>
</cfoutput>

<script type="text/javascript">
	
	function treeLoaded() { 

		$("#loadingContainer").hide();
		<!---$("#mainContainer").show();--->

		if($("#mainContainer").is(":hidden"))
			$("#mainContainer").show();

	}

	function areaSelected(areaId, areaUrl, withLink)  {

		var checkBoxId = "#area"+areaId;
		if($(checkBoxId).attr('disabled')!='disabled')
			toggleCheckboxChecked(checkBoxId);

	}

	function searchTextInTree(){
		searchInTree(document.getElementById('searchText').value);	
	}
	
	$(window).load( function() {		

		$('.collapse').collapse({
			parent:"#accordion"
		});

		$("#searchText").on("keydown", function(e) { 
			
			if(e.which == 13) { //Enter key

				if(e.preventDefault)
				e.preventDefault();

				searchTextInTree();

			}
			
		});

		showTree(true);

		<!--- Hack para posibilitar la selección de los checkboxs en el árbol al hacer click sobre ellos --->
		$("#areasTreeContainer input:checkbox").click(function(event) {
			var inputId = "#"+this.id;
			setTimeout(function(){
		       $(inputId).prop("checked",!($(inputId).is(":checked"))); 
		    }, 100);

		});
		
	});

</script>

<!---<div class="div_head_subtitle">
<cfoutput>
<span lang="es">#itemTypeNameEs#</span>
</cfoutput>
</div>--->

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#item_id#">
	
	<cfif isDefined("sourceItemTypeId")><!---Si se va a copiar de un mensaje o de otro tipo de elemento que no es el mismo que el de destino--->
		<cfinvokeargument name="itemTypeId" value="#sourceItemTypeId#">
	<cfelse>
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
</cfinvoke>

<!---<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
	<cfif isDefined("sourceItemTypeId")><!---Si se va a copiar de un mensaje o de otro tipo de elemento--->
		<cfinvokeargument name="itemTypeId" value="#sourceItemTypeId#">
	<cfelse>
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
	<cfinvokeargument name="xml" value="#xmlItem#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>--->

<cfset objectItem.id = ""><!---Se borra el id para que no se pueda hacer nada sobre el original--->

<cfset area_id = objectItem.area_id>

<cfif itemTypeId IS 2><!--- Entries --->
	
	<cfif NOT isDefined("objectItem.display_type_id")>
		<cfset queryAddColumn(objectItem, "display_type_id")>
	</cfif>

<cfelseif itemTypeId IS 5 OR itemTypeId IS 6><!--- Events, Tasks --->
	
	<cfif NOT isDefined("objectItem.start_date")>
		<cfset QueryAddColumn(objectItem, "start_date")>
	</cfif>

	<cfif NOT isDefined("objectItem.end_date")>
		<cfset queryAddColumn(objectItem, "end_date")>
	</cfif>

	<cfif NOT isDefined("objectItem.start_time")>
		<cfset queryAddColumn(objectItem, "start_time")>
	</cfif>

	<cfif NOT isDefined("objectItem.end_time")>
		<cfset queryAddColumn(objectItem, "end_time")>
	</cfif>

	<cfif NOT isDefined("objectItem.place")>
		<cfset queryAddColumn(objectItem, "place")>
	</cfif>

	<cfif NOT isDefined("objectItem.recipient_user")>
		<cfset queryAddColumn(objectItem, "recipient_user")>
	</cfif>

	<cfif NOT isDefined("objectItem.recipient_user_full_name")>
		<cfset queryAddColumn(objectItem, "recipient_user_full_name")>
	</cfif>

	<cfif NOT isDefined("objectItem.estimated_value")>
		<cfset queryAddColumn(objectItem, "estimated_value")>
	</cfif>

	<cfif NOT isDefined("objectItem.real_value")>
		<cfset queryAddColumn(objectItem, "real_value")>
	</cfif>

<cfelseif itemTypeId IS 7 OR itemTypeId IS 8><!--- Consultations, Pubmed --->

	<cfif NOT isDefined("objectItem.identifier")>
		<cfset queryAddColumn(objectItem, "identifier")>
	</cfif>

</cfif>

<cfif NOT isDefined("objectItem.link_target")>
	<cfset queryAddColumn(objectItem, "link_target")>
</cfif>

<cfif NOT isDefined("objectItem.iframe_url")>
	<cfset queryAddColumn(objectItem, "iframe_url")>
</cfif>

<cfif NOT isDefined("objectItem.iframe_display_type_id")>
	<cfset queryAddColumn(objectItem, "iframe_display_type_id")>
</cfif>

<cfif NOT isDefined("objectItem.iframe_display_type_id")>
	<cfset queryAddColumn(objectItem, "iframe_display_type_id")>
</cfif>

<cfif NOT isDefined("objectItem.publication_date")>
	<cfset queryAddColumn(objectItem, "publication_date")>
</cfif>

<cfoutput>
<div class="div_file_page_name">#objectItem.title#</div>

<div class="div_head_subtitle"><span lang="es">Copiar #itemTypeNameEs# a áreas</span>
</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/loading_div.cfm">

<script type="text/javascript">
function onSubmitForm()
{
	if(check_custom_form())
	{
		var submitForm = true;
		
		<cfif itemTypeId IS 5>
		if(!checkDates("start_date", "end_date")) {
			submitForm = false;
			alert(window.lang.convert("Fechas incorrectas. Compruebe que la fecha de fin del evento es igual o posterior a la fecha de inicio y tiene el formato adecuado."));
		}
		</cfif>
		
		/*if(submitForm)
			document.getElementById("submitDiv").innerHTML = "Enviando...";*/

		return submitForm;
	}
	else
		return false;
}
</script>

<div id="mainContainer" style="clear:both; margin-left:5px;">		
<cfform name="item_form" method="post" enctype="multipart/form-data" action="#CGI.SCRIPT_NAME#" style="clear:both;" onsubmit="return onSubmitForm();">
	<input type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfif isDefined("sourceItemTypeId")>
	<input type="hidden" name="sourceItemTypeId" value="#sourceItemTypeId#">
	</cfif>
	<input type="hidden" name="area_id" value="#area_id#">
	<input type="submit" class="btn btn-primary" value="Añadir #itemTypeNameEs# a áreas seleccionadas" lang="es" style="margin-bottom:3px;" />
	
	<a href="#return_page#" class="btn btn-default" lang="es" style="float:right;">Cancelar</a>
	
	<div class="panel-group" id="accordion">

		<div class="panel panel-default" style="width:100%;"><!---Tab1--->

			<div class="panel-heading">
				<h4 class="panel-title"><a data-toggle="collapse" data-parent="##accordion" href="##collapseOne" lang="es">Editar contenido</a></h4>
			</div>

			<div id="collapseOne" class="panel-collapse collapse in">
				
				<div class="panel-body">

					<div class="form-horizontal">
						<cfset read_only = false>
						<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">
					</div>

				</div>
				
			</div>

		</div><!---END Tab1--->

		<div class="panel panel-default"><!---Tab2--->

			<div class="panel-heading">
				<h4 class="panel-title"><a data-toggle="collapse" data-parent="##accordion" href="##collapseTwo" lang="es">Áreas a las que copiar</a></h4>
			</div>

			<div id="collapseTwo" class="panel-collapse collapse">
				
				<div class="panel-body">

					<div class="alert alert-info" style="margin-bottom:5px;">
						<span lang="es">Seleccione las áreas a las que desea copiar <cfif itemTypeGender EQ "male">el<cfelse>la</cfif> #itemTypeNameEs#:</span>
					</div>

					<div>

						<div class="btn-group">
							<div class="input-group input-group-sm" style="width:260px;" >
								<input type="text" name="text" id="searchText" value="" class="form-control"/>
								<span class="input-group-btn">
									<button onClick="searchTextInTree()" class="btn btn-default" type="button" title="Buscar área en el árbol" lang="es"><i class="icon-search"></i> <span lang="es">Buscar</span></button>
								</span>
							</div>
						</div>

						<!---<a onClick="expandTree();" class="btn btn-default" title="Expandir todo el árbol" lang="es"><i class="icon-plus"></i> <span lang="es">Expandir</span></a>
						<a onClick="collapseTree();" class="btn btn-default" title="Colapsar todo el árbol" lang="es"><i class="icon-minus"></i> <span lang="es">Colapsar</span></a>--->

					</div>

					<div id="areasTreeContainer" style="clear:both; margin-bottom:2px;">
						<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
							<cfinvokeargument name="with_input_type" value="checkbox">
							<cfif itemTypeWeb IS false>
								<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar mensajes a las áreas WEB--->
							</cfif>
							<cfif itemTypeNoWeb IS false>
								<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar elementos WEB a las áreas no WEB--->
							</cfif>

							<!---
							<cfif itemTypeId IS 1 OR itemTypeId IS 6 OR itemTypeId IS 7><!---No se pueden copiar a web los mensajes, las tareas y las interconsultas--->
								<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar mensajes a las áreas WEB--->
							<cfelseif itemTypeId IS 2 OR itemTypeId IS 3 OR itemTypeId IS 4><!---No se pueden copiar a no web las entradas, enlaces y noticias--->
								<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar elementos WEB a las áreas no WEB--->
							</cfif>--->
						</cfinvoke>
					</div>
					
					<script type="text/javascript">
						addRailoRequiredCheckBox("areas_ids[]",window.lang.convert("Debe seleccionar al menos un área"));
					</script>

				</div>
				
			</div>

		</div><!---END Tab2--->

	</div><!---END accordion--->
	<input name="submit" type="submit" class="btn btn-primary" value="Copiar #itemTypeNameEs# a áreas seleccionadas" lang="es" style="margin-top:3px;"/>
	
	<a href="#return_page#" class="btn btn-default" style="float:right;" lang="es">Cancelar</a>
	
</cfform>

</div><!---END mainContainer--->

<div style="height:5px;"><!-- --></div>

</cfoutput>