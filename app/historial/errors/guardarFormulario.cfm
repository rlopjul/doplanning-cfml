<cfif isDefined("FORM.description")>

<cfelse>

</cfif>
<cfquery datasource="#client_dsn#" name="guardarerror">
				INSERT into test_errors(description,scenary,remarks,priority,tester,solver,associated_file,state)
				VALUES ('#FORM.description#','#FORM.scenary#','#FORM.remarks#','#FORM.priority#','#FORM.tester#','#FORM.solver#','#FORM.associated_file#','#FORM.state#');
</cfquery>

<cfset mensaje="El registro anterior se ha realizado con exito">
<cflocation url="form_errors.cfm?correcto=#mensaje#">