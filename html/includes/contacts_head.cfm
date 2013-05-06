<div class="div_head_title">
<cfoutput>
<div class="icon_title">
<a href="contacts.cfm"><img src="assets/icons/contacts.png" alt="Contactos"/></a>
</div>
<div class="head_title" style="padding-top:4px;"><a href="contacts.cfm">Contactos</a></div>
</cfoutput>
</div>
<cfif APPLICATION.identifier EQ "dp">
<div class="alert alert-block" style="clear:both;">
No puede crear nuevos contactos.<br />
Los contactos no estarán disponibles en la próxima versión de DoPlanning.
</div>
</cfif>