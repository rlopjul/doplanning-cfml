<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cfif isDefined("FORM.client_abb") AND len(FORM.client_abb) GT 0>

	<cfset client_dsn = APPLICATION.identifier&"_"&FORM.client_abb>
	<cfset client_abb = FORM.client_abb>
	
	<cfquery datasource="#client_dsn#" name="alterUserTable">
		ALTER TABLE `#client_abb#_users`
		ADD COLUMN `language` VARCHAR(45) NOT NULL AFTER `mobile_phone_ccode`,
		ADD COLUMN `notify_new_message` BOOLEAN NOT NULL DEFAULT 1 AFTER `language`,
		ADD COLUMN `notify_new_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_message`,
		ADD COLUMN `notify_replace_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_file`,
		ADD COLUMN `notify_new_area` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_replace_file`;
	</cfquery>
	
	<!---ALTER TABLE `dp_scaleprot`.`scaleprot_users` ADD COLUMN `notify_replace_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `mobile_phone_ccode`;--->
	<cfoutput>
		Modificaciones en tabla users hechas.
	</cfoutput>
	
	<cfquery datasource="#client_dsn#" name="getPreferences">
		SELECT *
		FROM #client_abb#_user_preferences;
	</cfquery>
	
	<cfloop query="getPreferences">
		
		<cfquery datasource="#client_dsn#" name="copyPreferences">
			UPDATE #client_abb#_users
			SET notify_new_message = #getPreferences.notify_new_message#, 
			notify_new_file = #getPreferences.notify_new_file#,
			language = <cfqueryparam value="#getPreferences.language#" cfsqltype="cf_sql_varchar">,
			notify_replace_file = #getPreferences.notify_replace_file#,
			notify_new_area = #getPreferences.notify_new_area#
			WHERE id = #getPreferences.user_id#;
		</cfquery>
		
	</cfloop>
	<cfoutput>
		Datos de tabla preferences copiados.
	</cfoutput>

</cfif>

<cfform name="client" action="#CGI.SCRIPT_NAME#">

	<cfinput name="client_abb" type="text" value="">
	<cfinput name="submit" type="submit" value="Copiar preferencias"/>

</cfform>

</body>
</html>
