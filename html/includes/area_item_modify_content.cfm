<!---Variables requeridas:
itemTypeId
return_path: define la ruta donde se encuentra esta página, para que al enviar el mensaje se vuelva a ella--->
<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
</cfoutput>

<cfset page_type = 2>
<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_form.cfm">