<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 03-04-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 11-06-2013

	05-07-2012 alucena: modificado newAreaItem para que se notifique según las preferencias de alertas de los nuevos elementos (enlaces, entradas, noticias y eventos)
	06-09-2012 alucena: quitado DateFormat de la fecha de inicio de los eventos newAreaItem, ya que aparecía el mes cambiado por el día, porque la fecha que viene no es un objeto de Coldfusion, sino un String
	26-09-2012 alucena: añadida comprobación de tamaño de lista de destinatarios al enviar por email en newAreaItem
	17-01-2013 alucena: cambiada la url de los elementos, quitado /html/
	22-04-2013 alucena: cambiado client_id por client_abb en las URLs con abb=
	07-05-2013 alucena: cambios para habilitar varios idiomas
	11-06-2013 alucena: cambiada comprobación de APPLICATION.identifier por APPLICATION.twoUrlsToAccess para mostrar o no direcciones externas e internas

--->
<cfcomponent output="false">

	<cfset component = "AlertManager">

	<cfinclude template="includes/loadLangText.cfm">

	<!--- -------------------------------------- newAreaItem ----------------------------------- --->


	<!--- -------------------------------------- changeItemUser ------------------------------------ --->

	<cffunction name="changeItemUser" access="public" returntype="void">
		<cfargument name="objectItem" type="query" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="old_user_id" type="numeric" required="true">
		<cfargument name="new_user_id" type="numeric" required="true">

		<cfset var method = "changeItemUser">

		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#objectItem.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif selectAreaQuery.recordCount GT 0>

			<cfset area_name = selectAreaQuery.name>

		<cfelse><!---The area does not exist--->

			<cfset error_code = 301>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->


		<cfinvoke component="UserManager" method="getUser" returnvariable="oldUser">
			<cfinvokeargument name="get_user_id" value="#arguments.old_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfinvoke component="UserManager" method="getUser" returnvariable="newUser">
			<cfinvokeargument name="get_user_id" value="#arguments.new_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset newUserFullName = newUser.user_full_name>

		<!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

		<!---OLD USER--->
		<cfif len(oldUser.email) GT 0 AND oldUser.enabled IS true AND ( clientQuery.force_notifications IS true OR oldUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfif itemTypeGender EQ "male">
				<cfset actionContent = #langText[oldUser.language].change_owner_item.owner_changed_male#>
			<cfelse>
				<cfset actionContent = #langText[oldUser.language].change_owner_item.owner_changed_female#>
			</cfif>

			<cfset oldUsersubject = "[#root_area.name#][#langText[oldUser.language].item[itemTypeId].name# #actionContent#] "&objectItem.title>

			<cfinvoke component="AlertManager" method="getChangeItemUserAlertContents" returnvariable="oldUserContent">
				<cfinvokeargument name="language" value="#oldUser.language#">
				<cfinvokeargument name="objectItem" value="#arguments.objectItem#"/>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif oldUser.internal_user IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				</cfinvoke>

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentInternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_item.your_item_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[oldUser.language].common.area_path#: #area_path#.<br/><br/>

		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentExternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_item.your_item_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong> #langText[oldUser.language].common.of_the_organization# #root_area.name#.<br/><br/>

		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#oldUser.email#">
				<cfinvokeargument name="subject" value="#oldUsersubject#">
				<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#oldUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#oldUserContentExternal#">
				</cfif>
				<cfinvokeargument name="head_content" value="#oldUserContent.headContent#">
				<cfinvokeargument name="foot_content" value="#oldUserContent.footContent#">
			</cfinvoke>

		</cfif><!--- END user notifications enabled --->


		<!---NEW USER--->

		<cfif len(newUser.email) GT 0 AND newUser.enabled IS true AND ( clientQuery.force_notifications IS true OR newUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfif itemTypeGender EQ "male">
				<cfset actionContent = #langText[newUser.language].change_owner_item.owner_changed_male#>
			<cfelse>
				<cfset actionContent = #langText[newUser.language].change_owner_item.owner_changed_female#>
			</cfif>
			<cfset newUserSubject = "[#root_area.name#][#langText[newUser.language].item[itemTypeId].name# #actionContent#] "&objectItem.title>

			<cfinvoke component="AlertManager" method="getChangeItemUserAlertContents" returnvariable="newUserContent">
				<cfinvokeargument name="language" value="#newUser.language#">
				<cfinvokeargument name="objectItem" value="#arguments.objectItem#"/>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="area_id" value="#objectItem.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif newUser.internal_user IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#objectItem.area_id#">
				</cfinvoke>

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentInternal">
				<cfoutput>
		#langText[newUser.language].change_owner_item.you_have_new_item#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[newUser.language].common.area_path#: #area_path#.<br/><br/>

		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentExternal">
				<cfoutput>
		#langText[newUser.language].change_owner_item.you_have_new_item#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong> #langText[newUser.language].common.of_the_organization# #root_area.name#.<br/><br/>

		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#newUser.email#">
				<cfinvokeargument name="subject" value="#newUserSubject#">
				<cfif newUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#newUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#newUserContentExternal#">
				</cfif>
				<cfinvokeargument name="head_content" value="#newUserContent.headContent#">
				<cfinvokeargument name="foot_content" value="#newUserContent.footContent#">
			</cfinvoke>

		</cfif><!--- END user notifications enabled --->


	</cffunction>



	<!--- --------------------------- getChangeItemUserAlertContents --------------------------- --->

	<cffunction name="getChangeItemUserAlertContents" access="private" returntype="struct">
		<cfargument name="language" type="string" required="true">
		<cfargument name="objectItem" type="any" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_user_full_name" type="string" required="true">

		<cfset var method = "getChangeItemUserAlertContents">

		<cfset var accessContent = "">
		<cfset var alertContent = "">
		<cfset var footContent = "">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="accessContent">
			<cfinvokeargument name="item_id" value="#objectItem.id#"/>
			<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="language" value="#arguments.language#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<cfsavecontent variable="alertContent">
			<cfoutput>
			<cfif itemTypeId IS 1>#langText[arguments.language].new_item.subject#<cfelse>#langText[arguments.language].new_item.title#</cfif>: <strong style="font-size:14px;">#objectItem.title#</strong><br/>
			#langText[arguments.language].change_owner_item.old_user#: <strong>#objectItem.user_full_name#</strong><br />
			#langText[arguments.language].change_owner_item.new_user#: <strong>#arguments.new_user_full_name#</strong><br />

			#langText[arguments.language].new_item.creation_date#: #objectItem.creation_date#<br/>
			<cfif itemTypeId IS NOT 1 AND len(objectItem.last_update_date) GT 0>
			#langText[arguments.language].new_item.last_update_date#: #objectItem.last_update_date#<br/>
			</cfif>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
			</cfoutput>
		</cfsavecontent>

		<!--- getHeadContent --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="headContent">
			<cfinvokeargument name="language" value="#arguments.language#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
		</cfinvoke>

		<!--- getItemFootContent --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemFootContent" returnvariable="footContent">
			<cfinvokeargument name="language" value="#arguments.language#">
		</cfinvoke>

		<cfreturn {alertContent=#alertContent#, footContent=#footContent#, headContent=#headContent#}>

	</cffunction>


	<!--- -------------------------------------- replaceFile ------------------------------------ --->

	<cffunction name="replaceFile" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">

		<cfset var method = "replaceFile">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfquery datasource="#client_dsn#" name="getFileAreas">
			SELECT *
			FROM #client_abb#_areas_files
			WHERE file_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif getFileAreas.RecordCount GT 0>
			<cfloop query="getFileAreas">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
					<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
					<cfinvokeargument name="area_id" value="#getFileAreas.area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="action" value="replace">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfloop>
		</cfif>


	</cffunction>



	<!--- -------------------------------------- changeFileUser ------------------------------------ --->

	<cffunction name="changeFileUser" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="old_user_id" type="numeric" required="true">
		<cfargument name="new_user_id" type="numeric" required="true">

		<cfset var method = "changeFileUser">

		<cfset var area_name = "">
		<cfset var area_path = "">
        <cfset var root_area = structNew()>

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif selectAreaQuery.recordCount GT 0>

			<cfset area_name = selectAreaQuery.name>

		<cfelse><!---The area does not exist--->

			<cfset error_code = 301>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->


		<cfinvoke component="UserManager" method="getUser" returnvariable="oldUser">
			<cfinvokeargument name="get_user_id" value="#arguments.old_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfinvoke component="UserManager" method="getUser" returnvariable="newUser">
			<cfinvokeargument name="get_user_id" value="#arguments.new_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfset newUserFullName = newUser.user_full_name>


		<!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

		<!---OLD USER--->

		<cfif len(oldUser.email) GT 0 AND oldUser.enabled IS true AND ( clientQuery.force_notifications IS true OR oldUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfset oldUsersubject = "[#root_area.name#][#langText[oldUser.language].change_owner_file.file_owner_changed#] "&objectFile.name>

			<cfinvoke component="AlertManager" method="getChangeFileUserAlertContents" returnvariable="oldUserContent">
				<cfinvokeargument name="language" value="#oldUser.language#">
				<cfinvokeargument name="objectFile" value="#arguments.objectFile#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif oldUser.internal_user IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentInternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_file.your_file_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[oldUser.language].common.area_path#: #area_path#.<br/><br/>

		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="oldUserContentExternal">
				<cfoutput>
		#langText[oldUser.language].change_owner_file.your_file_was_changed#<br/><br/>

		#langText[oldUser.language].common.area#: <strong>#area_name#</strong> #langText[oldUser.language].common.of_the_organization# #root_area.name#.<br/><br/>

		#oldUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#oldUser.email#">
				<cfinvokeargument name="subject" value="#oldUsersubject#">
				<cfif oldUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#oldUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#oldUserContentExternal#">
				</cfif>
				<cfinvokeargument name="head_content" value="#oldUserContent.headContent#">
				<cfinvokeargument name="foot_content" value="#oldUserContent.footContent#">
			</cfinvoke>

		</cfif><!--- END user notifications enabled --->


		<!---NEW USER--->

		<cfif len(newUser.email) GT 0 AND newUser.enabled IS true AND ( clientQuery.force_notifications IS true OR newUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfset newUserSubject = "[#root_area.name#][#langText[newUser.language].change_owner_file.file_owner_changed#] "&objectFile.name>

			<cfinvoke component="AlertManager" method="getChangeFileUserAlertContents" returnvariable="newUserContent">
				<cfinvokeargument name="language" value="#newUser.language#">
				<cfinvokeargument name="objectFile" value="#arguments.objectFile#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="new_user_full_name" value="#newUserFullName#"/>
			</cfinvoke>

			<cfif newUser.internal_user IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentInternal">
				<cfoutput>
		#langText[newUser.language].change_owner_file.you_have_new_file#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[newUser.language].common.area_path#: #area_path#.<br/><br/>

		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="newUserContentExternal">
				<cfoutput>
		#langText[newUser.language].change_owner_file.you_have_new_file#<br/><br/>

		#langText[newUser.language].common.area#: <strong>#area_name#</strong> #langText[newUser.language].common.of_the_organization# #root_area.name#.<br/><br/>

		#newUserContent.alertContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#newUser.email#">
				<cfinvokeargument name="subject" value="#newUserSubject#">
				<cfif newUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#newUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#newUserContentExternal#">
				</cfif>
				<cfinvokeargument name="head_content" value="#newUserContent.headContent#">
				<cfinvokeargument name="foot_content" value="#newUserContent.footContent#">
			</cfinvoke>

		</cfif><!--- END user notifications enabled --->


	</cffunction>


	<!--- --------------------------- getChangeFileUserAlertContents --------------------------- --->

	<cffunction name="getChangeFileUserAlertContents" access="private" returntype="struct">
		<cfargument name="language" type="string" required="true">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_user_full_name" type="string" required="true">

		<cfset var method = "getChangeFileUserFootContent">

		<cfset var accessContent = "">
		<cfset var alertContent = "">
		<cfset var footContent = "">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAccessContent" returnvariable="accessContent">
			<cfinvokeargument name="file_id" value="#objectFile.id#"/>
			<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
			<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			<cfinvokeargument name="language" value="#arguments.language#">

			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
		</cfinvoke>

		<cfsavecontent variable="alertContent">
			<cfoutput>
			#langText[language].new_file.file_name#: <strong>#objectFile.name#</strong><br />
			#langText[language].change_owner_item.old_user#: <strong>#objectFile.user_full_name#</strong><br />
			#langText[language].change_owner_item.new_user#: <strong>#arguments.new_user_full_name#</strong><br />
			#langText[language].new_file.upload_date#: #objectFile.uploading_date#<br/>
			<cfif len(objectFile.replacement_date) GT 0>
				#langText[language].new_file.replacement_date#: #objectFile.replacement_date#<br/>
			</cfif>
			#langText[language].new_file.description#:<br/><br/>
			<div style="padding-left:15px;">#objectFile.description#</div>
			<br/>
			<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
			</cfoutput>
		</cfsavecontent>

		<!--- getHeadContent --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="headContent">
			<cfinvokeargument name="language" value="#arguments.language#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
		</cfinvoke>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileFootContent" returnvariable="footContent">
			<cfinvokeargument name="language" value="#arguments.language#">
		</cfinvoke>

		<cfreturn {alertContent=#alertContent#, footContent=#footContent#, headContent=#headContent#}>

	</cffunction>



	<!--- -------------------------------------- requestFileApproval ------------------------------------ --->

	<cffunction name="requestFileApproval" access="public" returntype="void">
		<cfargument name="objectFile" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!--- revision/approval --->

		<cfset var method = "requestFileApproval">

		<cfset var area_name = "">
		<cfset var area_path = "">
    <cfset var root_area = structNew()>
    <cfset var action_user_id = "">
    <cfset var actionSubject = "">
    <cfset var actionText = "">
    <cfset var fileAlertContent = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<!---Get area name--->
		<cfquery name="selectAreaQuery" datasource="#client_dsn#">
			SELECT id, name
			FROM #client_abb#_areas
			WHERE id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif selectAreaQuery.recordCount GT 0>

			<cfset area_name = selectAreaQuery.name>

		<cfelse><!---The area does not exist--->

			<cfset error_code = 301>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
		</cfinvoke>
		<!---En el asunto se pone el nombre del área raiz--->

		<cfif arguments.action IS "revision">
			<cfset action_user_id = objectFile.reviser_user>
		<cfelse>
			<cfset action_user_id = objectFile.approver_user>
		</cfif>

		<!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

		<!--- getUser --->
		<cfinvoke component="UserManager" method="getUser" returnvariable="actionUser">
			<cfinvokeargument name="get_user_id" value="#action_user_id#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>

		<cfif len(actionUser.email) GT 0 AND actionUser.enabled IS true AND ( clientQuery.force_notifications IS true OR actionUser.no_notifications IS false )><!--- user notifications enabled --->

			<cfset actionUserFullName = actionUser.user_full_name>

			<cfif arguments.action IS "revision">
				<cfset actionSubject = langText[actionUser.language].file_revision.file_revision_request>
				<cfset actionText = langText[actionUser.language].file_revision.you_have_to_revise>
			<cfelse>
				<cfset actionSubject = langText[actionUser.language].file_approval.file_approval_request>
				<cfset actionText = langText[actionUser.language].file_approval.you_have_to_approve>
			</cfif>

			<!---ACTION USER--->
			<cfset actionUserSubject = "[#root_area.name#][#actionSubject#] "&objectFile.name>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAccessContent" returnvariable="accessContent">
				<cfinvokeargument name="file_id" value="#objectFile.id#"/>
				<cfinvokeargument name="fileTypeId" value="#objectFile.file_type_id#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="language" value="#actionUser.language#">

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileFootContent" returnvariable="footContent">
				<cfinvokeargument name="language" value="#actionUser.language#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getFileAlertContent" returnvariable="fileAlertContent">
				<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
				<cfinvokeargument name="language" value="#actionUser.language#">
			</cfinvoke>

			<cfsavecontent variable="commonContent">
				<cfoutput>
				#fileAlertContent#
				<br/>
				<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#accessContent#</div>
				</cfoutput>
			</cfsavecontent>

			<cfif actionUser.internal_user IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="actionUserContentInternal">
				<cfoutput>
		#actionText#<br/><br/>

		#langText[actionUser.language].common.area#: <strong>#area_name#</strong>.<br/>
		#langText[actionUser.language].common.area_path#: #area_path#.<br/><br/>

		#commonContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			<cfelse><!---EXTERNAL USER--->

				<cfprocessingdirective suppresswhitespace="true">
				<cfsavecontent variable="actionUserContentExternal">
				<cfoutput>
		#actionText#<br/><br/>

		#langText[actionUser.language].common.area#: <strong>#area_name#</strong> #langText[actionUser.language].common.of_the_organization# #root_area.name#.<br/><br/>

		#commonContent#
				</cfoutput>
				</cfsavecontent>
				</cfprocessingdirective>

			</cfif>

			<!--- getHeadContent --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getHeadContent" returnvariable="headContent">
				<cfinvokeargument name="language" value="#actionUser.language#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
			</cfinvoke>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#actionUser.email#">
				<cfinvokeargument name="subject" value="#actionUserSubject#">
				<cfif actionUser.internal_user IS true><!---INTERNAL USER--->
					<cfinvokeargument name="content" value="#actionUserContentInternal#">
				<cfelse>
					<cfinvokeargument name="content" value="#actionUserContentExternal#">
				</cfif>
				<cfinvokeargument name="head_content" value="#headContent#">
				<cfinvokeargument name="foot_content" value="#footContent#">
			</cfinvoke>


		</cfif><!--- END user notifications enabled --->


	</cffunction>



	<!--- -------------------------------------- addUserToTable ------------------------------------ --->

	<cffunction name="addUserToTable" access="package" returntype="void">
		<cfargument name="tableQuery" type="query" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="userQuery" type="query" required="true">

		<cfset var method = "addUserToTable">

        <cfset var area_id = "">
        <cfset var root_area = structNew()>
        <cfset var curLang = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

		<cfset area_id = tableQuery.area_id>
		<cfset curLang = userQuery.language>

        <!--- getClient --->
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
			<cfinvokeargument name="client_abb" value="#client_abb#">
		</cfinvoke>

		<cfif len(userQuery.email) GT 0 AND userQuery.enabled IS true AND ( clientQuery.force_notifications IS true OR userQuery.no_notifications IS false )><!--- user notifications enabled --->


	        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
	        </cfinvoke>
	        <!---En el asunto se pone el nombre del área raiz--->

			<cfset subject = "[#root_area.name#] #langText[curLang].add_user_to_table.has_been_added_as_editor_of# #langText[curLang].item[itemTypeId].name#: "&tableQuery.title>

			<cfif userQuery.whole_tree_visible IS true><!---INTERNAL USER--->

				<cfinvoke component="AreaManager" method="getAreaPath" returnvariable="area_path">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="getItemAccessContent" returnvariable="access_content">
				<cfinvokeargument name="language" value="#curLang#">
				<cfinvokeargument name="item_id" value="#tableQuery.table_id#"/>
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="area_id" value="#area_id#"/>

				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfsavecontent variable="html_text">
			<cfoutput>
			<br />
	#langText[curLang].add_user_to_table.has_been_added_as_editor_of# #langText[curLang].item[itemTypeId].name#: <strong>#tableQuery.title#</strong><br />

	<cfif userQuery.whole_tree_visible IS true>
	#langText[curLang].common.area_path#: #area_path#.<br />
	</cfif>
	<br/>
	<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#access_content#</div>
			</cfoutput>
			</cfsavecontent>

			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#userQuery.email#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="content" value="#html_text#">
				<cfinvokeargument name="foot_content" value="#foot_content#">
			</cfinvoke>


		</cfif><!--- user notifications enabled --->

	</cffunction>



	<!--- -------------------------------------- newUser ------------------------------------ --->

	<cffunction name="newUser" access="public" returntype="void">
		<cfargument name="objectUser" type="query" required="yes">
		<cfargument name="password_temp" type="string" required="no">

		<cfset var method = "newUser">

        <cfset var root_area = structNew()>
		<cfset var login_ldap = "">
		<cfset var curLang = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfif len(objectUser.email) GT 0>

			<cfif len(objectUser.language) IS 0>
				<cfset curLang = APPLICATION.defaultLanguage>
			<cfelse>
				<cfset curLang = objectUser.language>
			</cfif>

	        <cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
	        </cfinvoke>
	        <!---En el asunto se pone el nombre del área raiz--->
	        <cfset subject = "[#root_area.name#] #langText[curLang].new_user.you_has_been_registered_in_organization#.">

			<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
				<cfinvokeargument name="client_id" value="#SESSION.client_id#">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				<cfinvokeargument name="curLang" value="#curLang#"/>
			</cfinvoke>

			<!---Esto tiene que completarse con la generación de un código de ticket--->
			<!---IMPORTANTE: Para confirmar su alta debe acceder a la siguiente dirección: #APPLICATION.mainUrl#/#SESSION.client_id#--->
			<cfsavecontent variable="html_text">
			<cfoutput>
	#langText[curLang].new_user.you_has_been_registered_in_application# #APPLICATION.title# #langText[curLang].common.of_the_organization# <b>#root_area.name#</b>.<br /><br />

	<cfif APPLICATION.identifier NEQ "vpnet"><!---Default User--->
	#langText[curLang].new_user.if_you_use_the_application#: <a href="#APPLICATION.termsOfUseUrl#">#APPLICATION.termsOfUseUrl#</a>.<br/><br/>

	#langText[curLang].common.your_access_email#: <b>#objectUser.email#</b><br />
	#langText[curLang].new_user.password#: <b>#arguments.password_temp#</b><br/>
	#langText[curLang].common.you_must_change_password#.<br /><br/>

	</cfif>
	<cfif APPLICATION.moduleLdapUsers IS true><!---LDAP User--->

		<cfif APPLICATION.identifier NEQ "vpnet">

			#langText[curLang].new_user.also_you_can_use#: <br/>

			<cfif isDefined("arguments.objectUser.login_ldap") AND len(arguments.objectUser.login_ldap) GT 0>
				#APPLICATION.ldapName#: <b>#arguments.objectUser.login_ldap#</b><br/>
			</cfif>
			<cfif isDefined("arguments.objectUser.login_diraya") AND len(arguments.objectUser.login_diraya) GT 0>
				Diraya: <b>#arguments.objectUser.login_diraya#</b><br/>
			</cfif>

		<cfelse><!---vpnet--->

			<cfif isDefined("arguments.objectUser.login_ldap") AND len(arguments.objectUser.login_ldap) GT 0>
				<cfset ldap_name = APPLICATION.ldapName>
				<cfset login_ldap = arguments.objectUser.login_ldap>
			<cfelseif isDefined("arguments.objectUser.login_diraya")>
				<cfset ldap_name = "Diraya">
				<cfset login_ldap = arguments.objectUser.login_diraya>
			</cfif>
			#langText[curLang].new_user.user_access_identify_to# #ldap_name#.<br/>
			#langText[curLang].common.user#: <b>#login_ldap#</b><br/>

		</cfif>

	</cfif><br/>

	<cfif APPLICATION.identifier NEQ "vpnet">
		#langText[curLang].new_user.to_view_tutorials_access#: <a href="#APPLICATION.helpUrl#">#APPLICATION.helpUrl#</a><br/>
	</cfif>
	<br/>

	<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;"><b>#access_content#</b></div>

			</cfoutput>
			</cfsavecontent>

			<!---<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>--->

			<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title#.</p>'>

			<cfinvoke component="EmailManager" method="sendEmail">
				<cfinvokeargument name="from" value="#SESSION.client_email_from#">
				<cfinvokeargument name="to" value="#objectUser.email#">
				<cfinvokeargument name="subject" value="#subject#">
				<cfinvokeargument name="content" value="#html_text#">
				<cfinvokeargument name="foot_content" value="#foot_content#">
			</cfinvoke>

		</cfif><!--- END len(objectUser.email) GT 0 --->

	</cffunction>




	<!--- -------------------------------------- generateNewPassword ------------------------------------ --->

	<cffunction name="generateNewPassword" access="public" returntype="void">
		<cfargument name="user_full_name" type="string" required="true">
		<cfargument name="user_email" type="string" required="true">
		<cfargument name="user_password" type="string" required="true">
		<cfargument name="user_language" type="string" required="true"/>
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "generateNewPassword">

        <cfset var rootAreaQuery = structNew()>

		<cfset var curLang = arguments.user_language>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getRootArea" returnvariable="rootAreaQuery">
			<cfinvokeargument name="onlyId" value="false">
			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

        <cfset subject = "[#rootAreaQuery.name#] #langText[curLang].new_password.new_password_to_access# #APPLICATION.title#">

		<!---<cfinvoke component="AlertManager" method="getApplicationAccess" returnvariable="access_content">
		</cfinvoke>--->


		<cfsavecontent variable="html_text">
		<cfoutput>
#langText[curLang].new_password.new_password_to_access_application# #APPLICATION.title# #langText[curLang].common.of_the_organization# <b>#rootAreaQuery.name#</b>.<br /><br />

#langText[curLang].common.your_access_email#: #arguments.user_email#<br /><br/>
<span style="font-size:15px">#langText[curLang].new_password.new_password#: <b>#arguments.user_password#</b></span><br/><br/>
#langText[curLang].common.you_must_change_password#.<br /><br/>

<div style="border-color:##CCCCCC; color:##666666; border-style:solid; border-width:1px; padding:8px;">#langText[curLang].common.access_to_application#: <br/><a href="#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#" target="_blank">#APPLICATION.mainUrl##APPLICATION.path#/html/login/?client_abb=#arguments.client_abb#</a></div>

		</cfoutput>
		</cfsavecontent>

		<!--- <cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'> --->

		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;"><span style="color:##FF0000; font-size:12px;">#langText[curLang].common.foot_do_not_reply#.</span><br/>#langText[curLang].common.foot_content_default_1# #APPLICATION.title#.</p>'>

		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
			<cfinvokeargument name="to" value="#arguments.user_email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>


	</cffunction>




	<!--- -------------------------------------- newIncidence ----------------------------------- --->

	<cffunction name="newIncidence" access="public" returntype="void">
		<cfargument name="objectIncidence" type="query" required="yes">

		<cfset var method = "newIncidence">

		<cfset var subject = "">
		<cfset var foot_content = "">
		<cfset var curLang = "es">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinvoke component="AreaManager" method="getRootArea" returnvariable="root_area">
        </cfinvoke>
        <cfset subject = "[#root_area.name#] Incidencia registrada.">

		<cfsavecontent variable="html_text">
			<cfoutput>
			Su incidencia ha sido registrada con los siguientes datos:<br/><br/>
			ID de incidencia: <strong>#client_abb##objectIncidence.id#</strong><br/>
			Fecha de registro: <strong>#objectIncidence.creation_date_formatted#</strong><br/>
			Tipo: <strong>#objectIncidence.title_es#</strong><br/>
			Referente a: <strong>#objectIncidence.related_to#</strong><br/>
			Asunto: <strong>#objectIncidence.title#</strong><br/>
			Descripción detallada: <br/> #objectIncidence.description#<br/><br/><br/>

			Recibirá información sobre la incidencia comunicada a través de su e-mail.<br/>
			Gracias por usar este servicio.
			</cfoutput>
		</cfsavecontent>

		<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
			<cfinvokeargument name="get_user_id" value="#objectIncidence.user_in_charge#">
			<cfinvokeargument name="format_content" value="default">
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>

		<cfsavecontent variable="html_text_admin">
			<cfoutput>
			Incidencia registrada:<br/><br/>
			Cliente: <strong>#client_abb#</strong><br/>
			Usuario: <strong>#objectUser.family_name# #objectUser.name# (#objectUser.email#)</strong><br/>
			ID de incidencia: <strong>#client_abb##objectIncidence.id#</strong><br/>
			Fecha de registro: <strong>#objectIncidence.creation_date_formatted#</strong><br/>
			Tipo: <strong>#objectIncidence.title_es#</strong><br/>
			Referente a: <strong>#objectIncidence.related_to#</strong><br/>
			Asunto: <strong>#objectIncidence.title#</strong><br/>
			Descripción detallada: <br/> #objectIncidence.description#
			</cfoutput>
		</cfsavecontent>

		<cfset foot_content = '<p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:9px;">#langText[curLang].common.foot_content_default_3# #APPLICATION.title#.</p>'>

		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#objectUser.email#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>

		<cfinvoke component="EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#SESSION.client_email_from#">
			<cfinvokeargument name="to" value="#APPLICATION.emailFail#">
			<cfinvokeargument name="subject" value="#subject#">
			<cfinvokeargument name="content" value="#html_text_admin#">
			<cfinvokeargument name="foot_content" value="#foot_content#">
		</cfinvoke>


	</cffunction>




	<!--- -------------------------------------- getApplicationAccess ------------------------------------ --->

	<cffunction name="getApplicationAccess" access="public" returntype="string">
		<cfargument name="client_id" type="string" required="true">
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="curLang" type="string" required="true"/>

		<cfset var method = "getApplicationAccess">

		<cfset var access_default = "">
		<cfset var access_content = "">
		<cfset var accessClient = "">

		<cfif APPLICATION.twoUrlsToAccess IS false>

			<cfset access_default = '#langText[curLang].common.access_to_application#: '>

			<cfif arguments.client_abb EQ "hcs">
				<cfset accessClient = "doplanning">
			<cfelse>
				<cfset accessClient = arguments.client_id>
			</cfif>

			<cfset access_content = '#access_default#<a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#">#APPLICATION.mainUrl##APPLICATION.path#/#accessClient#</a>'>

		<cfelse>

			<cfsavecontent variable="access_content">
			<cfoutput>
			<!---<br/><br/>--->#langText[curLang].common.access_to_application_links#:<br/>
			-&nbsp;#langText[curLang].common.access_internal# <a target="_blank" href="#APPLICATION.mainUrl##APPLICATION.path#/">#APPLICATION.mainUrl##APPLICATION.path#/</a><br/>
			-&nbsp;#langText[curLang].common.access_external# <a target="_blank" href="#APPLICATION.alternateUrl#">#APPLICATION.alternateUrl#</a>
			</cfoutput>
			</cfsavecontent>

		</cfif>

		<cfreturn access_content>

	</cffunction>


	<!--- -------------------------------------- getLastAlertMessage ------------------------------------ --->

	<cffunction name="getLastAlertMessage" returntype="string" access="public">

		<cfset var method = "getLastAlertMessage">

		<!---<cfinclude template="includes/initVars.cfm">--->

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery datasource="#APPLICATION.dsn#" name="app_alert_messages">
				SELECT *
				FROM app_alert_messages
				WHERE expiration_date > NOW();
			</cfquery>

			<cfquery datasource="#client_dsn#" name="alert_messages">
				SELECT *
				FROM #client_abb#_alert_messages
				WHERE expiration_date > NOW();
			</cfquery>

			<cfquery dbtype="query" name="getAlertMessage">
				SELECT * FROM app_alert_messages
				UNION ALL
				SELECT * FROM alert_messages;
			</cfquery>


			<cfif getAlertMessage.recordCount GT 0>
				<cfset alert_message = getAlertMessage.content>
			<cfelse>
				<cfset alert_message = "">
			</cfif>

			<cfset xmlResponseContent = "<alert_message><![CDATA[#alert_message#]]></alert_message>">

			<cfinclude template="includes/functionEndNoLog.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


	<!--- -------------------------------------- getLastAlertMessageAdmin ------------------------------------ --->

	<cffunction name="getLastAlertMessageAdmin" returntype="string" access="public">

		<cfset var method = "getLastAlertMessageAdmin">

		<!---<cfinclude template="includes/initVars.cfm">--->

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">


			<cfset xmlResponseContent = "<alert_message><![CDATA[<b>Hola, este es el mensaje de #APPLICATION.title# para el administrador</b>]]></alert_message>">

			<cfinclude template="includes/functionEndNoLog.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


</cfcomponent>
