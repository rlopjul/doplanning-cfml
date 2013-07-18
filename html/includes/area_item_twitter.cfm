<!---Variables requeridas:
itemTypeId
return_path: define la ruta donde se encuentra esta página, para que al enviar el mensaje se vuelva a ella--->
<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="objectUser">
	<cfinvokeargument name="user_id" value="#SESSION.user_id#">
	<cfinvokeargument name="format_content" value="all">
</cfinvoke>

	
<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="selectItem" returnvariable="xmlResponse">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>
	
	<cfxml variable="xmlItem">
		<cfoutput>
		#xmlResponse.response.result.xmlChildren[1]#
		</cfoutput>
	</cfxml>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="objectItem" returnvariable="objectItem">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		<cfinvokeargument name="xml" value="#xmlItem#">
		<cfinvokeargument name="return_type" value="object">
	</cfinvoke>
	
	<!---<cfset area_id = xmlItem.xmlChildren[1].xmlAttributes.area_id>
	<cfset title_default = "Re: "&xmlItem.xmlChildren[1].title.xmlText>--->
	
	<cfset area_id = objectItem.area_id>
	
	<cfset return_page = "#itemTypeName#.cfm?#itemTypeName#=#item_id#">
	
	<cfif len(objectItem.title) GT 119><!---Se deben reservar 20 caracteres + 1 espacio para la URL (la URL abreviada ocupa 20 caracteres)--->
		<cfset tweet_content = left(objectItem.title,116)&"...">
	<cfelse>
		<cfset tweet_content = objectItem.title>
	</cfif>
	
	<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getWebItemUrl" returnvariable="tweet_url">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>
	
<cfelse>
	<cflocation url="#APPLICATION.htmlPath#/" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">
<cfoutput>
<div class="div_head_subtitle">
Publicar #itemTypeNameEs# en Twitter
</div>
<div class="contenedor_fondo_blanco">
<div class="div_send_message">

<p>Utilice esta opción para publicar <cfif itemTypeGender IS "male">este<cfelse>esta</cfif> #itemTypeNameEs# en Twitter. Puede editar el texto del tweet publicado, al que se le agregará de forma automática la dirección URL donde se encuentra el contenido que desea publicar.<br/><br/>
</p>
</cfoutput>

<script type="text/javascript">
function onSubmitForm()
{
	if(check_custom_form())
	{
		//ocultarBoton('submitButton');
		//$("#submitDiv").html("<span>Enviando...</span>");
		document.getElementById("submitDiv").innerHTML = "Enviando...";

		return true;
	}
	else
		return false;
}
</script>

<cfoutput>
<cfform action="#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=postItemToTwitter" method="post" enctype="multipart/form-data" name="item_form" onsubmit="return onSubmitForm();">
	
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('item_form');
	</script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

	<cfinput type="hidden" name="itemTypeId" value="#itemTypeId#">
	<cfinput type="hidden" name="item_id" value="#item_id#">
	<cfinput type="hidden" name="area_id" value="#area_id#">
	<cfinput type="hidden" name="return_path" value="#return_path#">
	<span class="texto_normal">Tweet: </span><small>(máximo 120 caracteres)</small><br />
	<textarea name="content" class="input-xxlarge" style="height:50px;">#tweet_content#</textarea><br/>
	<script type="text/javascript">		
		addRailoRequiredMaxLengthTextInput('content', 'Debe definir un contenido para el Tweet de como máximo 120 caracters', 120);
	</script>
	
	<div><span class="texto_normal">URL del contenido publicado: </span><small>(se agregará al final del texto del tweet)</small><br/><cfinput type="text" name="url" value="#tweet_url#" required="yes" readonly="yes" class="input-xxlarge"></div>

    <div id="submitDiv"><cfinput type="submit" class="btn btn-primary" name="submit" value="Enviar"></div>
</cfform>
</cfoutput>


</div>

</div>