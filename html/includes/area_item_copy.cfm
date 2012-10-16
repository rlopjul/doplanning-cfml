<!---Required vars: 
	itemTypeId
	return_path

--->
<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

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
		<cfif isDefined("FORM.display_type")>
			<cfinvokeargument name="display_type" value="#FORM.display_type#">
		</cfif>
		<cfif isDefined("FORM.iframe_url")>
			<cfinvokeargument name="iframe_url" value="#FORM.iframe_url#">
		</cfif>
		<cfif isDefined("FORM.iframe_display_type")>
			<cfinvokeargument name="iframe_display_type" value="#FORM.iframe_display_type#">
		</cfif>   
				
		<!---<cfinvokeargument name="return_path" type="string" required="yes">--->
	</cfinvoke>
	<cfset msg = resultCopyItem.message>
	<cfset res = resultCopyItem.result>
	
	<cfif NOT isDefined("FORM.sourceItemTypeId")>
		<cflocation url="#return_path##itemTypeNameP#.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	<cfelse><!---Devuelve a la lista de mensajes porque se ha copiado desde un elemento distinto del elemento de destino--->
		
		<cfset itemTypeId = FORM.sourceItemTypeId>
		<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
	
		<cflocation url="#return_path##itemTypeNameP#.cfm?area=#FORM.area_id#&res=#res#&msg=#URLEncodedFormat(msg)#" addtoken="no">
	</cfif>


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
	
	</cfswitch>
	
	<cfset item_id = URL[sourceItemTypeName]>
	<cfset return_page = "#return_path##sourceItemTypeName#.cfm?#sourceItemTypeName#=#item_id#">

<cfelse>
	<cflocation url="#APPLICATION.htmlPath#/" addtoken="no">
</cfif>

<cfoutput>
<link href="#APPLICATION.jqueryUICSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.jqueryJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.jqueryUIJSPath#"></script>

<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
<script type="text/javascript" src="#APPLICATION.path#/jquery/jquery-ui/jquery.ui.datepicker-es.js"></script>
</cfif>

<script type="text/javascript" src="#APPLICATION.path#/jquery/jstree/jquery.jstree.js"></script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js"></script>

<script type="text/javascript">
	var applicationId = "#APPLICATION.identifier#";
	var applicationPath = "#APPLICATION.path#";
</script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/Scripts/Tree.js"></script>
</cfoutput>

<script type="text/javascript">
	
	function areaSelected(areaId)  {
	
		var checkBoxId = "#area"+areaId;
		if($(checkBoxId).attr('disabled')!='disabled')
			toggleCheckboxChecked(checkBoxId);
	}

	
	function treeLoaded (event, data) { //JStree loaded

		$("#areasTreeContainer").bind("select_node.jstree", function (e, data) {
			var $obj = data.rslt.obj;
			areaSelected($obj.attr("id"));
		
		});
		
		$("#loadingContainer").hide();
		$("#mainContainer").show();
	
	}
	
	$(window).load( function() {
		$("input:submit").button();
		
		$("#accordion").accordion({ active: 1, autoHeight: false });
				
		showTree(true,"");
		
	});

</script>

<div class="div_head_subtitle">
<cfoutput>
#itemTypeNameEs#
</cfoutput>
</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="selectItem" returnvariable="xmlResponse">
	<cfinvokeargument name="item_id" value="#item_id#">
	
	<cfif isDefined("sourceItemTypeId")><!---Si se va a copiar de un mensaje o de otro tipo de elemento que no es el mismo que el de destino--->
		<cfinvokeargument name="itemTypeId" value="#sourceItemTypeId#">
	<cfelse>
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
</cfinvoke>

<cfxml variable="xmlItem">
	<cfoutput>
	#xmlResponse.response.result.xmlChildren[1]#
	</cfoutput>
</cfxml>

<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
	<cfif isDefined("sourceItemTypeId")><!---Si se va a copiar de un mensaje o de otro tipo de elemento--->
		<cfinvokeargument name="itemTypeId" value="#sourceItemTypeId#">
	<cfelse>
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
	<cfinvokeargument name="xml" value="#xmlItem#">
	<cfinvokeargument name="return_type" value="object">
</cfinvoke>

<cfset objectItem.id = ""><!---Se borra el id para que no se pueda hacer nada sobre el original--->

<cfset area_id = objectItem.area_id>


<cfoutput>
<div class="div_file_page_name">#objectItem.title#</div>

<div class="div_head_subtitle">
Copiar #itemTypeNameEs# a áreas
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
			alert("Fechas incorrectas. Compruebe que la fecha de fin del evento es igual o posterior a la fecha de inicio y tiene el formato adecuado.");
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

<div id="mainContainer" style="clear:both;">		
<cfform name="item_form" method="post" enctype="multipart/form-data" action="#CGI.SCRIPT_NAME#" style="clear:both;" onsubmit="return onSubmitForm();">
	<input type="hidden" name="itemTypeId" value="#itemTypeId#">
	<!---<input type="hidden" name="item_id" value="#item_id#">--->
	<cfif isDefined("sourceItemTypeId")>
	<input type="hidden" name="sourceItemTypeId" value="#sourceItemTypeId#">
	</cfif>
	<input type="hidden" name="area_id" value="#area_id#">
	<input type="submit" value="Añadir #itemTypeNameEs# a áreas seleccionadas" style="margin-bottom:3px;" />
	<div id="accordion">
		<h3><a href="##">Editar contenido</a></h3>
		<div><!---Tab1--->
			
			<cfset read_only = false>
			<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_inputs.cfm">
			
			
		</div><!---END Tab1--->
		<h3><a href="##">Áreas a las que copiar</a></h3>
		<div><!---Tab2--->
			
			<div class="div_message_page_title">Seleccione las áreas a las que desea copiar el #itemTypeNameEs#:</div>
	
			<div id="areasTreeContainer" style="clear:both; margin-top:2px; margin-bottom:2px;">
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaTree" method="outputMainTree">
				<cfinvokeargument name="with_input_type" value="checkbox">
				<cfif itemTypeId IS 1 OR itemTypeId IS 6><!---No se pueden copiar a web los mensajes y las tareas--->
					<cfinvokeargument name="disable_input_web" value="true"><!---Esto es para que no se puedan copiar mensajes a las áreas WEB--->
				<cfelseif itemTypeId IS 2 OR itemTypeId IS 3 OR itemTypeId IS 4><!---No se pueden copiar a no web las entradas, enlaces y noticias--->
					<cfinvokeargument name="disable_input_area" value="true"><!---Esto es para que no se puedan copiar elementos WEB a las áreas no WEB--->
				</cfif>
			</cfinvoke>
			</div>
			
			<script type="text/javascript">
				addRailoRequiredCheckBox("areas_ids[]","Debe seleccionar al menos un área");			
			</script>
			
		</div><!---END Tab2--->
	</div><!---END accordion--->
	<input name="submit" type="submit" value="Añadir #itemTypeNameEs# a áreas seleccionadas" style="margin-top:3px;"/>
</cfform>

</div><!---END mainContainer--->

<div style="height:5px;"><!-- --></div>

</cfoutput>