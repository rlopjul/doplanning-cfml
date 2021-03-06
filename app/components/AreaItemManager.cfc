<!--- Copyright Era7 Information Technologies 2007-2016 --->
<cfcomponent output="false">

	<cfset component = "AreaItemManager">

	<cfset messageTypeId = 1>
	<cfset entryTypeId = 2>
	<cfset linkTypeId = 3>
	<cfset newsTypeId = 4>
	<cfset eventTypeId = 5>
	<cfset taskTypeId = 6>

	<!--- <cfset timeZoneTo = "+1:00"> --->
	<cfset timeZoneTo = "Europe/Madrid">

	<cfset LAST_UPDATE_TYPE_ITEM = "item">

	<cfset CREATED_STATE = "created">
	<cfset MODIFIED_STATE = "modified">
	<cfset SENT_TO_TEST_STATE = "sent_to_test">
	<cfset SENT_STATE = "sent">


	<!--- ----------------------- XML ITEM -------------------------------- --->

	<cffunction name="xmlItem" returntype="string" access="public">
		<cfargument name="objectItem" type="struct" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">

		<cfset var method = "xmlItem">

		<cfset var itemTypeName = "">

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult">
				<cfoutput><#itemTypeName#
					<cfif objectItem.tree_mode EQ "true">
						title="#xmlFormat(objectItem.title)#"
						<cfif objectItem.attached_file_name NEQ "NULL">
						attached_file_name="#xmlFormat(objectItem.attached_file_name)#"
						<cfelse>attached_file_name="-"</cfif>
						user_full_name="#xmlFormat(objectItem.user_full_name)#"
					</cfif>
					<cfif len(objectItem.id) GT 0>
						id="#objectItem.id#"
					</cfif>
					<cfif len(objectItem.parent_id) GT 0>
						parent_id="#objectItem.parent_id#"
					</cfif>
					<cfif len(objectItem.parent_kind) GT 0>
						parent_kind="#objectItem.parent_kind#"
					</cfif>
					<cfif len(objectItem.area_id) GT 0>
						area_id="#objectItem.area_id#"
					</cfif>
					<cfif len(objectItem.area_name) GT 0>
						area_name="#xmlFormat(objectItem.area_name)#"
					</cfif>
					<cfif len(objectItem.user_in_charge) GT 0>
						user_in_charge="#objectItem.user_in_charge#"
					</cfif>
					<cfif len(objectItem.creation_date) GT 0>
						creation_date="#objectItem.creation_date#"
					</cfif>
					<cfif len(objectItem.attached_file_id) GT 0>
						attached_file_id="#objectItem.attached_file_id#"
					</cfif>
					<cfif len(objectItem.attached_image_id) GT 0>
						attached_image_id="#objectItem.attached_image_id#"
					</cfif>
					<cfif len(objectItem.attached_file_type) GT 0>
						attached_file_type="#objectItem.attached_file_type#"
					</cfif>
					<!---<cfif len(objectItem.attached_image_type) GT 0>
						attached_image_type="#objectItem.attached_image_type#"
					</cfif>--->
					<cfif len(objectItem.notify_by_sms) GT 0>
						notify_by_sms="#objectItem.notify_by_sms#"
					</cfif>
					<cfif len(objectItem.post_to_twitter) GT 0>
						post_to_twitter="#objectItem.post_to_twitter#"
					</cfif>
					<cfif len(objectItem.start_date) GT 0>
						start_date="#objectItem.start_date#"
					</cfif>
					<cfif len(objectItem.end_date) GT 0>
						end_date="#objectItem.end_date#"
					</cfif>
					<cfif len(objectItem.place) GT 0>
						place="#objectItem.place#"
					</cfif>
					<cfif len(objectItem.recipient_user) GT 0>
						recipient_user="#objectItem.recipient_user#"
					</cfif>
					<cfif len(objectItem.done) GT 0>
						done="#objectItem.done#"
					</cfif>
					<cfif len(objectItem.estimated_value) GT 0>
						estimated_value="#objectItem.estimated_value#"
					</cfif>
					<cfif len(objectItem.real_value) GT 0>
						real_value="#objectItem.real_value#"
					</cfif>
					<cfif len(objectItem.start_time) GT 0>
						start_time="#objectItem.start_time#"
					</cfif>
					<cfif len(objectItem.end_time) GT 0>
						end_time="#objectItem.end_time#"
					</cfif>
					<cfif len(objectItem.last_update_date) GT 0>
						last_update_date="#objectItem.last_update_date#"
					</cfif>
					<cfif len(objectItem.position) GT 0>
						position="#objectItem.position#"
					</cfif>
					<cfif len(objectItem.display_type_id) GT 0>
						display_type_id="#objectItem.display_type_id#"
					</cfif>
					<cfif len(objectItem.iframe_display_type_id) GT 0>
						iframe_display_type_id="#objectItem.iframe_display_type_id#"
					</cfif>
					<cfif len(objectItem.user_image_type) GT 0>
						user_image_type="#objectItem.user_image_type#"
					</cfif>
					<cfif len(objectItem.state) GT 0>
						state="#objectItem.state#"
					</cfif>
					<cfif len(objectItem.identifier) GT 0>
						identifier="#objectItem.identifier#"
					</cfif>
					<cfif len(objectItem.link_target) GT 0>
						link_target="#objectItem.link_target#"
					</cfif>
					<cfif len(objectItem.structure_available) GT 0>
						structure_available="#objectItem.structure_available#"
					</cfif>
					<cfif len(objectItem.general) GT 0>
						general="#objectItem.general#"
					</cfif>
					>
					<cfif objectItem.tree_mode NEQ "true">
						<cfif len(objectItem.attached_file_name) NEQ 0 AND objectItem.attached_file_name NEQ "NULL">
							<attached_file_name><![CDATA[#objectItem.attached_file_name#]]></attached_file_name>
						<cfelse>
							<attached_file_name><![CDATA[-]]></attached_file_name>
						</cfif>
						<cfif len(objectItem.attached_image_name) NEQ 0 AND objectItem.attached_image_name NEQ "NULL">
							<attached_image_name><![CDATA[#objectItem.attached_image_name#]]></attached_image_name>
						<cfelse>
							<attached_image_name><![CDATA[-]]></attached_image_name>
						</cfif>
						<cfif len(objectItem.title) NEQ 0>
							<title><![CDATA[#objectItem.title#]]></title>
						</cfif>
						<cfif len(objectItem.link) NEQ 0>
							<link><![CDATA[#objectItem.link#]]></link>
						</cfif>
						<cfif len(objectItem.description) NEQ 0>
							<description><![CDATA[#objectItem.description#]]></description>
						</cfif>
						<cfif len(objectItem.user_full_name) NEQ 0>
							<user_full_name><![CDATA[#objectItem.user_full_name#]]></user_full_name>
						</cfif>
						<cfif len(objectItem.iframe_url) NEQ 0>
							<iframe_url><![CDATA[#objectItem.iframe_url#]]></iframe_url>
						</cfif>
					</cfif>
					<cfif len(objectItem.recipient_user_full_name) NEQ 0>
						<recipient_user_full_name><![CDATA[#objectItem.recipient_user_full_name#]]></recipient_user_full_name>
					</cfif>


					<cfif len(objectItem.sub_items) NEQ 0>
						#objectItem.sub_items#
					</cfif>
				</#itemTypeName#></cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>



			<cfreturn xmlResult>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>

	</cffunction>


	<!--- ----------------------- ITEM OBJECT -------------------------------- --->

	<cffunction name="objectItem" returntype="any" output="false" access="public">
		<cfargument name="itemTypeId" type="numeric" required="yes">

		<cfargument name="xml" type="string" required="no">

		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="parent_id" type="string" required="no" default="">
		<cfargument name="parent_kind" type="string" required="no" default="">
		<cfargument name="area_id" type="string" required="no" default="">
		<cfargument name="user_in_charge" type="string" required="no" default="">
		<cfargument name="creation_date" type="string" required="no" default="">
		<cfargument name="attached_file_id" type="string" required="no" default="">
		<cfargument name="attached_image_id" type="string" required="no" default="">
		<cfargument name="area_name" type="string" required="no" default="">
		<cfargument name="attached_file_name" type="string" required="no" default="">
		<cfargument name="attached_image_name" type="string" required="no" default="">
		<cfargument name="title" type="string" required="no" default="">
		<cfargument name="link" type="string" required="no" default="">
		<cfargument name="link_target" type="string" required="no" default="">
		<cfargument name="description" type="string" required="no" default="">
		<cfargument name="user_full_name" type="string" required="no" default="">
		<cfargument name="sub_items" type="string" required="no" default="">
		<cfargument name="attached_file_type" type="string" required="no" default="">
		<cfargument name="notify_by_sms" type="string" required="no" default="">
		<cfargument name="post_to_twitter" type="string" required="no" default="">
		<cfargument name="start_date" type="string" required="no" default="">
		<cfargument name="end_date" type="string" required="no" default="">
		<cfargument name="place" type="string" required="no" default="">
		<cfargument name="recipient_user" type="string" required="no" default="">
		<cfargument name="recipient_user_full_name" type="string" required="no" default="">
		<cfargument name="done" type="string" required="no" default="">
		<cfargument name="estimated_value" type="string" required="no" default="">
		<cfargument name="real_value" type="string" required="no" default="">
		<cfargument name="start_time" type="string" required="no" default="">
		<cfargument name="end_time" type="string" required="no" default="">
		<cfargument name="last_update_date" type="string" required="no" default="">
		<cfargument name="position" type="string" required="no" default="">
		<cfargument name="display_type_id" type="string" required="no" default="">
		<cfargument name="iframe_url" type="string" required="no" default="">
		<cfargument name="iframe_display_type_id" type="string" required="no" default="">
		<cfargument name="user_image_type" type="string" required="no" default="">
		<cfargument name="state" type="string" required="no" default="">
		<cfargument name="identifier" type="string" required="no" default="">
		<cfargument name="structure_available" type="string" required="false" default="">
		<cfargument name="general" type="string" required="false" default="">

		<cfargument name="tree_mode" type="boolean" required="no" default="false"><!---Con esto a true se pasan los elementos como atributos--->

		<cfargument name="return_type" type="string" required="no">

		<cfset var method = "objectItem">

		<cfset var itemTypeName = "">

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif isDefined("arguments.xml")>

				<cfxml variable="xmlItem">
				<cfoutput>
				#xml#
				</cfoutput>
				</cfxml>

				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.id")>
					<cfset id=xmlItem.xmlChildren[1].XmlAttributes.id>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.parent_id")>
					<cfset parent_id=xmlItem.xmlChildren[1].XmlAttributes.parent_id>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.parent_kind")>
					<cfset parent_kind=xmlItem.xmlChildren[1].XmlAttributes.parent_kind>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.area_id")>
					<cfset area_id=xmlItem.xmlChildren[1].XmlAttributes.area_id>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.user_in_charge")>
					<cfset user_in_charge=xmlItem.xmlChildren[1].XmlAttributes.user_in_charge>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.creation_date")>
					<cfset creation_date=xmlItem.xmlChildren[1].XmlAttributes.creation_date>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.attached_file_id")>
					<cfset attached_file_id="#xmlItem.xmlChildren[1].XmlAttributes.attached_file_id#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.attached_image_id")>
					<cfset attached_image_id="#xmlItem.xmlChildren[1].XmlAttributes.attached_image_id#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.XmlAttributes.area_name")>
					<cfset area_name="#xmlItem.xmlChildren[1].XmlAttributes.area_name#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.attached_file_name.xmlText")>
					<cfset attached_file_name="#xmlItem.xmlChildren[1].attached_file_name.xmlText#">
				<cfelseif isDefined("xmlItem.#itemTypeName#.xmlAttributes.attached_file_name")>
					<cfset attached_file_name=xmlItem.xmlChildren[1].xmlAttributes.attached_file_name>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.attached_image_name.xmlText")>
					<cfset attached_image_name="#xmlItem.xmlChildren[1].attached_image_name.xmlText#">
				<cfelseif isDefined("xmlItem.#itemTypeName#.xmlAttributes.attached_image_name")>
					<cfset attached_image_name=xmlItem.xmlChildren[1].xmlAttributes.attached_image_name>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.title")>
					<cfset title=xmlItem.xmlChildren[1].title.xmlText>
				<cfelseif isDefined("xmlItem.#itemTypeName#.XmlAttributes.title")>
					<cfset title = xmlItem.xmlChildren[1].XmlAttributes.title>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.link")>
					<cfset link=xmlItem.xmlChildren[1].link.xmlText>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.link_target")>
					<cfset link_target="#xmlItem.xmlChildren[1].XmlAttributes.link_target#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.description")>
					<cfset description=xmlItem.xmlChildren[1].description.xmlText>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.user_full_name")>
					<cfset user_full_name=xmlItem.xmlChildren[1].user_full_name.xmlText>
				<cfelseif isDefined("xmlItem.#itemTypeName#.xmlAttributes.user_full_name")>
					<cfset user_full_name=xmlItem.xmlChildren[1].xmlAttributes.user_full_name>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.iframe_url")>
					<cfset iframe_url=xmlItem.xmlChildren[1].iframe_url.xmlText>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.recipient_user_full_name")>
					<cfset recipient_user_full_name=xmlItem.xmlChildren[1].recipient_user_full_name.xmlText>
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.attached_file_type")>
					<cfset attached_file_type="#xmlItem.xmlChildren[1].XmlAttributes.attached_file_type#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.notify_by_sms")>
					<cfset notify_by_sms="#xmlItem.xmlChildren[1].XmlAttributes.notify_by_sms#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.post_to_twitter")>
					<cfset post_to_twitter="#xmlItem.xmlChildren[1].XmlAttributes.post_to_twitter#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.start_date")>
					<cfset start_date="#xmlItem.xmlChildren[1].XmlAttributes.start_date#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.end_date")>
					<cfset end_date="#xmlItem.xmlChildren[1].XmlAttributes.end_date#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.place")>
					<cfset place="#xmlItem.xmlChildren[1].XmlAttributes.place#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.recipient_user")>
					<cfset recipient_user="#xmlItem.xmlChildren[1].XmlAttributes.recipient_user#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.done")>
					<cfset done="#xmlItem.xmlChildren[1].XmlAttributes.done#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.estimated_value")>
					<cfset estimated_value="#xmlItem.xmlChildren[1].XmlAttributes.estimated_value#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.real_value")>
					<cfset real_value="#xmlItem.xmlChildren[1].XmlAttributes.real_value#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.start_time")>
					<cfset start_time="#xmlItem.xmlChildren[1].XmlAttributes.start_time#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.end_time")>
					<cfset end_time="#xmlItem.xmlChildren[1].XmlAttributes.end_time#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.last_update_date")>
					<cfset last_update_date="#xmlItem.xmlChildren[1].XmlAttributes.last_update_date#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.position")>
					<cfset position="#xmlItem.xmlChildren[1].XmlAttributes.position#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.display_type_id")>
					<cfset display_type_id="#xmlItem.xmlChildren[1].XmlAttributes.display_type_id#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.iframe_display_type_id")>
					<cfset iframe_display_type_id="#xmlItem.xmlChildren[1].XmlAttributes.iframe_display_type_id#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.user_image_type")>
					<cfset user_image_type="#xmlItem.xmlChildren[1].XmlAttributes.user_image_type#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.state")>
					<cfset state="#xmlItem.xmlChildren[1].XmlAttributes.state#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.identifier")>
					<cfset identifier="#xmlItem.xmlChildren[1].XmlAttributes.identifier#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.structure_available")>
					<cfset structure_available="#xmlItem.xmlChildren[1].XmlAttributes.structure_available#">
				</cfif>
				<cfif isDefined("xmlItem.#itemTypeName#.xmlAttributes.general")>
					<cfset general="#xmlItem.xmlChildren[1].XmlAttributes.general#">
				</cfif>

			</cfif>

			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDate">
				<cfinvokeargument name="timestamp_date" value="#creation_date#">
			</cfinvoke>
			<cfset creation_date = stringDate>

			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringUpdateDate">
				<cfinvokeargument name="timestamp_date" value="#last_update_date#">
			</cfinvoke>
			<cfset last_update_date = stringUpdateDate>

			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringStartDate">
				<cfinvokeargument name="timestamp_date" value="#start_date#">
				<cfinvokeargument name="with_time" value="false">
			</cfinvoke>
			<cfset start_date = stringStartDate>

			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringStartDate">
				<cfinvokeargument name="timestamp_date" value="#end_date#">
				<cfinvokeargument name="with_time" value="false">
			</cfinvoke>
			<cfset end_date = stringStartDate>

			<cfset object = {
				id="#id#",
				parent_id="#parent_id#",
				parent_kind="#parent_kind#",
				area_id="#area_id#",
				user_in_charge="#user_in_charge#",
				creation_date="#creation_date#",
				attached_file_id="#attached_file_id#",
				attached_image_id="#attached_image_id#",
				area_name="#area_name#",
				attached_file_name="#attached_file_name#",
				attached_image_name="#attached_image_name#",
				title="#title#",
				link="#link#",
				description="#description#",
				sub_items="#sub_items#",
				user_full_name="#user_full_name#",
				tree_mode="#tree_mode#",
				attached_file_type="#attached_file_type#",
				notify_by_sms="#notify_by_sms#",
				post_to_twitter="#post_to_twitter#",
				start_date="#start_date#",
				end_date="#end_date#",
				place="#place#",
				recipient_user="#recipient_user#",
				recipient_user_full_name="#recipient_user_full_name#",
				done="#done#",
				estimated_value="#estimated_value#",
				real_value="#real_value#",
				start_time="#start_time#",
				end_time="#end_time#",
				last_update_date="#last_update_date#",
				position="#position#",
				display_type_id="#display_type_id#",
				iframe_url="#iframe_url#",
				iframe_display_type_id="#iframe_display_type_id#",
				user_image_type="#user_image_type#",
				state="#state#",
				identifier="#identifier#",
				link_target="#link_target#",
				structure_available="#structure_available#",
				general="#general#"
				}>


			<cfif isDefined("arguments.return_type")>

				<cfif arguments.return_type EQ "object">

					<cfreturn object>

				<cfelseif arguments.return_type EQ "xml">

					<cfinvoke component="AreaItemManager" method="xmlItem" returnvariable="xmlResult">
						<cfinvokeargument name="objectItem" value="#object#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					</cfinvoke>
					<cfreturn xmlResult>

				<cfelse>

					<cfreturn object>

				</cfif>

			<cfelse>

				<cfreturn object>

			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>

	</cffunction>

	<!--- createDateFromString --->

	<cffunction name="createDateFromString" returntype="date" output="false" access="public">
		<cfargument name="strDate" type="string" required="yes">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="createDateFromString" returnvariable="date">
			<cfinvokeargument name="strDate" value="#arguments.strDate#">
		</cfinvoke>

		<cfreturn date>

	</cffunction>



	<!--- ----------------------- CREATE ITEM -------------------------------- --->

	<cffunction name="createItem" returntype="struct" output="false" access="public">
		<!--- <cfargument name="objectItem" type="struct" required="true"> --->
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="status" type="string" required="false" default="ok"><!---pending/ok--->

		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="false">
		<cfargument name="link_target" type="string" required="false">
    <cfargument name="description" type="string" required="false" default="">
    <cfargument name="parent_id" type="numeric" required="true">
  	<cfargument name="parent_kind" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="notify_by_sms" type="boolean" required="false">
		<cfargument name="post_to_twitter" type="boolean" required="false">
		<cfargument name="creation_date" type="string" required="false">
		<cfargument name="creation_date_import" type="string" required="false">
		<cfargument name="start_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		<cfargument name="start_hour" type="numeric" required="false">
		<cfargument name="end_hour" type="numeric" required="false">
		<cfargument name="place" type="string" required="false">
		<cfargument name="recipient_user" type="numeric" required="false">
		<cfargument name="estimated_value" type="numeric" required="false">
		<cfargument name="real_value" type="numeric" required="false">
		<cfargument name="done" type="boolean" required="no" default="false">
		<cfargument name="display_type_id" type="numeric" required="false">
		<cfargument name="iframe_url" type="string" required="false">
		<cfargument name="iframe_display_type_id" type="numeric" required="false">
		<cfargument name="identifier" type="string" required="false">
		<cfargument name="structure_available" type="boolean" required="false" default="false">
		<cfargument name="list_rows_by_default" type="boolean" required="false" default="false">
		<cfargument name="general" type="boolean" required="false" default="false">
		<cfargument name="math_enabled" type="boolean" required="false" default="false">
		<cfargument name="form_display_type" type="string" required="false" default="">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<!--- <cfargument name="publication_time" type="string" required="false"> --->
		<cfargument name="publication_validated" type="boolean" required="false" default="false">
		<cfargument name="publication_restricted" type="boolean" required="false" default="false">
		<cfargument name="price" type="numeric" required="false">
		<cfargument name="email_addresses" type="string" required="false">
		<cfargument name="sub_type_id" type="numeric" required="false">
		<cfargument name="area_editable" type="boolean" required="false" default="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="template_id" type="numeric" required="false">
		<cfargument name="head_content" type="string" required="false">
		<cfargument name="foot_content" type="string" required="false">
		<cfargument name="content_styles" type="string" required="false">
		<cfargument name="send_to_area_users" type="boolean" required="false" default="false">
		<cfargument name="send_to_test_users" type="boolean" required="false" default="false">
		<cfargument name="user_import" type="numeric" required="false">
		<cfargument name="url_id" type="string" required="false">

		<cfset var method = "createItem">

		<cfset var response = structNew()>

		<cfset var item_id = "">
		<cfset var area_type = "">
		<cfset var itemQuery = "">
		<cfset var isUserAreaResponsible = false>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif arguments.parent_kind NEQ "area">

				<!---GET ITEM PARENT--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemParent" returnvariable="getItemParentResult">
					<cfinvokeargument name="item_id" value="#arguments.parent_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset arguments.area_id = getItemParentResult.parent_area_id>

			</cfif>

			<!--- isUserAreaResponsible --->
			<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13 OR itemTypeId IS 17><!---Lists, Forms, Typologies, Mailings--->

				<!---checkAreaResponsibleAccess--->
				<cfif isUserAreaResponsible IS false>

					<cfset error_code = 105>

					<cfthrow errorcode="#error_code#">

				</cfif>

				<!--- Scope --->
				<cfif APPLICATION.publicationScope IS true AND isDefined("arguments.publication_scope_id") AND itemTypeId IS NOT 13 AND itemTypeId IS NOT 17>

					<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isTableInScopeResult">
						<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
					</cfinvoke>

					<cfif isTableInScopeResult.result IS false>

						<cfset response = {result=false, message="El ámbito de publicación seleccionado no es compatible con el área actual"}>

						<cfreturn response>

					</cfif>

				</cfif>

			<cfelseif itemTypeId IS 16><!--- Users typologies --->

				<cfinclude template="includes/checkAdminAccess.cfm">

			<cfelse>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			</cfif>

			<cfinvoke component="AreaManager" method="getAreaType" returnvariable="areaTypeResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfset area_type = areaTypeResult.areaType>

			<cfif itemTypeId IS 7 AND arguments.parent_kind NEQ "area"><!---Consultations--->

				<cfset parent_state = getItemParentResult.state>

				<cfif parent_state EQ "closed">

					<cfthrow message="La consulta está cerrada, no puede responderla.">

				</cfif>

			</cfif>

			<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

				<cfif len(arguments.start_date) GT 0 AND len(arguments.end_date) GT 0>

					<cfset startDate = createDateFromString(arguments.start_date)>
					<cfset endDate = createDateFromString(arguments.end_date)>

					<!---end_date check--->
					<cfif DateCompare(startDate,endDate,"d") IS 1>

						<cfset response_message = 'Fechas incorrectas: la fecha de fin del evento debe ser posterior a la de inicio.'>
						<cfset response = {result=false, message=response_message}>
						<cfreturn response>

					<cfelseif itemTypeId IS 5 AND DateCompare(startDate,endDate,"d") IS 0>

						<cfset startTime = CreateTime(arguments.start_hour, arguments.start_minute, 00)>
						<cfset endTime = CreateTime(arguments.end_hour, arguments.end_minute, 00)>

						<cfif DateCompare(startTime,endTime) IS 1>

							<cfset response_message = 'Horas incorrectas: la hora de fin del evento debe ser posterior a la de inicio.'>
							<cfset response = {result=false, message=response_message}>
							<cfreturn response>

						</cfif>

					</cfif>

				</cfif>

			</cfif>

			<!--- getArea --->
			<cfinvoke component="AreaManager" method="getArea" returnvariable="areaQuery">
				<cfinvokeargument name="get_area_id" value="#arguments.area_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfif areaQuery.read_only IS true>

				<cfset message = "El área es de solo lectura">
				<cfset response = {result=false, message=#message#}>

				<cfreturn response>

			<cfelseif areaQuery['item_type_#arguments.itemTypeId#_enabled'] IS false>

				<cfset message = "Tipo de elemento deshabilitado en esta área">
				<cfset response = {result=false, message=#message#}>

				<cfreturn response>

			</cfif>

			<cfif isDefined("arguments.url_id")>

				<!--- Check url_id length --->
				<cfif len(arguments.url_id) GT 255>

					<cfset response = {result=false, message="URL de la página demasiado larga, introduzca una URL con menos de 200 caracteres"}>
					<cfreturn response>

				</cfif>

				<!--- Check if url_id exist --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemByUrlQuery">
					<cfinvokeargument name="url_id" value="#arguments.url_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif itemByUrlQuery.recordCount GT 0>
					<cfset response = {result=false, message="La URL de la página ya existe, debe usar otra distinta"}>
					<cfreturn response>
				</cfif>

			</cfif>

			<cfquery datasource="#client_dsn#" name="getUserData">
				SELECT family_name, name
				FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getUserData.recordCount LT 1><!---the user does not exist--->

				<cfset error_code = 204>

				<cfthrow errorcode="#error_code#">

			</cfif>


			<cfif itemTypeId IS 6><!---Tasks--->

				<cfquery datasource="#client_dsn#" name="getRecipientUserData">
					SELECT family_name, name
					FROM #client_abb#_users
					WHERE id = <cfqueryparam value="#arguments.recipient_user#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif getRecipientUserData.recordCount LT 1><!---the user does not exist--->

					<cfset error_code = 204>

					<cfthrow errorcode="#error_code#">

				</cfif>

			</cfif>

			<cfset arguments.title = trim(arguments.title)>

			<cftransaction>

				<cfquery name="insertItemQuery" datasource="#client_dsn#" result="insertItemResult">
					INSERT INTO #client_abb#_#itemTypeTable#
					SET title = <cfqueryparam value="#arguments.title#" cfsqltype="CF_SQL_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="CF_SQL_varchar">,
					parent_id = <cfqueryparam value="#arguments.parent_id#" cfsqltype="cf_sql_integer">,
					parent_kind = <cfqueryparam value="#arguments.parent_kind#" cfsqltype="CF_SQL_varchar">,
					<cfif isDefined("arguments.user_import") AND SESSION.user_id EQ SESSION.client_administrator>
						user_in_charge = <cfqueryparam value="#arguments.user_import#" cfsqltype="cf_sql_integer">,
					<cfelse>
						user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					</cfif>

					<!---<cfif len(objectItem.attached_file_name) GT 0>
						attached_file_name = <cfqueryparam value="#objectItem.attached_file_name#" cfsqltype="cf_sql_varchar">,
					</cfif>
					<cfif isNumeric(objectItem.attached_file_id)>
						attached_file_id = <cfqueryparam value="#objectItem.attached_file_id#" cfsqltype="cf_sql_integer">
					</cfif>,--->
					<cfif itemTypeId IS 4 OR ( itemTypeId IS 2 AND isDefined("arguments.creation_date") )><!---News OR Entries--->
					  creation_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.creation_date# 00:00" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM'),
					<cfelseif isDefined("arguments.creation_date_import") AND SESSION.user_id EQ SESSION.client_administrator>
						creation_date = <cfqueryparam value="#arguments.creation_date_import#" cfsqltype="cf_sql_timestamp">,
					<cfelse>
						creation_date = NOW(),
					</cfif>
					status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">,
					area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					<cfif itemTypeId IS NOT 20>
					, link = <cfqueryparam value="#arguments.link#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7>
					, link_target = <cfqueryparam value="#arguments.link_target#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS NOT 1>
					, last_update_date = NOW()
					</cfif>
					<cfif itemTypeId IS 20>
						, area_editable = <cfqueryparam value="#arguments.area_editable#" cfsqltype="cf_sql_bit">
					</cfif>
					<cfif itemTypeWeb IS true><!---WEB--->

						<cfif isDefined("arguments.publication_date") AND len(arguments.publication_date) IS 16>
							, publication_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.publication_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM')
							<!---, publication_time = <cfqueryparam value="#arguments.publication_time#" cfsqltype="cf_sql_time">--->
						</cfif>
						<!--- publicationValidation --->
						<cfif APPLICATION.publicationValidation IS true AND ( itemTypeId IS NOT 13 AND itemTypeId IS NOT 16 )><!--- IS NOT Typologies --->
							<cfif isUserAreaResponsible IS true AND arguments.publication_validated IS true>
								, publication_validated = <cfqueryparam value="true" cfsqltype="cf_sql_bit">
								, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
								, publication_validated_date = NOW()
							<cfelse>
								, publication_validated = <cfqueryparam value="false" cfsqltype="cf_sql_bit">
							</cfif>
						</cfif>
						<cfif APPLICATION.publicationRestricted IS true>
							, publication_restricted = <cfqueryparam value="#arguments.publication_restricted#" cfsqltype="cf_sql_bit">
						</cfif>

						<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5><!--- Entries, News, Events --->
							, iframe_url = <cfqueryparam value="#arguments.iframe_url#" cfsqltype="cf_sql_varchar">
							, iframe_display_type_id = <cfqueryparam value="#arguments.iframe_display_type_id#" cfsqltype="cf_sql_integer">
							<cfif itemTypeId IS 2><!---Entries--->
							, display_type_id = <cfqueryparam value="#arguments.display_type_id#" cfsqltype="cf_sql_integer">
							</cfif>
						</cfif>

						<cfif isDefined("arguments.url_id")>
							, url_id = <cfqueryparam value="#lCase(arguments.url_id)#" cfsqltype="cf_sql_varchar">
						</cfif>

					</cfif><!--- END WEB --->

					<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
					, start_date = STR_TO_DATE(<cfqueryparam value="#arguments.start_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y')
					, end_date = STR_TO_DATE(<cfqueryparam value="#arguments.end_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y')
					</cfif>
					<cfif itemTypeId IS 5><!---Events--->
					, start_time = <cfqueryparam value="#arguments.start_time#" cfsqltype="cf_sql_time">
					, end_time = <cfqueryparam value="#arguments.end_time#" cfsqltype="cf_sql_time">
					, place = <cfqueryparam value="#arguments.place#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS 6><!---Tasks--->
					, recipient_user = <cfqueryparam value="#arguments.recipient_user#" cfsqltype="cf_sql_varchar">
					, done = <cfqueryparam value="#arguments.done#" cfsqltype="cf_sql_bit">
					, estimated_value = <cfqueryparam value="#arguments.estimated_value#" cfsqltype="cf_sql_float">
					, real_value = <cfqueryparam value="#arguments.real_value#" cfsqltype="cf_sql_float">
					</cfif>
					<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
					, price = <cfqueryparam value="#arguments.price#" cfsqltype="cf_sql_float">
					</cfif>
					<cfif itemTypeId IS 7 OR itemTypeId IS 8><!---Consultation, PubMed comment--->
					, identifier = <cfqueryparam value="#arguments.identifier#" cfsqltype="cf_sql_varchar">
						<cfif itemTypeId IS 7>
						, state = <cfqueryparam value="created" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>

					<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13 OR itemTypeId IS 16><!---Lists, Forms, Typologies, Users typologies--->
					, structure_available = <cfqueryparam value="#arguments.structure_available#" cfsqltype="cf_sql_bit">
						<cfif itemTypeId IS 11 OR itemTypeid IS 12>
						, list_rows_by_default = <cfqueryparam value="#arguments.list_rows_by_default#" cfsqltype="cf_sql_bit">
						, math_enabled = <cfqueryparam value="#arguments.math_enabled#" cfsqltype="cf_sql_bit">
						, form_display_type = <cfqueryparam value="#arguments.form_display_type#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif SESSION.client_administrator EQ SESSION.user_id>
						, general = <cfqueryparam value="#arguments.general#" cfsqltype="cf_sql_bit">
						</cfif>
						<cfif isDefined("arguments.publication_scope_id")>
						, publication_scope_id = <cfqueryparam value="#arguments.publication_scope_id#" cfsqltype="cf_sql_integer">
						</cfif>
					</cfif>

					<cfif itemTypeId IS 17><!--- Mailing --->
						, email_addresses = <cfqueryparam value="#arguments.email_addresses#" cfsqltype="cf_sql_varchar">
						, template_id = <cfqueryparam value="#arguments.template_id#" cfsqltype="cf_sql_longvarchar">
						, head_content = <cfqueryparam value="#arguments.head_content#" cfsqltype="cf_sql_longvarchar">
						, foot_content = <cfqueryparam value="#arguments.foot_content#" cfsqltype="cf_sql_longvarchar">
						, content_styles = <cfqueryparam value="#arguments.content_styles#" cfsqltype="cf_sql_varchar">
						<cfif arguments.send_to_area_users IS true>
							, state = <cfqueryparam value="#SENT_STATE#" cfsqltype="cf_sql_varchar">
						<cfelseif arguments.send_to_test_users IS true AND listLen(arguments.email_addresses,";") GT 0>
							, state = <cfqueryparam value="#SENT_TO_TEST_STATE#" cfsqltype="cf_sql_varchar">
						<cfelse>
							, state = <cfqueryparam value="#CREATED_STATE#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>

					<cfif isDefined("arguments.sub_type_id")>
						, sub_type_id = <cfqueryparam value="#arguments.sub_type_id#" cfsqltype="cf_sql_integer">
					</cfif>
					;
				</cfquery>

				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_#itemTypeTable#;
				</cfquery>

				<cfset item_id = getLastInsertId.last_insert_id>

				<!---<cfif len(area_type) IS NOT 0>--->
				<cfif itemTypeWeb IS true><!---IS WEB---><!---El orden sólo se utiliza en los elementos web--->

					<!---getItemLastPosition--->
					<cfinvoke component="AreaItemManager" method="getAreaItemsLastPosition" returnvariable="itemLastPosition">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
					</cfinvoke>

					<cfset item_position = itemLastPosition+1>

					<cfinvoke component="AreaItemManager" method="insertAreaItemPosition">
						<cfinvokeargument name="item_id" value="#item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
						<cfinvokeargument name="position" value="#item_position#">
					</cfinvoke>

				</cfif>

				<cfif isDefined("arguments.categories_ids")>

					<!--- setItemCategories --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="setItemCategories">
						<cfinvokeargument name="item_id" value="#item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#"/>

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfif arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 OR arguments.itemTypeId IS 13 OR arguments.itemTypeId IS 16><!---Lists, Forms, Typologies, Users typologies--->

					<cfinvoke component="TableManager" method="createTableInDatabase">
						<cfinvokeargument name="table_id" value="#item_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					</cfinvoke>

					<cfif arguments.general IS true><!--- Add area column --->

						<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="addAreaColumnToTable">
							<cfinvokeargument name="table_id" value="#item_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
							<cfinvokeargument name="default_area_id" value="#arguments.area_id#">
						</cfinvoke>

					</cfif>

				</cfif>

			</cftransaction>

			<cfif arguments.itemTypeId IS 7 AND arguments.parent_kind NEQ "area" AND parent_state NEQ "answered"><!---Consultations--->

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="updateItemState">
					<cfinvokeargument name="item_id" value="#arguments.parent_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="state" value="answered">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfif arguments.status EQ "ok">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
					<cfinvokeargument name="item_id" value="#item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="published" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>


				<cfif arguments.itemTypeId EQ 17><!---Mailing--->

					<cfif arguments.send_to_area_users IS true OR arguments.send_to_test_users IS true>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/MailingManager" method="sendMailing">
							<cfinvokeargument name="objectItem" value="#itemQuery#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
							<cfinvokeargument name="user_id" value="#SESSION.user_id#">

							<cfinvokeargument name="send_to_area_users" value="#arguments.send_to_area_users#">
							<cfinvokeargument name="send_to_test_users" value="#arguments.send_to_test_users#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>

				<cfelseif arguments.no_notify IS false>

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="new">
						<cfif arguments.notify_by_sms EQ "true">
							<cfinvokeargument name="send_sms" value="true">
						</cfif>
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>


			</cfif>

			<!---postItemToTwitter--->
			<cfif arguments.post_to_twitter IS true>
				<cfinvoke component="AreaItemManager" method="postItemToTwitter">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="item_id" value="#item_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, item_id=item_id}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------- UPDATE ITEM -------------------------------- --->

	<cffunction name="updateItem" returntype="struct" output="false" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="status" type="string" required="false" default="ok"><!---pending/ok--->

		<cfargument name="title" type="string" required="true">
		<cfargument name="link" type="string" required="false">
		<cfargument name="link_target" type="string" required="false">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="notify_by_sms" type="boolean" required="false">
		<cfargument name="creation_date" type="string" required="false">
		<cfargument name="start_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		<cfargument name="start_hour" type="numeric" required="false">
		<cfargument name="end_hour" type="numeric" required="false">
		<cfargument name="place" type="string" required="false">
		<cfargument name="recipient_user" type="numeric" required="false">
		<cfargument name="estimated_value" type="numeric" required="false">
		<cfargument name="real_value" type="numeric" required="false">
		<cfargument name="done" type="boolean" required="no" default="false">
		<cfargument name="display_type_id" type="numeric" required="false">
		<cfargument name="iframe_url" type="string" required="false">
		<cfargument name="iframe_display_type_id" type="numeric" required="false">
		<cfargument name="identifier" type="string" required="false">
		<cfargument name="structure_available" type="boolean" required="false" default="false">
		<cfargument name="list_rows_by_default" type="boolean" required="false" default="false">
		<cfargument name="general" type="boolean" required="false" default="false">
		<cfargument name="math_enabled" type="boolean" required="false" default="false">
		<cfargument name="form_display_type" type="string" required="false" default="">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<!--- <cfargument name="publication_time" type="string" required="false"> --->
		<cfargument name="publication_validated" type="boolean" required="false" default="false">
		<cfargument name="publication_restricted" type="boolean" required="false" default="false">
		<cfargument name="price" type="numeric" required="false">
		<cfargument name="email_addresses" type="string" required="false">
		<cfargument name="sub_type_id" type="numeric" required="false">
		<cfargument name="area_editable" type="boolean" required="false" default="false">
		<cfargument name="unlock" type="boolean" required="false" default="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="template_id" type="numeric" required="false">
		<cfargument name="head_content" type="string" required="false">
		<cfargument name="foot_content" type="string" required="false">
		<cfargument name="content_styles" type="string" required="false">
		<cfargument name="send_to_area_users" type="boolean" required="false" default="false">
		<cfargument name="send_to_test_users" type="boolean" required="false" default="false">
		<cfargument name="url_id" type="string" required="false">


		<cfset var method = "updateItem">

		<cfset var response = structNew()>
		<cfset var itemQuery = "">

		<cfset var generalTableChanged = false>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="AreaItemManager" method="getItem" returnvariable="getItemResponse">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfif itemTypeId IS 20>
					<cfinvokeargument name="with_lock" value="true"/>
				</cfif>

				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfset getItemObject = getItemResponse.item>

			<!---checkAreaAccess--->
			<!---Esto ya se hace en getItem--->
			<!---<cfinclude template="includes/checkAreaAccess.cfm">--->

			<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

				<cfif len(arguments.start_date) GT 0 AND len(arguments.end_date) GT 0>

					<cfset startDate = createDateFromString(arguments.start_date)>
					<cfset endDate = createDateFromString(arguments.end_date)>

					<!---end_date check--->
					<cfif DateCompare(startDate,endDate,"d") IS 1>

						<cfset response_message = 'Fechas incorrectas: la fecha de fin del evento debe ser posterior a la de inicio.'>
						<cfset response = {result=false, message=response_message}>
						<cfreturn response>

					<cfelseif itemTypeId IS 5 AND DateCompare(startDate,endDate,"d") IS 0>

						<cfset startTime = CreateTime(arguments.start_hour, arguments.start_minute, 00)>
						<cfset endTime = CreateTime(arguments.end_hour, arguments.end_minute, 00)>

						<cfif DateCompare(startTime,endTime) IS 1>

							<cfset response_message = 'Horas incorrectas: la hora de fin del evento debe ser posterior a la de inicio.'>
							<cfset response = {result=false, message=response_message}>
							<cfreturn response>

						</cfif>

					</cfif>

				</cfif>

			</cfif>

			<cfif itemTypeId IS 17><!--- Mailing --->

				<cfif getItemObject.state EQ SENT_STATE>

					<cfset response_message = "No se puede modificar un boletín enviado">
					<cfset response = {result=false, message=response_message}>
					<cfreturn response>

				</cfif>

			</cfif>

			<!--- isUserAreaResponsible --->
			<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
				<cfinvokeargument name="area_id" value="#getItemObject.area_id#">
			</cfinvoke>

			<cfif itemTypeId IS 1 OR itemTypeId IS 7><!---Messages, Consultations--->

				<cfset error_code = 103><!---Access denied--->

				<cfthrow errorcode="#error_code#">

			<cfelseif itemTypeId IS 6><!---Tasks--->

				<!---Si es una tarea, puede modificarla el usuario que la creó y el usuario asignado.--->

				<cfif getItemObject.user_in_charge NEQ user_id AND getItemObject.recipient_user NEQ user_id><!---El usuario que accede no tiene permiso--->
					<cfset error_code = 103><!---Access denied--->

					<cfthrow errorcode="#error_code#">
				</cfif>

			<cfelseif itemTypeId IS 20><!--- DoPlanning Document --->

				<cfif ( getItemObject.area_editable IS false AND getItemObject.user_in_charge EQ SESSION.user_id ) NEQ true AND ( getItemObject.area_editable IS true AND (getItemObject.locked IS false OR getItemObject.lock_user_id IS SESSION.user_id) ) NEQ true>
					<cfset error_code = 103><!---Access denied--->

					<cfthrow errorcode="#error_code#">
				</cfif>

			<cfelseif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13 OR itemTypeId IS 17><!---Lists, Forms, Typologies, Mailings--->

				<!---checkAreaResponsibleAccess--->
				<cfif isUserAreaResponsible IS false>

					<cfset error_code = 105>

					<cfthrow errorcode="#error_code#">

				</cfif>

				<!--- Scope --->
				<cfif APPLICATION.publicationScope IS true AND isDefined("arguments.publication_scope_id") AND itemTypeId IS NOT 13 AND itemTypeId IS NOT 17>

					<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isTableInScopeResult">
						<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
						<cfinvokeargument name="area_id" value="#getItemObject.area_id#">
					</cfinvoke>

					<cfif isTableInScopeResult.result IS false>

						<cfset response = {result=false, message="El ámbito de publicación seleccionado no es compatible con el área actual"}>

						<cfreturn response>

					</cfif>

					<!--- getTableViews --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/ViewQuery" method="getTableViews" returnvariable="getTableViewsQuery">
						<cfinvokeargument name="table_id" value="#arguments.item_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="with_table" value="true">
						<cfinvokeargument name="parse_dates" value="true">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif getTableViewsQuery.recordCount GT 0>

						<cfloop query="getTableViewsQuery">

							<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
								<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
								<cfinvokeargument name="area_id" value="#getTableViewsQuery.area_id#">
							</cfinvoke>

							<cfif isInScopeResult.result IS false>

								<cfset response = {result=false, message="El ámbito de publicación seleccionado no es compatible con las vistas publicadas"}>

								<cfreturn response>

							</cfif>

						</cfloop>

					</cfif>

				</cfif>

			<cfelse>

				<cfif getItemObject.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que intenta modificar--->

					<cfinvoke component="AreaManager" method="getAreaType" returnvariable="areaTypeResult">
						<cfinvokeargument name="area_id" value="#getItemObject.area_id#">
					</cfinvoke>

					<cfset area_type = areaTypeResult.areaType>

					<!---Si el área es web o intranet, los items pueden modificarlos todos los que tengan acceso a ese área--->
					<cfif area_type NEQ "web" AND area_type NEQ "intranet">

						<cfset error_code = 103><!---Access denied--->

						<cfthrow errorcode="#error_code#">

					<cfelse>

						<cfinvoke component="UserManager" method="getUser" returnvariable="objectUser">
							<cfinvokeargument name="get_user_id" value="#user_id#">
							<cfinvokeargument name="format_content" value="default">
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>

						<!---Asigna el nombre del nuevo usuario para las alertas--->
						<!---<cfset objectItem.user_in_charge = user_id>
						<cfset objectItem.user_full_name = objectUser.family_name&" "&objectUser.name>--->

					</cfif>

				</cfif>

			</cfif>

			<cfif isDefined("arguments.url_id")>

				<!--- Check url_id length --->
				<cfif len(arguments.url_id) GT 255>

					<cfset response = {result=false, message="URL de la página demasiado larga, introduzca una URL con menos de 200 caracteres"}>
					<cfreturn response>

				</cfif>

				<!--- Check if url_id exist --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemByUrlQuery">
					<cfinvokeargument name="url_id" value="#arguments.url_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif itemByUrlQuery.recordCount GT 1 OR (itemByUrlQuery.recordCount IS 1 AND itemByUrlQuery.id NEQ arguments.item_id)>
					<cfset response = {result=false, message="La URL de la página ya existe, debe usar otra distinta"}>
					<cfreturn response>
				</cfif>

			</cfif>


			<cfif itemTypeId IS 6><!---Tasks--->

				<cfquery datasource="#client_dsn#" name="getRecipientUserData">
					SELECT family_name, name
					FROM #client_abb#_users
					WHERE id = <cfqueryparam value="#arguments.recipient_user#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif getRecipientUserData.recordCount LT 1><!---the user does not exist--->

					<cfset error_code = 204>

					<cfthrow errorcode="#error_code#">

				</cfif>

				<!---<cfset objectItem.recipient_user_full_name = "#getRecipientUserData.family_name# #getRecipientUserData.name#">--->

			</cfif>


			<cftransaction>

				<cfquery name="updateItemQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_#itemTypeTable#
					SET title = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">,
					link = <cfqueryparam value="#arguments.link#" cfsqltype="cf_sql_varchar">
					<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7>
					, link_target = <cfqueryparam value="#arguments.link_target#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS 4><!---News--->
						, creation_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.creation_date# 00:00" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM')
					</cfif>
					, last_update_date = NOW()
					, last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">

					<cfif itemTypeId IS 20 AND getItemObject.user_in_charge EQ SESSION.user_id><!--- DoPlanning Document --->
						, area_editable = <cfqueryparam value="#arguments.area_editable#" cfsqltype="cf_sql_bit">
					</cfif>

					<cfif itemTypeWeb IS true><!---WEB--->

						<cfif isDefined("arguments.publication_date") AND len(arguments.publication_date) IS 16>
							, publication_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.publication_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM')
							<!---, publication_time = <cfqueryparam value="#arguments.publication_time#" cfsqltype="cf_sql_time">--->
						</cfif>
						<!--- publicationValidation --->
						<cfif APPLICATION.publicationValidation IS true AND isUserAreaResponsible IS true>
							, publication_validated = <cfqueryparam value="#arguments.publication_validated#" cfsqltype="cf_sql_bit">
							<cfif arguments.publication_validated IS true AND getItemObject.publication_validated IS false>
								, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
								, publication_validated_date = NOW()
							</cfif>
						</cfif>
						<cfif APPLICATION.publicationRestricted IS true>
						, publication_restricted = <cfqueryparam value="#arguments.publication_restricted#" cfsqltype="cf_sql_bit">
						</cfif>

						<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5><!---Entries, News, Events--->
							, iframe_url = <cfqueryparam value="#arguments.iframe_url#" cfsqltype="cf_sql_varchar">
							, iframe_display_type_id = <cfqueryparam value="#arguments.iframe_display_type_id#" cfsqltype="cf_sql_integer">
							<cfif itemTypeId IS 2><!---Entries--->
							, display_type_id = <cfqueryparam value="#arguments.display_type_id#" cfsqltype="cf_sql_integer">
							</cfif>
						</cfif>

						<cfif isDefined("arguments.url_id")>
							, url_id = <cfqueryparam value="#lCase(arguments.url_id)#" cfsqltype="cf_sql_varchar">
						</cfif>

					</cfif><!--- END WEB --->

					<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
					, start_date = STR_TO_DATE(<cfqueryparam value="#arguments.start_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y')
					, end_date = STR_TO_DATE(<cfqueryparam value="#arguments.end_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y')
					</cfif>
					<cfif itemTypeId IS 5><!---Events--->
					, start_time = <cfqueryparam value="#arguments.start_time#" cfsqltype="cf_sql_time">
					, end_time = <cfqueryparam value="#arguments.end_time#" cfsqltype="cf_sql_time">
					, place = <cfqueryparam value="#arguments.place#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
					, price = <cfqueryparam value="#arguments.price#" cfsqltype="cf_sql_float">
					</cfif>
					<cfif itemTypeId IS 6><!---Tasks--->
					, recipient_user = <cfqueryparam value="#arguments.recipient_user#" cfsqltype="cf_sql_varchar">
					, done = <cfqueryparam value="#arguments.done#" cfsqltype="cf_sql_bit">
					, estimated_value = <cfqueryparam value="#arguments.estimated_value#" cfsqltype="cf_sql_float">
					, real_value = <cfqueryparam value="#arguments.real_value#" cfsqltype="cf_sql_float">
					<!---
					<cfelse><!---Is not tasks--->
					, user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">--->
					</cfif>
					<cfif itemTypeId IS 8><!---PubMed comment--->
					, identifier = <cfqueryparam value="#arguments.identifier#" cfsqltype="cf_sql_varchar">
					</cfif>
					<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13><!---Lists, Forms, Typologies--->
						, structure_available = <cfqueryparam value="#arguments.structure_available#" cfsqltype="cf_sql_bit">
						<cfif itemTypeId IS 11 OR itemTypeid IS 12>
						, list_rows_by_default = <cfqueryparam value="#arguments.list_rows_by_default#" cfsqltype="cf_sql_bit">
						, math_enabled = <cfqueryparam value="#arguments.math_enabled#" cfsqltype="cf_sql_bit">
						, form_display_type = <cfqueryparam value="#arguments.form_display_type#" cfsqltype="cf_sql_varchar">
						</cfif>
						<cfif SESSION.client_administrator EQ SESSION.user_id>

							<cfif itemTypeId IS 11 OR itemTypeId IS 12><!--- Lists AND Forms --->

								<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="hasTableRowsOfOtherAreas" returnvariable="hasTableRowsOfOtherAreas">
									<cfinvokeargument name="table_id" value="#table_id#">
									<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
								</cfinvoke>

							</cfif>

							<cfif ( itemTypeId NEQ 11 AND itemTypeId NEQ 12 ) OR hasTableRowsOfOtherAreas.rowsOfOtherAreas IS false>
								, general = <cfqueryparam value="#arguments.general#" cfsqltype="cf_sql_bit">

								<cfif getItemObject.general NEQ arguments.general>
									<cfset generalTableChanged = true>
								</cfif>
							</cfif>

						</cfif>
						<cfif isDefined("arguments.publication_scope_id")>
						, publication_scope_id = <cfqueryparam value="#arguments.publication_scope_id#" cfsqltype="cf_sql_integer">
						</cfif>
					</cfif>

					<cfif itemTypeId IS 17><!--- Mailing --->
						, email_addresses = <cfqueryparam value="#arguments.email_addresses#" cfsqltype="cf_sql_varchar">
						, template_id = <cfqueryparam value="#arguments.template_id#" cfsqltype="cf_sql_longvarchar">
						, head_content = <cfqueryparam value="#arguments.head_content#" cfsqltype="cf_sql_longvarchar">
						, foot_content = <cfqueryparam value="#arguments.foot_content#" cfsqltype="cf_sql_longvarchar">
						, content_styles = <cfqueryparam value="#arguments.content_styles#" cfsqltype="cf_sql_varchar">
						<cfif arguments.send_to_area_users IS true>
							, state = <cfqueryparam value="#SENT_STATE#" cfsqltype="cf_sql_varchar">
						<cfelseif arguments.send_to_test_users IS true AND listLen(arguments.email_addresses,";") GT 0>
							, state = <cfqueryparam value="#SENT_TO_TEST_STATE#" cfsqltype="cf_sql_varchar">
						<cfelse>
							, state = <cfqueryparam value="#MODIFIED_STATE#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>

					<cfif isDefined("arguments.sub_type_id")>
						, sub_type_id = <cfqueryparam value="#arguments.sub_type_id#" cfsqltype="cf_sql_integer">
					</cfif>
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!--- deleteItemCategories --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItemCategories">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif isDefined("arguments.categories_ids")>

					<!--- setItemCategories --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="setItemCategories">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#"/>

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfif generalTableChanged IS true>

					<cfif arguments.general IS true><!--- Add area column --->

						<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="addAreaColumnToTable">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
							<cfinvokeargument name="default_area_id" value="#getItemObject.area_id#">
						</cfinvoke>

					<cfelse><!--- Remove area column --->

						<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="deleteAreaColumnInTable">
							<cfinvokeargument name="table_id" value="#table_id#">
							<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						</cfinvoke>

					</cfif>

				</cfif>

			</cftransaction>

			<cfif arguments.status EQ "ok">

				<cfif arguments.itemTypeId IS 11 OR arguments.itemTypeId IS 12 OR arguments.itemTypeId IS 13><!--- Tables --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTable" returnvariable="itemQuery">
						<cfinvokeargument name="table_id" value="#arguments.item_id#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="parse_dates" value="true">
						<cfinvokeargument name="published" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				<cfelse>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parse_dates" value="true">
						<cfinvokeargument name="published" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

				<cfif arguments.itemTypeId EQ 17><!---Mailing--->

					<cfif arguments.send_to_area_users IS true OR arguments.send_to_test_users IS true>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/MailingManager" method="sendMailing">
							<cfinvokeargument name="objectItem" value="#itemQuery#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
							<cfinvokeargument name="user_id" value="#SESSION.user_id#">

							<cfinvokeargument name="send_to_area_users" value="#arguments.send_to_area_users#">
							<cfinvokeargument name="send_to_test_users" value="#arguments.send_to_test_users#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>

				<cfelseif arguments.no_notify IS false>

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="update">
						<cfif arguments.notify_by_sms EQ "true">
							<cfinvokeargument name="send_sms" value="true">
						</cfif>

						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cfif>

			<cfinclude template="includes/logRecord.cfm">

			<!--- Unlock DoPlanning Document --->
			<cfif arguments.itemTypeId IS 20 AND arguments.unlock IS true>

				<cfinvoke component="AreaItemManager" method="changeAreaItemLock" returnvariable="changeLockResponse">
					<cfinvokeargument name="item_id" value="#arguments.item_id#"/>
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
					<cfinvokeargument name="lock" value="false"/>
				</cfinvoke>

				<cfif changeLockResponse.result IS false>

					<cfreturn changeLockResponse>

				</cfif>

			</cfif>

			<cfset response = {result=true, objectItem=#objectItem#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!---  ----------------------------------GET ITEM CATEGORIES--------------------------------   --->

	<cffunction name="getItemCategories" returntype="struct" output="false" access="public">
		<cfargument name="item_id" required="true" type="numeric">
		<cfargument name="itemTypeId" required="true" type="numeric">

		<cfset var method = "getItemCategories">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif itemTypeId IS 10>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileAreas" returnvariable="getFileAreasQuery">
					<cfinvokeargument name="file_id" value="#arguments.item_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif getFileAreasQuery.recordCount GT 0>

					<cfif getFileAreasQuery.recordCount IS 1>

						<cfset area_id = getFileAreasQuery.area_id>

						<cfinclude template="includes/checkAreaAccess.cfm">

					<cfelse>

						<cfset fileAreasList = valueList(getFileAreasQuery.area_id)>
						<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreasAccess">
							<cfinvokeargument name="areasList" value="#fileAreasList#">
						</cfinvoke>

					</cfif>

				<cfelse>

					<cfset error_code = 103>

					<cfthrow errorcode="#error_code#">

				</cfif>

			<cfelse>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="selectItemQuery">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="parse_dates" value="false">
					<cfinvokeargument name="published" value="false">

					<cfinvokeargument name="with_lock" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif selectItemQuery.recordCount GT 0>

					<cfset area_id = selectItemQuery.area_id>

					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				<cfelse>

					<cfset error_code = 103>

					<cfthrow errorcode="#error_code#">

				</cfif>

			</cfif>

			<!--- getItemCategories --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="getItemCategoriesResult">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, query=#getItemCategoriesResult#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------- UPDATE ITEM WITH ATTACHED -------------------------------- --->

	<cffunction name="updateItemWithAttachedFile" returntype="struct" output="false" access="public">
		<!---<cfargument name="objectItem" type="struct" required="true">--->
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="file_name" type="string" required="true"/>
		<cfargument name="file_file_name" type="string" required="true"/>
		<cfargument name="file_size" type="numeric" required="true"/>
		<cfargument name="file_type" type="string" required="true"/>
		<cfargument name="file_description" type="string" required="true"/>

		<cfargument name="publication_date" type="string" required="false">
		<!--- <cfargument name="publication_time" type="string" required="false"> --->
		<cfargument name="publication_validated" type="boolean" required="false">
		<cfargument name="price" type="numeric" required="false">
		<cfargument name="sub_type_id" type="numeric" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "updateItemWithAttachedFile">

		<cfset var response = structNew()>

			<cftry>

				<cfinclude template="includes/functionStart.cfm">

				<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

				<!---
				<cfinvoke component="AreaItemManager" method="updateItem" returnvariable="updateItemResponse">
					<cfinvokeargument name="objectItem" value="#arguments.objectItem#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="status" value="pending">
					<cfinvokeargument name="publication_date" value="#arguments.publication_date#">
					<!--- <cfinvokeargument name="publication_time" value="#arguments.publication_time#"> --->
					<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
					<cfinvokeargument name="price" value="#arguments.price#">
					<cfinvokeargument name="sub_type_id" value="#arguments.sub_type_id#">
					<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#">
					<cfinvokeargument name="no_notify" value="#arguments.no_notify#">
				</cfinvoke>
				--->

				<!--- updateItem --->
				<cfinvoke component="AreaItemManager" method="updateItem" argumentcollection="#arguments#" returnvariable="updateItemResponse">
					<cfinvokeargument name="status" value="pending">
				</cfinvoke>

				<cfif updateItemResponse.result IS false>

					<cfreturn updateItemResponse>

				</cfif>

				<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResponse">
					<cfinvokeargument name="name" value="#arguments.file_name#">
					<cfinvokeargument name="file_name" value="#arguments.file_file_name#">
					<cfinvokeargument name="file_type" value="#arguments.file_type#">
					<cfinvokeargument name="file_size" value="#arguments.file_size#">
					<cfinvokeargument name="description" value="#arguments.file_description#">
					<cfinvokeargument name="fileTypeId" value="1">
				</cfinvoke>

				<cfif createFileResponse.result IS true>

					<cfset arguments.attached_file_id = createFileResponse.objectFile.id>
					<cfset arguments.attached_file_name = createFileResponse.objectFile.file_name>

					<cfset response = {result=true, item_id=arguments.item_id, objectFile=#createFileResponse.objectFile#}><!---objectItem=#objectItem#, --->


				<cfelse><!---File insert failed--->

					<cfset error_code = 602>

					<cfthrow errorcode="#error_code#">

				</cfif>

				<cfcatch>

					<cfinclude template="includes/errorHandlerStruct.cfm">

				</cfcatch>
			</cftry>


		<cfreturn response>

	</cffunction>




	<!--- ----------------------------------- changeItemUser -------------------------------------- --->

	<cffunction name="changeItemUser" output="false" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="new_user_in_charge" type="numeric" required="true">

		<cfset var method = "changeItemUser">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif arguments.itemTypeId IS 1><!--- Message --->

				<cfset error_code = 103><!---Access denied--->

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif itemQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = itemQuery.area_id>

			<cfif itemQuery.user_in_charge NEQ user_id>

				<!--- isUserAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

				<cfif isUserAreaResponsible IS false>
					<cfset response = {result=false, item_id=#arguments.item_id#, item_title=#itemQuery.title#, area_id=#area_id#, message="No tiene permiso."}>
					<cfreturn response>
				</cfif>

			</cfif>

			<cfif itemQuery.user_in_charge EQ arguments.new_user_in_charge>

				<cfset response = {result=false, item_id=#arguments.item_id#, item_title=#itemQuery.title#, area_id=#area_id#, message="El usuario seleccionado es el propietario"}>
				<cfreturn response>

			</cfif>

			<cfquery datasource="#client_dsn#" name="changeItemUserInCharge">
				UPDATE #client_abb#_#itemTypeTable#
				SET user_in_charge = <cfqueryparam value="#arguments.new_user_in_charge#" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif isNumeric(itemQuery.attached_file_id) AND itemQuery.attached_file_id GT 0>

				<cfinvoke component="FileManager" method="changeFileUser" returnvariable="changeFileUserResult">
					<cfinvokeargument name="file_id" value="#itemQuery.attached_file_id#">
					<cfinvokeargument name="new_user_in_charge" value="#arguments.new_user_in_charge#">
				</cfinvoke>

				<cfif changeFileUserResult.result IS false>

					<cfreturn changeFileUserResult>

				</cfif>

			</cfif>

			<cfif isNumeric(itemQuery.attached_image_id) AND itemQuery.attached_image_id GT 0>

				<cfinvoke component="FileManager" method="changeFileUser" returnvariable="changeImageUserResult">
					<cfinvokeargument name="file_id" value="#itemQuery.attached_image_id#">
					<cfinvokeargument name="new_user_in_charge" value="#arguments.new_user_in_charge#">
				</cfinvoke>

				<cfif changeImageUserResult.result IS false>

					<cfreturn changeImageUserResult>

				</cfif>

			</cfif>


			<!---Send Alert--->
			<cfinvoke component="AlertManager" method="changeItemUser">
				<cfinvokeargument name="objectItem" value="#itemQuery#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="old_user_id" value="#itemQuery.user_in_charge#">
				<cfinvokeargument name="new_user_id" value="#arguments.new_user_in_charge#">
			</cfinvoke>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, item_id=#arguments.item_id#, item_title=#itemQuery.title#, area_id=#area_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- changeItemArea -------------------------------------- --->

	<cffunction name="changeItemArea" output="false" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">

		<cfset var method = "changeItemArea">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var new_area_type = "">
		<cfset var new_item_position = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif APPLICATION.changeElementsArea IS false>
				<cfthrow message="Función no disponible">
			</cfif>

			<cfif arguments.itemTypeId IS 13><!--- Typologies --->
				<!--- Las tipologías no se pueden cambiar de área porque son usadas en áreas inferiores a la que pertenecen --->
				<cfthrow message="Las tipologías no se pueden cambiar de área">
			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif itemQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = itemQuery.area_id>

			<cfif itemQuery.user_in_charge NEQ user_id>

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			</cfif>

			<cfif itemQuery.area_id EQ arguments.new_area_id>

				<cfset message = "El elemento ya estaba en esta área">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			<cfelse>

				<cfif arguments.itemTypeId IS NOT 11 AND arguments.itemTypeId IS NOT 12 AND arguments.itemTypeId IS NOT 13 AND arguments.itemTypeId IS NOT 17><!---IS NOT table or mailing--->

					<!--- checkAreaAccess --->
					<cfinvoke component="AreaManager" method="checkAreaAccess">
						<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
					</cfinvoke>

				<cfelse>

					<!---checkAreaResponsibleAccess--->
					<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
						<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
					</cfinvoke>

				</cfif>

			</cfif>

			<!--- getAreaType --->
			<cfinvoke component="AreaManager" method="getAreaType" returnvariable="areaTypeResult">
				<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
			</cfinvoke>

			<cfset new_area_type = areaTypeResult.areaType>

			<cfif itemTypeWeb IS false AND len(new_area_type) GT 0>

				<cfset message = "No puede mover este elemento a un área web">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			<cfelseif itemTypeNoWeb IS false AND len(new_area_type) IS 0><!--- Entries, News, Images --->

				<cfset message = "No puede mover este elemento a un área no web">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			</cfif>

			<!--- getArea --->
			<cfinvoke component="AreaManager" method="getArea" returnvariable="areaQuery">
				<cfinvokeargument name="get_area_id" value="#itemQuery.area_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfif areaQuery.read_only IS true>

				<cfset message = "El área de origen es de solo lectura">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			</cfif>

			<!--- getArea --->
			<cfinvoke component="AreaManager" method="getArea" returnvariable="newAreaQuery">
				<cfinvokeargument name="get_area_id" value="#arguments.new_area_id#">
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfif newAreaQuery.read_only IS true>

				<cfset message = "El área de destino es de solo lectura">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			<cfelseif newAreaQuery['item_type_#arguments.itemTypeId#_enabled'] IS false>

				<cfset message = "Tipo de elemento deshabilitado en el área de destino">
				<cfset response = {result=false, message=#message#, item_id=#arguments.item_id#, area_id=#area_id#}>

				<cfreturn response>

			</cfif>

			<cftransaction>

				<cfquery datasource="#client_dsn#" name="changeItemArea">
					UPDATE #client_abb#_#itemTypeTable#
					SET area_id = <cfqueryparam value="#arguments.new_area_id#" cfsqltype="cf_sql_integer">
					<cfif itemQuery.parent_kind EQ "area">
						, parent_id = <cfqueryparam value="#arguments.new_area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!---DELETE ITEM OLD POSITION--->
				<cfinvoke component="AreaItemManager" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				</cfinvoke>

				<cfif itemTypeWeb IS true><!---IS WEB---><!---El orden sólo se utiliza en los elementos web--->

					<!---getItemLastPosition--->
					<cfinvoke component="AreaItemManager" method="getAreaItemsLastPosition" returnvariable="itemLastPosition">
						<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
					</cfinvoke>

					<cfset new_item_position = itemLastPosition+1>

					<!---Insert new position--->
					<cfinvoke component="AreaItemManager" method="insertAreaItemPosition">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
						<cfinvokeargument name="position" value="#new_item_position#">
					</cfinvoke>

				</cfif>

			</cftransaction>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="newItemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif newItemQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<!---Send Alert--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
				<cfinvokeargument name="objectItem" value="#itemQuery#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="action" value="delete">

				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
				<cfinvokeargument name="objectItem" value="#newItemQuery#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="action" value="new">

				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, item_id=#arguments.item_id#, area_id=#area_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>





	<!--- ----------------------- ADD FILE TO ITEM -------------------------------- --->

	<!---Añade un archivo existente (duplicándolo y creando uno nuevo) a un mensaje, noticia, entrada etc.--->

	<cffunction name="addFileToItem" output="false" returntype="query" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="file_type" type="string" required="no" default="file"><!---file/image--->

		<cfset var method = "associateFileToItem">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfset files_table = "files">

			<!---Se duplica el archivo--->
			<cfinvoke component="FileManager" method="duplicateFile" returnvariable="objectFile">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
			</cfinvoke>

			<cfif arguments.file_type NEQ "file">
				<cfset arguments.file_type = "image">
			</cfif>

			<cftransaction>

				<!---Se añade la referencia al mensaje y al archivo--->
				<cfquery datasource="#client_dsn#" name="addFileToItem">
					UPDATE #client_abb#_#itemTypeTable#
					SET attached_#arguments.file_type#_id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">,
					attached_#arguments.file_type#_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
					status = 'ok'
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery datasource="#client_dsn#" name="updateFile">
					UPDATE #client_abb#_#files_table#
					SET
					item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
					item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>


		<cfreturn objectFile>

	</cffunction>



	<!---  ---------------------- getWebItemUrl -------------------------------- --->

	<cffunction name="getWebItemUrl" returntype="string" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="true">

		<cfset var method = "getWebItemUrl">
		<cfset var item_url = "">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfset item_url = "#APPLICATION.webUrl##lCase(itemTypeNameEs)#.cfm?iid=#arguments.item_id#">

		<cfreturn item_url>
	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  ---------------------- postItemToTwitter -------------------------------- --->

	<cffunction name="postItemToTwitter" returntype="void" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="content" type="string" required="no">

		<cfset var method = "postItemToTwitter">
		<cfset var tweet_content = "">
		<cfset var tweet_url = "">

			<cfinvoke component="AreaItemManager" method="getWebItemUrl" returnvariable="tweet_url">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>

			<cfif NOT isDefined("arguments.content") OR len(arguments.content) IS 0>
				<cfinvoke component="AreaItemManager" method="getItem" returnvariable="getItemResponse">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

					<cfinvokeargument name="return_type" value="object">
				</cfinvoke>

				<cfset objectItem = getItemResponse.item>

				<cfif len(objectItem.title) GT 119><!---Se deben reservar 20 caracteres + 1 espacio para la URL (la URL abreviada ocupa 20 caracteres)--->
					<cfset tweet_content = left(objectItem.title,116)&"...">
				<cfelse>
					<cfset tweet_content = objectItem.title>
				</cfif>

				<cfset tweet_content = tweet_content&" "&tweet_url>
			<cfelse>
				<cfset tweet_content = arguments.content&" "&tweet_url>
			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/TwitterManager" method="sendTweet">
				<cfinvokeargument name="content" value="#tweet_content#">
			</cfinvoke>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  -------------------GET ITEM ROOT----------------------   --->
	<cffunction name="getItemRoot" returntype="query" output="false" access="public">
		<cfargument name="item_id" required="yes" type="numeric">
		<cfargument name="itemTypeId" required="yes" type="numeric">

		<cfset var method = "getItemRoot">

			<cfinclude template="includes/functionStart.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemRoot" returnvariable="getItemRootResult">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfreturn getItemRootResult>

	</cffunction>



	<!---  ---------------------- getItem -------------------------------- --->

	<cffunction name="getItem" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="return_type" type="string" required="no" default="xml">
		<cfargument name="status" type="string" required="false" default="ok"><!--- ok/pending/deleted --->

		<cfargument name="with_lock" type="boolean" required="false" default="false">
		<cfargument name="with_categories" type="boolean" required="false" default="false">

		<cfset var method = "getItem">

		<cfset var response = structNew()>

		<cfset var id = arguments.item_id>
		<cfset var area_id = "">
		<cfset var resultItem = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/functionStart.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="selectItemQuery">
				<cfinvokeargument name="item_id" value="#id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">
				<cfinvokeargument name="status" value="#arguments.status#">

				<cfinvokeargument name="with_lock" value="#arguments.with_lock#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif selectItemQuery.recordCount GT 0>

				<cfset area_id = selectItemQuery.area_id>

				<cfif (arguments.itemTypeId IS NOT 11 AND arguments.itemTypeId IS NOT 12 AND arguments.itemTypeId IS NOT 13) OR selectItemQuery.general IS NOT true><!---No es tabla--->

					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				</cfif>

				<cfif arguments.return_type EQ "query">

					<cfset resulItem = selectItemQuery>

				<cfelse>

					<cfinvoke component="AreaItemManager" method="objectItem" returnvariable="resulItem">
						<cfinvokeargument name="id" value="#selectItemQuery.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parent_id" value="#selectItemQuery.parent_id#">
						<cfinvokeargument name="parent_kind" value="#selectItemQuery.parent_kind#">
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="user_in_charge" value="#selectItemQuery.user_in_charge#">
						<cfinvokeargument name="creation_date" value="#selectItemQuery.creation_date#">
						<cfinvokeargument name="attached_file_id" value="#selectItemQuery.attached_file_id#">
						<cfif selectItemQuery.attached_file_name EQ "NULL">
							<cfinvokeargument name="attached_file_name" value="-">
						<cfelse>
							<cfinvokeargument name="attached_file_name" value="#selectItemQuery.attached_file_name#">
						</cfif>
						<cfinvokeargument name="link" value="#selectItemQuery.link#">
						<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7>
							<cfinvokeargument name="link_target" value="#selectItemQuery.link_target#">
						</cfif>
						<cfif arguments.itemTypeId NEQ messageTypeId>
							<cfinvokeargument name="last_update_date" value="#selectItemQuery.last_update_date#">
							<cfinvokeargument name="attached_image_id" value="#selectItemQuery.attached_image_id#">
							<cfif selectItemQuery.attached_image_name EQ "NULL">
								<cfinvokeargument name="attached_image_name" value="-">
							<cfelse>
								<cfinvokeargument name="attached_image_name" value="#selectItemQuery.attached_image_name#">
							</cfif>

							<!---
							<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 3 OR arguments.itemTypeId IS 4><!---Entries, Links, News--->
								<cfinvokeargument name="position" value="#selectItemQuery.position#">
							</cfif>--->

							<cfif arguments.itemTypeId EQ 5 OR arguments.itemTypeId EQ 6><!---Events, Tasks--->
								<cfinvokeargument name="start_date" value="#selectItemQuery.start_date#">
								<cfinvokeargument name="end_date" value="#selectItemQuery.end_date#">
								<cfif arguments.itemTypeId EQ 5><!--- Event --->
									<cfinvokeargument name="start_time" value="#selectItemQuery.start_time#">
									<cfinvokeargument name="end_time" value="#selectItemQuery.end_time#">
									<cfinvokeargument name="place" value="#selectItemQuery.place#">
								<cfelse><!--- Task --->
									<cfinvokeargument name="recipient_user" value="#selectItemQuery.recipient_user#">
									<cfinvokeargument name="recipient_user_full_name" value="#selectItemQuery.recipient_user_full_name#">
									<cfinvokeargument name="done" value="#selectItemQuery.done#">
									<cfinvokeargument name="estimated_value" value="#selectItemQuery.estimated_value#">
									<cfinvokeargument name="real_value" value="#selectItemQuery.real_value#">
								</cfif>
							</cfif>
						</cfif>
						<cfif arguments.itemTypeId IS 2>
						<cfinvokeargument name="display_type_id" value="#selectItemQuery.display_type_id#">
						</cfif>
						<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 4 OR arguments.itemTypeId IS 5>
						<cfinvokeargument name="iframe_url" value="#selectItemQuery.iframe_url#">
						<cfinvokeargument name="iframe_display_type_id" value="#selectItemQuery.iframe_display_type_id#">
						</cfif>
						<cfinvokeargument name="attached_file_type" value="#selectItemQuery.file_type#">
						<cfinvokeargument name="title" value="#selectItemQuery.title#">
						<cfinvokeargument name="description" value="#selectItemQuery.description#">
						<cfinvokeargument name="user_full_name" value="#selectItemQuery.family_name# #selectItemQuery.user_name#">
						<cfinvokeargument name="user_image_type" value="#selectItemQuery.user_image_type#">
						<cfif arguments.itemTypeId IS 7 OR arguments.itemTypeId IS 8><!---Consultations, PubMed comments--->
						<cfinvokeargument name="identifier" value="#selectItemQuery.identifier#">
						<cfif arguments.itemTypeId IS 7>
							<cfinvokeargument name="state" value="#selectItemQuery.state#">
						</cfif>
						</cfif>

						<cfinvokeargument name="return_type" value="#arguments.return_type#">
					</cfinvoke>

				</cfif>

				<cfif itemTypeId IS 7><!---Consultations--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="addReadToItem">
						<cfinvokeargument name="item_id" value="#id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="user_id" value="#user_id#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif selectItemQuery.user_in_charge NEQ user_id>

						<cfif selectItemQuery.state EQ "created">

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="updateItemState">
								<cfinvokeargument name="item_id" value="#id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="state" value="read">
								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						<cfelseif NOT isDate(selectItemQuery.read_date)>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="setItemReadDate">
								<cfinvokeargument name="item_id" value="#id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						</cfif>

					</cfif>

				</cfif>

				<cfif arguments.with_categories IS true>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="categoriesQuery">
						<cfinvokeargument name="item_id" value="#id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfset response = {result=true, item=#resulItem#, categories=#categoriesQuery#}>

				<cfelse>

					<cfset response = {result=true, item=#resulItem#}>

				</cfif>



			<cfelse><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  -------------------------------------------------------------------------------- --->


	<!--- ----------------------------------- getEmptyItem ----------------------------------  --->

	<cffunction name="getEmptyItem" output="false" access="public" returntype="struct">
		<cfargument name="itemTypeId" type="numeric" required="true">

		<cfset var method = "getEmptyItem">

		<cfset var response = structNew()>

		<cfset var objectItem = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!---<cfquery name="getEmptyItem" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#_items
				WHERE item_id = -1;
			</cfquery>--->

			<cfset objectItem.title = "">
			<cfset objectItem.description = "">
			<cfset objectItem.attached_file_name = "">
			<cfset objectItem.attached_image_name = "">

			<cfset objectItem.display_type_id = "">
			<cfset objectItem.iframe_url = "">
			<cfset objectItem.iframe_display_type_id = 1>

			<cfif itemTypeId IS 3>
				<cfset objectItem.link = "http://">
			<cfelse>
				<cfset objectItem.link = "">
			</cfif>
			<cfset objectItem.link_target = "_blank">

			<cfset cur_date = DateFormat(now(), "DD-MM-YYYY")>

			<cfif itemTypeWeb IS true><!---WEB--->

				<cfset objectItem.publication_date = cur_date&" "&timeFormat(now(), "HH:mm:ss")>
				<!---<cfset objectItem.publication_time = timeFormat(now(), "HH:mm")>--->
				<cfset objectItem.publication_validated = true>

				<cfif itemTypeId IS 4><!---News--->
					<cfset objectItem.creation_date = cur_date>
				</cfif>

				<cfif itemTypeId IS 4 OR itemTypeId IS 5 OR itemTypeId IS 8>
					<cfset objectItem.url_id = "">
				</cfif>

			</cfif>

			<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->
				<!--- <cfset cur_date = DateFormat(now(), "DD-MM-YYYY")> --->

				<cfset objectItem.start_date = cur_date>
				<cfset objectItem.end_date = cur_date>

				<cfif itemTypeId IS 5><!--- Events --->
					<cfset objectItem.start_time = "00:00">
					<cfset objectItem.end_time = "00:00">
					<cfset objectItem.place = "">
				<cfelse>
					<cfset objectItem.recipient_user = "">
					<cfset objectItem.recipient_user_full_name = "">
					<cfset objectItem.done = "">
					<cfset objectItem.estimated_value = 0>
					<cfset objectItem.real_value = 0>
				</cfif>
		 	</cfif>

		 	<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
		 		<cfset objectItem.price = 0>
		 	</cfif>

			<cfif itemTypeId IS 7 OR itemTypeId IS 8><!---Consultations, PubMed comments--->
				<cfset objectItem.identifier = "">
			</cfif>

			<cfif itemTypeId IS 20><!--- DoPlanning item --->
				<cfset objectItem.locked = false>
				<cfset objectItem.area_editable = false>
			</cfif>

			<cfif itemTypeId IS 17><!---Mailings--->
				<cfset objectItem.email_addresses = "">
			</cfif>

			<cfset objectItem.sub_type_id = -1>

			<cfset response = {result=true, item=#objectItem#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  -------------------------------------------------------------------------------- --->



	<!---  ---------------------- getAreaItemsLastPosition -------------------------------- --->

	<cffunction name="getAreaItemsLastPosition" returntype="numeric" access="package">
		<cfargument name="area_id" type="numeric" required="yes">
		<!---<cfargument name="itemTypeId" type="numeric" required="yes">--->

		<cfset var method = "getAreaItemsLastPosition">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItemsLastPosition" returnvariable="getLastPositionResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>--->

			<cfquery name="areaItemsPositionQuery" datasource="#client_dsn#">
				SELECT MAX(position) AS max_position
				FROM #client_abb#_items_position
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

		<cfif isNumeric(areaItemsPositionQuery.max_position)>
			<cfreturn areaItemsPositionQuery.max_position>
		<cfelse>
			<cfreturn 0>
		</cfif>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->


	<!---  ---------------------- insertAreaItemPosition -------------------------------- --->

	<cffunction name="insertAreaItemPosition" returntype="void" access="package">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="position" type="numeric" required="true">

		<cfset var method = "insertAreaItemPosition">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="insertAreaItemPosition" datasource="#client_dsn#">
				INSERT INTO #client_abb#_items_position
				SET item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
				item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">,
				area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
				position = <cfqueryparam value="#arguments.position#" cfsqltype="cf_sql_integer">;
			</cfquery>


	</cffunction>


	<!---  ---------------------- deleteItemPosition -------------------------------- --->

	<cffunction name="deleteItemPosition" returntype="void" access="package">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfset var method = "deleteItemPosition">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="deleteItemPosition">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

	</cffunction>


	<!---  ---------------------- changeAreaItemPosition -------------------------------- --->

	<cffunction name="changeAreaItemPosition" returntype="struct" access="public">
		<cfargument name="a_item_id" type="numeric" required="true">
		<cfargument name="a_itemTypeId" type="numeric" required="true">
		<cfargument name="b_item_id" type="numeric" required="true">
		<cfargument name="b_itemTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="action" type="string" required="true"><!---increase/decrease--->

		<cfset var method = "changeAreaItemPosition">

		<cfset var response = structNew()>

		<cfset var a_itemNewPosition = "">
		<cfset var b_itemNewPosition = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfset itemTypeId = arguments.a_itemTypeId>
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getItem" datasource="#client_dsn#">
				SELECT items_position.position
				FROM #client_abb#_#itemTypeTable# AS items
				INNER JOIN #client_abb#_items_position AS items_position
				ON items.id = items_position.item_id AND items_position.item_type_id = <cfqueryparam value="#arguments.a_itemTypeId#" cfsqltype="cf_sql_integer">
				AND items_position.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
				WHERE items.id = <cfqueryparam value="#arguments.a_item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getItem.recordCount GT 0>

				<!---<cfset area_id = getItem.area_id>--->

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfset b_itemNewPosition = getItem.position>

				<cfset itemTypeId = arguments.b_itemTypeId>
				<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

				<cfquery name="getOtherItem" datasource="#client_dsn#">
					SELECT items.id, items_position.position
					FROM #client_abb#_#itemTypeTable# AS items
					INNER JOIN #client_abb#_items_position AS items_position
					ON items.id = items_position.item_id AND items_position.item_type_id = <cfqueryparam value="#arguments.b_itemTypeId#" cfsqltype="cf_sql_integer">
					AND items_position.area_id =  <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					WHERE items.id = <cfqueryparam value="#arguments.b_item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>


				<cfif getOtherItem.recordCount GT 0>

					<cfset a_itemNewPosition = getOtherItem.position>

					<cftransaction>

						<cfquery name="updateOtherItemQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_items_position
							SET position = <cfqueryparam value="#b_itemNewPosition#" cfsqltype="cf_sql_integer">
							WHERE item_id = <cfqueryparam value="#arguments.b_item_id#" cfsqltype="cf_sql_integer">
							AND item_type_id = <cfqueryparam value="#arguments.b_itemTypeId#" cfsqltype="cf_sql_integer">
							AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<cfquery name="updateItemQuery" datasource="#client_dsn#">
							UPDATE #client_abb#_items_position
							SET position = <cfqueryparam value="#a_itemNewPosition#" cfsqltype="cf_sql_integer">
							WHERE item_id = <cfqueryparam value="#arguments.a_item_id#" cfsqltype="cf_sql_integer">
							AND item_type_id = <cfqueryparam value="#arguments.a_itemTypeId#" cfsqltype="cf_sql_integer">
							AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cftransaction>

				<cfelse>

					<cfset response = {result=false, message="Error, no se ha encontrado el elemento por el que hay que cambiar el orden"}>

					<cfreturn response>

				</cfif>

				<cfinclude template="includes/logRecord.cfm">

				<cfset response = {result=true, area_id=arguments.area_id}>

			<cfelse>

				<cfset response = {result=false, message="Error, no se ha encontrado el elemento"}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!---  ---------------------- changeAreaItemState -------------------------------- --->

	<cffunction name="changeAreaItemState" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="state" type="string" required="yes"><!---closed--->

		<cfset var method = "changeAreaItemState">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getItem" datasource="#client_dsn#">
				SELECT area_id, state, parent_kind, parent_id, user_in_charge
				FROM #client_abb#_#itemTypeTable#
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getItem.recordCount GT 0 AND arguments.itemTypeId IS 7>

				<cfset area_id = getItem.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfif getItem.user_in_charge EQ user_id AND getItem.parent_kind EQ "area" AND getItem.state NEQ "closed" AND arguments.state EQ "closed"><!---Solo se pueden cerrar las consultas por el creador--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="changeItemsState">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="state" value="#arguments.state#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<!---<cfinvoke component="AreaItemManager" method="getItem" returnvariable="getItemResponse">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="return_type" value="object">
					</cfinvoke>

					<cfset objectItem = getItemResponse.item>--->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parse_dates" value="true">
						<cfinvokeargument name="published" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<!---Alert--->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="close">

						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfinclude template="includes/logRecord.cfm">

					<cfset response = {result=true, area_id=getItem.area_id, message="#itemTypeNameEs# cerrada"}>

				<cfelse>

					<cfset response = {result=false, message="Error: estado de #itemTypeNameEs# incorrecto"}>

				</cfif>

			<cfelse>

				<cfset response = {result=false, message="Error: no se ha encontrado la #itemTypeNameEs#"}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  ---------------------- changeAreaItemDone -------------------------------- --->

	<cffunction name="changeAreaItemDone" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="done" type="boolean" required="yes"><!---1--->

		<cfset var method = "changeAreaItemDone">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getItem" datasource="#client_dsn#">
				SELECT area_id, done, user_in_charge, recipient_user
				FROM #client_abb#_#itemTypeTable#
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getItem.recordCount GT 0 AND arguments.itemTypeId IS 6>

				<cfset area_id = getItem.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfif (getItem.user_in_charge EQ user_id OR getItem.recipient_user EQ user_id) AND getItem.done NEQ arguments.done AND getItem.done IS 0 AND arguments.done IS 1><!---Solo se pueden marcar como hechas--->

					<cfquery name="changeItemDone" datasource="#client_dsn#">
						UPDATE #client_abb#_#itemTypeTable#
						SET	done = <cfqueryparam value="#arguments.done#" cfsqltype="cf_sql_bit">,
						last_update_date = NOW(),
						last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">
						WHERE
						id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parse_dates" value="true">
						<cfinvokeargument name="published" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<!---Alert--->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="done">

						<cfinvokeargument name="user_id" value="#SESSION.user_id#">
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfinclude template="includes/logRecord.cfm">

					<cfset response = {result=true, area_id=getItem.area_id, message="#itemTypeNameEs# marcada como realizada"}>

				<cfelse>

					<cfset response = {result=false, message="Error, estado de #itemTypeNameEs# incorrecto"}>

				</cfif>

			<cfelse>

				<cfset response = {result=false, message="Error, no se ha encontrado la #itemTypeNameEs#"}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->


	<!---  ---------------------- changeItemPublicationValidation -------------------------------- --->

	<cffunction name="changeItemPublicationValidation" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="validate" type="boolean" required="true">

		<cfset var method = "changeItemPublicationValidation">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getItem" datasource="#client_dsn#">
				SELECT area_id, publication_validated
				FROM #client_abb#_#itemTypeTable#
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getItem.recordCount GT 0 AND itemTypeWeb IS true>

				<cfset area_id = getItem.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

				<!--- isUserAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

				<cfif APPLICATION.publicationValidation IS true AND isUserAreaResponsible IS true><!---Si APPLICATION.publicationValidation es false es que no se puede publicar y despublicar--->

					<cfquery name="changeItemPublication" datasource="#client_dsn#">
						UPDATE #client_abb#_#itemTypeTable#
						SET	publication_validated = <cfqueryparam value="#arguments.validate#" cfsqltype="cf_sql_bit">
							<cfif arguments.validate IS true AND getItem.publication_validated IS false>
								, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
								, publication_validated_date = NOW()
							</cfif>
						WHERE
						id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfinclude template="includes/logRecord.cfm">

					<cfset response = {result=true, area_id=getItem.area_id}>

				<cfelse>

					<cfset response = {result=false, message="Error, no tiene permiso para publicar en esta área"}>

				</cfif>

			<cfelse>

				<cfset response = {result=false, message="Error, no se ha encontrado el elemento"}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------- --->



	<!---  ---------------------- changeAreaItemLock -------------------------------- --->

	<cffunction name="changeAreaItemLock" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="lock" type="boolean" required="true">

		<cfset var method = "changeAreaItemLock">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif itemQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = itemQuery.area_id>

			<cfif itemQuery.locked EQ arguments.lock>

				<cfif arguments.lock IS true>

					<cfthrow message="Error, el documento ya está bloqueado.">

				<cfelse>

					<cfthrow message="Error, el documento ya está desbloqueado.">

				</cfif>

			<cfelseif arguments.lock IS false AND itemQuery.lock_user_id NEQ user_id>

				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			<cfelse>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			</cfif>

			<!---<cfif itemQuery.in_approval IS true>

				<cfset response = {result=false, item_id=#arguments.item_id#, message="No se puede bloquear un documento en proceso de aprobación."}>
				<cfreturn response>

			</cfif>--->

			<cftransaction>

				<cfquery name="addItemLock" datasource="#client_dsn#">
					INSERT INTO `#client_abb#_#itemTypeTable#_locks`
					SET item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
					user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					lock_date = NOW(),
					`lock` = <cfqueryparam value="#arguments.lock#" cfsqltype="cf_sql_bit">;
				</cfquery>

				<cfquery name="changeAreaItemLock" datasource="#client_dsn#">
					UPDATE `#client_abb#_#itemTypeTable#`
					SET	locked = <cfqueryparam value="#arguments.lock#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">

			<!--- Alert --->
			<!---
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newItem">
				<cfinvokeargument name="objectItem" value="#itemQuery#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfinvokeargument name="user_id" value="#user_id#">
				<cfif arguments.lock IS true>
					<cfinvokeargument name="action" value="lock">
				<cfelse>
					<cfinvokeargument name="action" value="unlock">
				</cfif>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>--->

			<cfset response = {result=true, item_id=#arguments.item_id#, lock=arguments.lock}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->




	<!---  ---------------------- sendAreaItem -------------------------------- --->

	<cffunction name="sendAreaItem" returntype="struct" access="public">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="send_to_test_users" type="boolean" required="false">

		<cfset var method = "sendAreaItem">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="parse_dates" value="false">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif itemQuery.recordCount IS 0><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = itemQuery.area_id>

			<!--- isUserAreaResponsible --->
			<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<!---checkAreaResponsibleAccess--->
			<cfif isUserAreaResponsible IS false>

				<cfset error_code = 105>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif itemQuery.state EQ SENT_STATE>

				<cfset response = {result=false, message="No se puede enviar de nuevo, el boletín ya ha sido enviado."}>
				<cfreturn response>

			<cfelse>

				<cfif itemQuery.user_in_charge NEQ SESSION.user_id>

					<cfset response = {result=false, message="No tiene permiso para enviar el boletín."}>
					<cfreturn response>

				</cfif>

			</cfif>


			<!---Mailing--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/MailingManager" method="sendMailing">
				<cfinvokeargument name="objectItem" value="#itemQuery#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">

				<cfinvokeargument name="send_to_area_users" value="true">
				<cfinvokeargument name="send_to_test_users" value="#arguments.send_to_test_users#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>


			<cfquery name="changeAreaState" datasource="#client_dsn#">
				UPDATE `#client_abb#_#itemTypeTable#`
				SET	state = <cfqueryparam value="#SENT_STATE#" cfsqltype="cf_sql_varchar">
				, last_update_date = NOW()
				, last_update_user_id = <cfqueryparam value="#SESSION.user_id#" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
			</cfquery>


			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, item_id=#arguments.item_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->






	<!--- ----------------------- DELETE AREA ITEMS -------------------------------- --->

	<cffunction name="deleteAreaItems" returntype="void" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="moveToBin" type="boolean" required="false" default="false">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="includes/checkAreaAdminAccess.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<!--- --------------DELETE AREA ITEMS------------------------- --->
		<cfquery name="itemsQuery" datasource="#client_dsn#">
			SELECT items.id, items.status, items_deleted.delete_user_id
			FROM #client_abb#_#itemTypeTable# AS items
			LEFT JOIN #client_abb#_items_deleted AS items_deleted
			ON items.id = items_deleted.item_id
			AND items_deleted.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
			WHERE items.area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
			AND ( items.status = "ok" OR items.status = "deleted" );
		</cfquery>

		<cfif itemsQuery.recordCount GT 0>

			<cfloop query="itemsQuery">

				<cfif itemsQuery.status IS "ok">

					<cfinvoke component="AreaItemManager" method="deleteItem" returnvariable="deleteItemResult">
						<cfinvokeargument name="item_id" value="#itemsQuery.id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="moveToBin" value="#arguments.moveToBin#">
					</cfinvoke>

					<cfif deleteItemResult.result IS false>
						<cfthrow message="#deleteItemResult.message#">
					</cfif>

				<cfelseif itemsQuery.status IS "deleted">

					<cfif NOT IsNumeric(itemsQuery.delete_user_id)>
						<cfthrow message="ITEMS ID: #itemsQuery.id#">
					</cfif>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/BinManager" method="deleteBinItem" returnvariable="deleteBinItemResponse">
						<cfinvokeargument name="item_id" value="#itemsQuery.id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="delete_user_id" value="#itemsQuery.delete_user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif deleteBinItemResponse.result IS false>
						<cfthrow message="#deleteBinItemResponse.message#">
					</cfif>

				</cfif>

			</cfloop>

		</cfif>

	</cffunction>



	<!--- ----------------------- DELETE USER ITEMS -------------------------------- --->

	<cffunction name="deleteUserItems" returntype="void" access="public">
		<cfargument name="delete_user_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

		<!--- checkUserAdminAccess --->
		<cfinvoke component="#APPLICATION.componentsPath#/UserManager" method="isUserUserAdministrator" returnvariable="isUserUserAdministratorResponse">
			<cfinvokeargument name="check_user_id" value="#SESSION.user_id#">
		</cfinvoke>

		<cfif isUserUserAdministratorResponse.result IS false OR isUserUserAdministratorResponse.isUserAdministrator IS false>

			<cfset error_code = 106>

			<cfthrow errorcode="#error_code#">

		</cfif>

		<!--- --------------DELETE USER ITEMS------------------------- --->
		<cfquery name="userItemsQuery" datasource="#client_dsn#">
			SELECT id
			FROM #client_abb#_#itemTypeTable#
			WHERE user_in_charge = <cfqueryparam value="#arguments.delete_user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfif userItemsQuery.recordCount GT 0>

			<cfloop query="userItemsQuery">

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItem" returnvariable="deleteItemResult">
					<cfinvokeargument name="item_id" value="#userItemsQuery.id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="moveToBin" value="false">

					<cfinvokeargument name="delete_user_id" value="#SESSION.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif deleteItemResult.result IS false>
					<cfthrow message="#deleteItemResult.message#">
				</cfif>

			</cfloop>

		</cfif>

	</cffunction>



	<!--- ----------------------- DELETE ITEM -------------------------------- --->

	<cffunction name="deleteItem" output="false" access="public" returntype="struct">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="moveToBin" type="boolean" required="false" default="true">

		<cfset var method = "deleteItem">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var itemQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!--- getItem --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif itemQuery.recordCount GT 0>

				<!---checkAreaAccess--->
				<cfset area_id = itemQuery.area_id>

				<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="canUserDeleteItem" returnvariable="canUserDeleteItemResponse">
					<cfinvokeargument name="item_id" value="#arguments.item_id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="itemQuery" value="#itemQuery#">
					<cfinvokeargument name="area_id" value="#itemQuery.area_id#">
				</cfinvoke>

				<cfif canUserDeleteItemResponse.result IS false>

					<cfset canUserDeleteItemResponse.item_title = itemQuery.title>
					<cfreturn canUserDeleteItemResponse>

				<cfelse>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItem" returnvariable="response">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="moveToBin" value="#arguments.moveToBin#">
						<cfinvokeargument name="itemQuery" value="#itemQuery#">

						<cfinvokeargument name="delete_user_id" value="#SESSION.user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			<cfelse><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>


			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ----------------------------------------------------------------------- --->



	<!--- ------------------------------------- canUserDeleteItem -------------------------------------  --->

	<cffunction name="canUserDeleteItem" output="false" access="public" returntype="struct">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemQuery" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfset var method = "canUserDeleteItem">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfif itemQuery.recordCount GT 0>

				<cfif itemTypeId IS 11 OR itemTypeId IS 12 OR itemTypeId IS 13 OR itemTypeId IS 16 OR itemTypeId IS 17><!---List, Forms, Typologies, Users typologies, Mailings--->

					<!--- isUserAreaResponsible --->
					<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

					<cfif isUserAreaResponsible IS false>

						<cfset response = {result=false, item_id=#arguments.item_id#, message="No puede eliminar el elemento, no tiene permiso de responsable del área."}>
						<cfreturn response>

					</cfif>

					<cfif itemTypeId IS 13><!--- Typology --->

						<!--- Get typology files --->
						<cfquery name="tableFilesQuery" datasource="#client_dsn#">
							SELECT id
							FROM #client_abb#_files
							WHERE #itemTypeName#_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<cfif tableFilesQuery.recordCount GT 0>

							<cfset response = {result=false, item_id=#arguments.item_id#, message="No se puede borrar una tipología que está usada en archivos. Debe eliminar los archivos o cambiar su tipología para poder eliminarla."}>
							<cfreturn response>

						</cfif>

					<cfelseif itemTypeId IS 16><!--- Users typology --->

						<!--- Get typology users --->
						<cfquery name="usersTypologyQuery" datasource="#client_dsn#">
							SELECT id
							FROM #client_abb#_users
							WHERE typology_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<cfif usersTypologyQuery.recordCount GT 0>

							<cfset response = {result=false, item_id=#arguments.item_id#, message="No se puede borrar una tipología que está usada en usuarios. Debe eliminar los usuarios o cambiar su tipología por otra para poder eliminarla."}>
							<cfreturn response>

						</cfif>

					</cfif>


				</cfif>

				<cfif SESSION.client_administrator EQ SESSION.user_id>

					<cfset access_result = true>

				<cfelse>

					<!--- canUserAccessToArea --->
					<cfinvoke component="AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>
					
				</cfif>

				<cfif access_result IS false>

					<cfset response = {result=false, item_id=#arguments.item_id#, message="No puede eliminar el elemento, no tiene acceso al área."}>
					<cfreturn response>

				<cfelse>

					<cfif ( itemQuery.user_in_charge NEQ user_id ) OR ( arguments.itemTypeId IS 7 AND itemQuery.state NEQ "created" )><!---El usuario del item no es el mismo que el que intenta eliminar o es una interconsulta en estado enviada--->

						<!---Las consultas solo se pueden eliminar si están en estado creadas (enviadas)
						Los administradores sí pueden borrar las consultas cuando borran un área--->

						<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="isUserAreaAdministrator" returnvariable="isAdministratorResponse">
							<cfinvokeargument name="area_id" value="#area_id#"/>
							<cfinvokeargument name="user_id" value="#SESSION.user_id#"/>
						</cfinvoke>

						<cfif isAdministratorResponse.isUserAdministrator IS false>

							<cfset response = {result=false, item_id=#arguments.item_id#, message="No puede eliminar el elemento, no tiene permiso."}>
							<cfreturn response>

						</cfif>

					</cfif>

				</cfif>


			<cfelse><!---Item does not exist--->

				<cfset response = {result=false, item_id=#arguments.item_id#, message="Elemento no encontrado."}>
				<cfreturn response>

			</cfif>

			<cfset response = {result=true, item_id=#arguments.item_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------- DELETE ITEM ATTACHED FILE -------------------------------- --->

	<cffunction name="deleteItemAttachedFile" returntype="struct" access="public">
		<cfargument name="item_id" type="string" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">

		<cfargument name="file_type" type="string" required="true"><!--- file / image --->

		<cfset var method = "deleteItemAttachedFile">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var area_type = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="getItemQuery">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getItemQuery.recordCount GT 0>

				<!---checkAreaAccess--->
				<cfset area_id = getItemQuery.area_id>

				<cfinclude template="includes/checkAreaAccess.cfm">

				<cfif getItemQuery.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que intenta modificar--->

					<cfinvoke component="AreaManager" method="getAreaType" returnvariable="areaTypeResult">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

					<cfset area_type = areaTypeResult.areaType>

					<!---Si el área es web o intranet, los items pueden modificarlos todos los que tengan acceso a ese área--->
					<cfif area_type NEQ "web" AND area_type NEQ "intranet">

						<cfset error_code = 103><!---Access denied--->

						<cfthrow errorcode="#error_code#">

					</cfif>
				</cfif>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItemAttachedFile">
					<cfinvokeargument name="item_id" value="#getItemQuery.id#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="itemQuery" value="#getItemQuery#">
					<cfinvokeargument name="forceDeleteVirus" value="false">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="area_id" value="#area_id#">

					<cfinvokeargument name="file_type" value="#arguments.file_type#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset response = {result=true, item_id=#arguments.item_id#}>

			<cfelse><!---Item does not exist--->

				<cfset error_code = 501>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ---------------------------------------------------------------------------------- --->


	<!--- ------------------------- GET SUB ITEMS ------------------------------------------ --->
	<cffunction name="getSubItems" returntype="string" access="public">
		<cfargument name="item_id" type="String" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="listFormat" type="boolean" required="yes">
		<cfargument name="format_content" type="string" required="no" default="default"><!---default/all--->

		<cfset var method = "getSubItems">


			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">


			<cfquery name="getSubItemsQuery" datasource="#client_dsn#" result="result">
				SELECT items.id, title, user_in_charge, attached_file_name, attached_file_id, family_name, items.creation_date AS item_creation_date, users.name AS user_name, users.image_type AS user_image_type
				<cfif arguments.itemTypeId NEQ 1>
				, attached_image_id
				</cfif>
				<cfif arguments.itemTypeId IS 7><!---Consultations--->
				, state, identifier
				</cfif>
				<cfif arguments.format_content EQ "ALL">
				, parent_id, parent_kind, description
				</cfif>
				FROM #client_abb#_#itemTypeTable# AS items, #client_abb#_users AS users
				WHERE parent_id=<cfqueryparam value = "#item_id#" CFSQLType = "CF_SQL_Integer">
				AND items.user_in_charge = users.id
				AND items.parent_kind='#itemTypeName#'
				AND items.status='ok'
				ORDER BY items.creation_date DESC;
			</cfquery>

			<cfif getSubItemsQuery.recordCount GT 0>
				<cfset xmlObject=''>

					<cfloop query="getSubItemsQuery">

						<!--- TREE FORMAT --->
						<cfif listFormat NEQ true>
							<cfinvoke component="AreaItemManager" method="getSubItems" returnvariable="resultSubItems">
								<cfinvokeargument name="item_id" value="#getSubItemsQuery.id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="listFormat" value="#listFormat#">
								<cfinvokeargument name="format_content" value="#format_content#">
							</cfinvoke>

						<cfelse>

							<cfset resultSubItems = "">

						</cfif>

						<cfinvoke component="AreaItemManager" method="objectItem" returnvariable="xmlResultItem">
							<cfinvokeargument name="id" value="#getSubItemsQuery.id#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
							<cfinvokeargument name="title" value="#getSubItemsQuery.title#">
							<cfinvokeargument name="user_in_charge" value="#getSubItemsQuery.user_in_charge#">
							<cfinvokeargument name="creation_date" value="#getSubItemsQuery.item_creation_date#">
							<cfinvokeargument name="attached_file_name" value="#getSubItemsQuery.attached_file_name#">
							<cfinvokeargument name="attached_file_id" value="#getSubItemsQuery.attached_file_id#">
							<cfif arguments.itemTypeId NEQ 1>
								<cfinvokeargument name="attached_image_id" value="#getSubItemsQuery.attached_image_id#">
							</cfif>
							<cfinvokeargument name="user_full_name" value="#getSubItemsQuery.family_name# #getSubItemsQuery.user_name#">
							<cfinvokeargument name="user_image_type" value="#getSubItemsQuery.user_image_type#">

							<cfif arguments.itemTypeId IS 7><!---Consultations--->
								<cfinvokeargument name="state" value="#getSubItemsQuery.state#">
								<cfinvokeargument name="identifier" value="#getSubItemsQuery.identifier#">
							</cfif>

							<cfif format_content EQ "all">
								<!---<cfinvokeargument name="area_name" value="#getSubItemsQuery.area_name#">--->
								<cfinvokeargument name="parent_id" value="#getSubItemsQuery.parent_id#">
								<cfinvokeargument name="parent_kind" value="#getSubItemsQuery.parent_kind#">
								<cfinvokeargument name="description" value="#getSubItemsQuery.description#">
							</cfif>

							<cfif listFormat NEQ true>
								<cfinvokeargument name="sub_items" value="#resultSubItems#">
							</cfif>

							<cfinvokeargument name="tree_mode" value="true"><!---Esto hace que se pasen los elementos del mensaje como atributos--->

							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>

						<cfset xmlObject = xmlObject&xmlResultItem>

						<cfif listFormat EQ true>
							<cfinvoke component="AreaItemManager" method="getSubItems" returnvariable="resultSubItems">
								<cfinvokeargument name="item_id" value="#getSubItemsQuery.id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="listFormat" value="#listFormat#">
								<cfinvokeargument name="format_content" value="#format_content#">
							</cfinvoke>

							<cfset xmlObject = xmlObject&resultSubItems>
						</cfif>

					</cfloop>

				<cfelse>
					<cfset xmlObject=''>
			</cfif>

			<cfreturn "#xmlObject#">

	</cffunction>
	<!--- -----------------------------------------------------------------------------------------  --->



	<!--- ------------------------- GET SUB ITEMS ARRAY ------------------------------------------ --->
	<cffunction name="getSubItemsArray" returntype="array" access="public">
		<cfargument name="item_id" type="String" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="format_content" type="string" required="no" default="default">
		<cfargument name="arrayItems" type="array" required="yes">
		<cfargument name="order_by" type="string" required="yes">
		<cfargument name="order_type" type="string" required="yes">

		<cfset var method = "getSubItemsArray">

		<cfset var arrayItemsUpdated = arrayNew(1)>


			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfquery name="getSubItemsQuery" datasource="#client_dsn#" result="result">
				SELECT items.id, title, user_in_charge, attached_file_name, family_name, users.name AS user_name, items.creation_date AS item_creation_date, UNIX_TIMESTAMP(items.creation_date) AS creation_date_epoch
				<cfif arguments.format_content EQ "ALL">
				attached_file_id, parent_id, parent_kind, description
				</cfif>
				FROM #client_abb#_#itemTypeTable# AS items, #client_abb#_users AS users
				WHERE parent_id=<cfqueryPARAM value = "#item_id#" CFSQLType = "CF_SQL_Integer">
				AND items.user_in_charge = users.id
				AND items.parent_kind='item'
				AND items.status='ok'
				ORDER BY #arguments.order_by# #arguments.order_type#;
			</cfquery>

			<cfif getSubItemsQuery.recordCount GT 0>

				<cfloop query="getSubItemsQuery">

					<cfinvoke component="AreaItemManager" method="objectItem" returnvariable="objectResultItem">
						<cfinvokeargument name="id" value="#getSubItemsQuery.id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="title" value="#getSubItemsQuery.title#">
						<cfinvokeargument name="user_in_charge" value="#getSubItemsQuery.user_in_charge#">
						<cfinvokeargument name="creation_date" value="#getSubItemsQuery.item_creation_date#">
						<cfinvokeargument name="attached_file_name" value="#getSubItemsQuery.attached_file_name#">
						<cfinvokeargument name="user_full_name" value="#getSubItemsQuery.family_name# #getSubItemsQuery.user_name#">

						<cfif format_content EQ "all">
							<cfinvokeargument name="attached_file_id" value="#getSubItemsQuery.attached_file_id#">
							<!---<cfinvokeargument name="item_read" value="#getSubItemsQuery.item_read#">--->
							<!---<cfinvokeargument name="area_name" value="#getSubItemsQuery.area_name#">--->
							<cfinvokeargument name="parent_id" value="#getSubItemsQuery.parent_id#">
							<cfinvokeargument name="parent_kind" value="#getSubItemsQuery.parent_kind#">
							<cfinvokeargument name="description" value="#getSubItemsQuery.description#">
						</cfif>

						<cfinvokeargument name="tree_mode" value="true"><!---Esto hace que se pasen los elementos del mensaje como atributos--->
						<cfinvokeargument name="return_type" value="object">
					</cfinvoke>

					<cfset objectResultItem.creation_date_epoch = getSubItemsQuery.creation_date_epoch>

					<cfset ArrayAppend(arguments.arrayItems, objectResultItem)>


					<cfinvoke component="AreaItemManager" method="getSubItemsArray" returnvariable="arrayItemsUpdated">
						<cfinvokeargument name="item_id" value="#getSubItemsQuery.id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="format_content" value="#format_content#">
						<cfinvokeargument name="arrayItems" value="#arguments.arrayItems#">
						<cfinvokeargument name="order_by" value="#arguments.order_by#">
						<cfinvokeargument name="order_type" value="#arguments.order_type#">
					</cfinvoke>

					<cfset arguments.arrayItems = arrayItemsUpdated>

				</cfloop>

			</cfif>

			<cfreturn arguments.arrayItems>

	</cffunction>
	<!--- -----------------------------------------------------------------------------------------  --->



	<!--- ----------------GET AREA ITEMS--------------------------------------------   --->

	<cffunction name="getAreaItems" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="area_type" type="string" required="false">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="format_content" type="string" required="no" default="default"><!---default/all--->
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no">
		<cfargument name="parse_dates" type="boolean" required="false" default="true">

		<cfset var method = "getAreaItems">
		<cfset var areaItemsQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="area_type" value="#arguments.area_type#">
				<cfif isDefined("arguments.user_in_charge")>
					<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="with_user" value="true">
				<cfinvokeargument name="parse_dates" value="#arguments.parse_dates#"/>
				<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfif isDefined("arguments.done")>
				<cfinvokeargument name="done" value="#arguments.done#">
				</cfif>
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset areaItemsQuery = getAreaItemsResult.query>

			<cfset response = {result=true, areaItems=#areaItemsQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------------------------------------------------------  --->


	<!--- getAreaItemsTree --->

	<cffunction name="getAreaItemsTree" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="listFormat" type="boolean" required="yes">
		<cfargument name="format_content" type="string" required="no" default="default"><!---default/all--->
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="done" type="boolean" required="no">

		<cfset var method = "getAreaItemsTree">
		<cfset var areaItemsQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfif isDefined("arguments.user_in_charge")>
					<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="listFormat" value="#arguments.listFormat#">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="with_user" value="true">
				<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfif isDefined("arguments.done")>
				<cfinvokeargument name="done" value="#arguments.done#">
				</cfif>
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset areaItemsQuery = getAreaItemsResult.query>

			<cfset xmlItems=''>
			<cfif areaItemsQuery.recordCount GT 0>

				<cfset xmlItems = '<#itemTypeNameP#>'>

				<cfloop query="areaItemsQuery">
					<!--- TREE FORMAT --->
					<cfif arguments.listFormat NEQ true>
						<cfinvoke component="AreaItemManager" method="getSubItems" returnvariable="resultSubItems">
							<cfinvokeargument name="item_id" value="#areaItemsQuery.id#">
							<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
							<cfinvokeargument name="listFormat" value="#listFormat#">
							<cfinvokeargument name="format_content" value="#format_content#">
						</cfinvoke>
					</cfif>

					<cfinvoke component="AreaItemManager" method="objectItem" returnvariable="xmlResultItem">
						<cfinvokeargument name="id" value="#areaItemsQuery.id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="title" value="#areaItemsQuery.title#">
						<cfinvokeargument name="user_in_charge" value="#areaItemsQuery.user_in_charge#">
						<cfinvokeargument name="creation_date" value="#areaItemsQuery.creation_date#">
						<cfinvokeargument name="attached_file_name" value="#areaItemsQuery.attached_file_name#">
						<cfinvokeargument name="attached_file_id" value="#areaItemsQuery.attached_file_id#">
						<cfif arguments.itemTypeId IS NOT 1>
							<cfinvokeargument name="attached_image_id" value="#areaItemsQuery.attached_image_id#">
						</cfif>
						<cfinvokeargument name="user_full_name" value="#areaItemsQuery.family_name# #areaItemsQuery.user_name#">
						<cfinvokeargument name="user_image_type" value="#areaItemsQuery.user_image_type#">
						<cfif arguments.itemTypeId IS 5 OR arguments.itemTypeId IS 6><!---Events OR Tasks--->
							<cfinvokeargument name="start_date" value="#areaItemsQuery.start_date#">
							<cfinvokeargument name="end_date" value="#areaItemsQuery.end_date#">
						</cfif>
						<cfif arguments.itemTypeId IS 6><!---Tasks--->
							<cfinvokeargument name="recipient_user_full_name" value="#areaItemsQuery.recipient_user_family_name# #areaItemsQuery.recipient_user_name#">
							<cfinvokeargument name="done" value="#areaItemsQuery.done#">
							<cfinvokeargument name="estimated_value" value="#areaItemsQuery.estimated_value#">
							<cfinvokeargument name="real_value" value="#areaItemsQuery.real_value#">
						</cfif>
						<cfif arguments.itemTypeId IS 2 OR arguments.itemTypeId IS 3 OR arguments.itemTypeId IS 4>
							<cfinvokeargument name="position" value="#areaItemsQuery.position#">
						</cfif>
						<cfif arguments.itemTypeId IS 7><!---Consultations--->
							<cfinvokeargument name="state" value="#areaItemsQuery.state#">
							<cfinvokeargument name="identifier" value="#areaItemsQuery.identifier#">
						</cfif>
						<cfif format_content EQ "all">
							<cfinvokeargument name="parent_id" value="#areaItemsQuery.parent_id#">
							<cfinvokeargument name="parent_kind" value="#areaItemsQuery.parent_kind#">
							<cfinvokeargument name="description" value="#areaItemsQuery.description#">
						</cfif>

						<cfif listFormat NEQ true>
							<cfinvokeargument name="sub_items" value="#resultSubItems#">
						</cfif>

						<cfinvokeargument name="tree_mode" value="true"><!---Esto hace que se pasen los elementos del mensaje como atributos--->
						<cfinvokeargument name="return_type" value="xml">
					</cfinvoke>

					<cfset xmlItems = xmlItems&xmlResultItem>

				</cfloop>


				<cfset xmlItems = xmlItems&'</#itemTypeNameP#>'>

			<cfelse>
				<cfset xmlItems='<#itemTypeNameP#/>'>
			</cfif>

			<cfset response = {result=true, xmlItems=#xmlItems#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------GET ALL AREAS ITEMS-----------------------------------   --->

	<cffunction name="getAllAreasItems" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="recipient_user" type="numeric" required="no">
		<cfargument name="format_content" type="string" required="no" default="default">
		<cfargument name="with_area" type="boolean" required="no" default="false">
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="done" type="numeric" required="no">
		<cfargument name="state" type="string" required="no">
		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="to_end_date" type="string" required="no">
		<cfargument name="identifier" type="string" required="false">
		<cfargument name="categories_ids" type="array" required="false">

		<cfset var method = "getAllAreasItems">

		<cfset var response = structNew()>

		<cfset var userAreasIds = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="userAreasIds">
				<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="areas_ids" value="#userAreasIds#">
				<cfinvokeargument name="area_type" value="">
				<cfif isDefined("arguments.search_text")>
					<cfinvokeargument name="search_text" value="#arguments.search_text#">
				</cfif>
				<cfif isDefined("arguments.user_in_charge")>
					<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfif isDefined("arguments.recipient_user")>
					<cfinvokeargument name="recipient_user" value="#arguments.recipient_user#">
				</cfif>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="listFormat" value="true">
				<cfinvokeargument name="format_content" value="#arguments.format_content#">
				<cfinvokeargument name="with_user" value="true">
				<cfinvokeargument name="with_area" value="#arguments.with_area#">
				<cfinvokeargument name="parse_dates" value="true"/>
				<cfif isDefined("arguments.limit")>
				<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfif isDefined("arguments.done")>
				<cfinvokeargument name="done" value="#arguments.done#">
				</cfif>
				<cfif isDefined("arguments.state")>
				<cfinvokeargument name="state" value="#arguments.state#">
				</cfif>
				<cfif isDefined("arguments.from_date")>
				<cfinvokeargument name="from_date" value="#arguments.from_date#">
				</cfif>
				<cfif isDefined("arguments.end_date")>
				<cfinvokeargument name="end_date" value="#arguments.end_date#">
				</cfif>
				<cfif isDefined("arguments.to_end_date")>
				<cfinvokeargument name="to_end_date" value="#arguments.to_end_date#">
				</cfif>
				<cfinvokeargument name="identifier" value="#arguments.identifier#">
				<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#">
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, query=#getAreaItemsResult.query#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->




	<!--- ----------------GET ALL AREA ITEMS--------------------------------------------   --->
	<!---A esta función siempre la llama otra funcion de ColdFusion--->

	<cffunction name="getAllAreaItems" output="false" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="area_type" type="string" required="yes">
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="full_content" type="boolean" required="false">

		<cfset var method = "getAllAreaItems">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="area_type" value="#arguments.area_type#">
				<cfif isDefined("arguments.limit")>
				<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withMailings" value="#APPLICATION.moduleMailing#">

				<cfinvokeargument name="full_content" value="#arguments.full_content#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, query=#getAreaItemsResult.query#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->



	<!--- ----------------GET ALL ITEMS--------------------------------------------   --->

	<cffunction name="getAllItems" output="false" returntype="struct" access="public">
		<cfargument name="limit" type="numeric" required="false" default="50">
		<cfargument name="full_content" type="boolean" required="false" default="true">
		<cfargument name="withArea" type="boolean" required="false">

		<cfset var method = "getAllItems">

		<cfset var response = structNew()>

		<cfset var userAreasIds = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="userAreasIds">
				<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="listAllAreaItems" returnvariable="getAreaItemsResult">
				<cfinvokeargument name="areas_ids" value="#userAreasIds#">
				<cfinvokeargument name="limit" value="#arguments.limit#">
				<cfinvokeargument name="full_content" value="#arguments.full_content#">

				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="withConsultations" value="#APPLICATION.moduleConsultations#">
				<cfinvokeargument name="withPubmedsComments" value="#APPLICATION.modulePubMedComments#">
				<cfinvokeargument name="withLists" value="#APPLICATION.moduleLists#">
				<cfinvokeargument name="withForms" value="#APPLICATION.moduleForms#">
				<cfinvokeargument name="withDPDocuments" value="#APPLICATION.moduleDPDocuments#">
				<cfinvokeargument name="withArea" value="#arguments.withArea#">
				<cfinvokeargument name="withMailings" value="#APPLICATION.moduleMailing#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, query=#getAreaItemsResult.query#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->



	<!--- ------------------------------------- exportAreaItems ------------------------------------- --->

	<cffunction name="exportAreaItems" output="false" access="public" returntype="struct">
		<cfargument name="area_id" type="numeric" required="true"/>
		<!---<cfargument name="delimiter" type="string" required="false" default=";">--->
		<cfargument name="ms_excel_compatibility" type="boolean" required="false" default="false">

		<cfset var method = "exportAreaItems">

		<cfset var response = structNew()>

		<cfset var area_type = "">
		<cfset var exportContent = "">

		<cfset var delimiter = ";">
		<cfset var newLine = (Chr( 13 ) & Chr( 10 ))>
		<cfset var buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
		<cfset var columnsNames = "">
		<cfset var columnsLabels = "">
		<cfset var rowData = []>
		<cfset var curRowValue = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="getAreaType" returnvariable="areaTypeResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>
			<cfset area_type = areaTypeResult.areaType>

			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="getAllAreaItems" returnvariable="getAllAreaItemsResult">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="area_type" value="#area_type#">
				<cfinvokeargument name="full_content" value="true">
			</cfinvoke>

			<cfset areaItemsQuery = getAllAreaItemsResult.query>

			<cfif areaItemsQuery.recordCount GT 0>

				<!--- getUser --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="selectUserQuery">
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset columnsNames = "itemType;title;user_full_name;creation_date;last_update_user_full_name;last_update_date;description;version_index;revision_user_full_name;revision_date;approval_user_full_name;approval_date">

				<cfif selectUserQuery.language EQ "es">
					<cfset columnsLabels = "Tipo de elemento;Título;Usuario creación;Fecha de creación;Usuario última modificación;Fecha de última modificación;Descripción;Nº Versión actual;Usuario revisor de la versión;Fecha de revision;Usuario aprobador de la versión;Fecha de aprobación">
				<cfelse>
					<cfset columnsLabels = "Element type;Tittle;Creation user;Creation date;Last update user;Last update date;Description;Current number version;Revision user;Revision date;Current version approval user;Approval date">
				</cfif>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfinvoke>

				<!--- Add columns name row --->
				<cfset buffer.Append( JavaCast("string", (columnsLabels & newLine) ) ) />

				<!---
					Now that we have dealt with any header value, let's
					convert the query body to CSV. When doing this, we are
					going to qualify each field value. This is done be
					default since it will be much faster than actually
					checking to see if a field needs to be qualified.
				--->
				<cfloop query="areaItemsQuery">

					<!--- Create array to hold row data. --->
					<cfset rowData = [] />

					<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files with versions--->

						<!--- getLasFileVersion --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="lastVersion">
							<cfinvokeargument name="file_id" value="#areaItemsQuery.id#"/>
							<cfinvokeargument name="fileTypeId" value="#areaItemsQuery.file_type_id#"/>
							<cfinvokeargument name="limit" value="1">
							<cfinvokeargument name="parse_dates" value="true">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>

					<!--- Loop over the columns. --->
					<cfloop	list="#columnsNames#" index="columnName" delimiters="#delimiter#">

						<cfset curRowValue = "">

						<cfswitch expression="#columnName#">

							<cfcase value="itemType">
								<cfset curRowValue = itemTypesStruct[areaItemsQuery.itemTypeId].label>
							</cfcase>

							<cfcase value="last_update_user_full_name">

								<cfif isNumeric(areaItemsQuery.last_update_user_id)>

									<!--- Last update user --->
						    		<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
										<cfinvokeargument name="user_id" value="#areaItemsQuery.last_update_user_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfset curRowValue = userQuery.user_full_name>

								</cfif>

							</cfcase>

							<cfcase value="version_index">

								<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files --->
									<cfset curRowValue = lastVersion.version_index>
								</cfif>

							</cfcase>

							<cfcase value="revision_date">

								<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files --->
									<cfset curRowValue = lastVersion.revision_date>
								</cfif>

							</cfcase>

							<cfcase value="revision_user_full_name">

								<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files --->
									<cfset curRowValue = lastVersion.revision_user_full_name>
								</cfif>

							</cfcase>

							<cfcase value="approval_date">

								<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files --->
									<cfset curRowValue = lastVersion.approval_date>
								</cfif>

							</cfcase>

							<cfcase value="approval_user_full_name">

								<cfif areaItemsQuery.itemTypeId IS 10 AND areaItemsQuery.file_type_id IS 3><!--- Area Files --->
									<cfset curRowValue = lastVersion.approval_user_full_name>
								</cfif>

							</cfcase>

							<cfdefaultcase>

								<cfset curRowValue = areaItemsQuery[columnName]>

								<cfif len(LOCAL.curRowValue) GTE 10 AND isDate(LOCAL.curRowValue)><!---The value is DATE--->
									<cfset curRowValue = DateFormat(dateConvert("local2Utc", curRowValue), "dd/mm/yyyy")/>
								</cfif>

							</cfdefaultcase>

						</cfswitch>

						<cfset curRowValue = """#Replace( curRowValue, """", """""", "all" )#""">

						<cfset arrayAppend(rowData, curRowValue)/>

					</cfloop>

					<!--- Append the row data to the string buffer. --->
					<cfset buffer.Append( JavaCast(	"string", (	ArrayToList(rowData,delimiter) & newLine ))) />

				</cfloop>

			</cfif>

			<cfset exportContent = buffer.ToString()>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, area_id=arguments.area_id, content=exportContent}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, message=cfcatch.message}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ------------------------------------- importItems ------------------------------------- --->

	<cffunction name="importItems" output="false" access="public" returntype="struct">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="files" type="array" required="true"/>
		<cfargument name="delimiter" type="string" required="false" default=";">
		<cfargument name="start_row" type="numeric" required="false" default="2">
		<cfargument name="reverse_order" type="boolean" required="false" default="false">
		<cfargument name="cancel_on_error" type="boolean" required="false" default="true">

		<cfset var method = "importItems">

		<cfset var response = structNew()>

		<cfset var filesData = arrayNew(1)>
		<cfset var fileData = "">
		<cfset var destination = "">
		<cfset var fileContent = "">
		<cfset var fileArray = arrayNew(1)>
		<cfset var itemsCount = 0>
		<cfset var itemValues = structNew()>
		<cfset var areasQueries = structNew()>
		<cfset var userCategoriesIds = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfset destination = GetTempDirectory()>

			<cffile action="upload" fileField="files[]" destination="#destination#" nameConflict="makeunique" result="fileResult" charset="iso-8859-1" accept="text/plain,text/csv,text/comma-separated-values,text/tab-separated-values,application/csv,application/vnd.ms-excel"><!--- application/vnd.ms-excel es necesario para IE --->

			<cfset destinationFile = destination&fileResult.serverFile>

			<cfset fileData = {
					"name": fileResult.serverfile,
					"size": fileResult.filesize,
					"url": "",
					"thumbnailUrl": "",
					"deleteUrl": "",
					"deleteType": "DELETE"
				}>

			<cfset arrayAppend(filesData, fileData)>

			<cffile action="read" file="#destinationFile#" variable="fileContent" charset="iso-8859-1">

			<cffile action="delete" file="#destinationFile#">

			<!--- CSV to array --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="CSVToArray" returnvariable="fileArray">
				<cfinvokeargument name="CSV" value="#trim(#fileContent#)#">
				<cfif arguments.delimiter EQ "tab">
					<cfinvokeargument name="delimiter" value="#chr(9)#">
				<cfelse>
					<cfinvokeargument name="delimiter" value="#arguments.delimiter#">
				</cfif>
			</cfinvoke>

			<cfset numFileColumns = arrayLen(fileArray[1])>
			<cfset numFileRows = arrayLen(fileArray)>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypeFields" returnvariable="itemTypeFields">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
			</cfinvoke>

			<cfset itemTypesFieldsSorted = structSort(itemTypeFields, "numeric", "asc", "position")>

			<cfif arguments.reverse_order IS true><!--- Reverse order --->
				<cfset startRow = numFileRows>

				<cfset endRow = arguments.start_row>

			<cfelse>

				<cfset startRow = arguments.start_row>

				<cfset endRow = numFileRows>

			</cfif>

			<cfloop from="#startRow#" to="#endRow#" step="-1" index="curRowIndex"><!--- loop Rows --->

				<cftry>

					<cfset curRow = fileArray[curRowIndex]>

					<cfset itemValues = structNew()>

					<cfset curColumn = 1>

					<cfloop array="#itemTypesFieldsSorted#" index="fieldName">

						<cfif itemTypeFields[fieldName].import IS true>

							<cfset fieldValue = trim(curRow[curColumn])>

							<cfif fieldName EQ "creation_date">

								<cfif find("/", fieldValue) GT 0>
									<cfset fieldValue = replaceNoCase(fieldValue, "/", "-", "ALL")>
								</cfif>

								<cfinvoke component="#APPLICATION.coreComponentsPath#/DateManager" method="validateDate" returnvariable="validateDateResult">
									<cfinvokeargument name="strDate" value="#fieldValue#">
								</cfinvoke>

								<cfif validateDateResult IS false>
									<cfthrow message="#validateDateResult.message#: #fieldValue#">
								</cfif>

							</cfif>

							<cfset itemValues[fieldName] = fieldValue>

							<cfset curColumn = curColumn+1>

						<cfelse>

							<cfset itemValues[fieldName] = itemTypeFields[fieldName].default>

						</cfif>

					</cfloop>

					<cfinvoke component="#APPLICATION.componentsPath#/AreaItemManager" method="createItem" argumentcollection="#itemValues#" returnvariable="createItemResponse">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parent_id" value="#arguments.area_id#">
						<cfinvokeargument name="parent_kind" value="area">
						<!---<cfinvokeargument name="user_in_charge" value="#SESSION.user_id#">--->
						<cfinvokeargument name="no_notify" value="true">
					</cfinvoke>

					<cfif createItemResponse.result NEQ true>
						<cfthrow message="#createItemResponse.message#">
					</cfif>

					<cfset itemsCount = itemsCount+1>

					<cfcatch>

						<cfset errorMessagePrefix = "Error en fila #curRowIndex#: ">
						<cfset errorMessage = errorMessagePrefix&cfcatch.message>

						<cfthrow message="#errorMessage#">

					</cfcatch>

				</cftry>

			</cfloop>

			<cfinclude template="includes/logRecord.cfm">

			<cfif itemsCount IS 0>
				<cfset response = {result=false, files=filesData, itemsCount=itemsCount, message="No se ha importado ningún elemento"}>
			<cfelse>
				<cfset response = {result=true, files=filesData, itemsCount=itemsCount, message="",}>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

				<cfset response = {result=false, files=filesData, itemsCount=itemsCount, fileArray=fileArray, message=cfcatch.message}>

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>

</cfcomponent>
