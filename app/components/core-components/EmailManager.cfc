<!--- Copyright Era7 Information Technologies 2007-2014 --->
<cfcomponent output="false">

	<cfset component = "EmailManager">

	<!--- ----------------------- SEND EMAIL -------------------------------- --->
	
	<cffunction name="sendEmail" access="public" returntype="void">
		<cfargument name="from" type="string" required="yes">
		<cfargument name="from_name" type="string" required="false">
		<cfargument name="to" type="string" required="yes">
		<cfargument name="bcc" type="string" required="no">
		<cfargument name="subject" type="string" required="yes">
		<cfargument name="content" type="string" required="yes">
		<cfargument name="foot_content" type="string" required="no">
		<cfargument name="styles" type="boolean" required="no">


		<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#arguments.from#">
			<cfinvokeargument name="from_name" value="#arguments.from_name#">
			<cfinvokeargument name="to" value="#arguments.to#">
			<cfinvokeargument name="bcc" value="#arguments.bcc#">
			<cfinvokeargument name="subject" value="#arguments.subject#">
			<cfinvokeargument name="content" value="#arguments.content#">
			<cfinvokeargument name="foot_content" value="#arguments.foot_content#">
			<cfinvokeargument name="styles" value="#arguments.styles#">
		</cfinvoke>	

	</cffunction>

</cfcomponent>