<cfset delete_attached_file_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedFileRemote">

<cfset delete_attached_image_action = "#APPLICATION.htmlComponentsPath#/AreaItem.cfc?method=deleteItemAttachedImageRemote">

<cfoutput>

<script>


	<cfif read_only IS false>

	$(function() {

		<cfif itemTypeId IS 5 OR itemTypeId IS 6 OR itemTypeId IS 4><!---Events, Tasks, News--->

			$('##start_date').datepicker({
			  format: 'dd-mm-yyyy',
			  autoclose: true,
			  weekStart: 1,
			  <cfif SESSION.user_language EQ "es">
			  	language: 'es',
			  <cfelse>
			  	language: 'en',
			  </cfif>
			  todayBtn: 'linked'
				}).on('changeDate', function(ev){
					var startDateVal = $('##start_date').val();
			        $('##end_date').datepicker('setStartDate', startDateVal);
			        if ( ev.date.valueOf() > $('##end_date').data('datepicker').date.valueOf() ){
			            $('##end_date').datepicker('update', startDateVal);
			        }
		    	});

			$('##end_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  <cfif SESSION.user_language EQ "es">
			  	language: 'es',
			  <cfelse>
			  	language: 'en',
			  </cfif>
			  todayBtn: 'linked',
			  autoclose: true,
			  startDate: $('##start_date').val()
			});

		</cfif>

		<cfif itemTypeWeb IS true AND ( NOT isDefined("area_type") OR len(area_type) GT 0 )><!--- WEB --->

			$('##publication_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  <cfif SESSION.user_language EQ "es">
			  	language: 'es',
			  <cfelse>
			  	language: 'en',
			  </cfif>
			  todayBtn: 'linked',
			  autoclose: true
			});

		</cfif>

		<cfif itemTypeId IS 8>
			subTypeChange($('##sub_type_id').val());
		</cfif>

	});


	function checkDates(startDateFieldName, endDateFieldName) {

		var startDateVal = $("input:text[name="+startDateFieldName+"]").val();
		var endDateVal = $("input:text[name="+endDateFieldName+"]").val();

		var startDateParts = startDateVal.split('-');
		var endDateParts = endDateVal.split('-');

		//Comprueba que el año tenga 4 cifras
		//(Los años de 2 cifras generan fechas incorrectas al guardarse en MySQL)
		if(startDateParts[2].length != 4 || endDateParts[2].length != 4)
			return false;

		return true;

	}

	function openUserSelector(){

		 return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}

	function setSelectedUser(userId, userName) {

		document.getElementById("recipient_user").value = userId;
		document.getElementById("recipient_user_full_name").value = userName;
		/*$("##recipient_user").val(userId);
		$("##recipient_user_name").val(userName); */
	}


	function subTypeChange(subTypeId){

		if(subTypeId == 1){
			$("##identifierLabel").text("PubMed ID");
			$("##openInPubMedButton").show();
			$("##getPublicationDataButton").show();
			$("##fieldPrice").hide();
		}else {
			$("##identifierLabel").text(window.lang.translate("Identificador/Número"));
			$("##openInPubMedButton").hide();
			$("##getPublicationDataButton").hide();
			$("##fieldPrice").show();
		}

	}

	<cfif itemTypeId IS 8>
	function openPublicationInPubMed(pubMedId){

		if($.isNumeric(pubMedId))
			window.open("http://www.ncbi.nlm.nih.gov/pubmed/"+pubMedId, '_blank');
		else
			alert(window.lang.translate("PubMed Id no válido"));
	}

	function getPublicationData(publicationId){

		if($.isNumeric(publicationId)){

			showLoadingPage(true);

			<!---
			IMPORTANTE: los navegadores no permiten por defecto realizar peticiones AJAX a un servidor distinto del que se ejecuta el script. Para permitir el funcionamiento del siguiente código, y hacer una petición a un servidor externo es necesario el uso de plugins u otro código que lo permita. En este caso se está usando un plugin para jQuery.
			http://james.padolsey.com/javascript/cross-domain-requests-with-jquery/
			Con PubMed no funciona, con otras páginas sí.
			Está quitado el plugin ya que no es necesario para peticiones en el mismo servidor.
			--->

			$.ajax({
			   type: "GET",
			   //url: "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi&db=pubmed&id="+publicationId+"&retmode=xml",
			   url:"#APPLICATION.htmlComponentsPath#/AreaItem.cfc",
			   data: "method=getPublicationInPubMed&pubmed_id="+publicationId,
			   dataType: "text",
			   /*crossDomain: "true",*/
			   /*dataType: "xml",*/
			   /*async: false,*/
			   success: handleXmlPublicationResponse,
			   error: function(data){

			   		showLoadingPage(false);
					alert("Ha ocurrido un error al obtener los datos.");

			   }
			 });

		}else{
			alert(window.lang.translate("PubMed Id no válido"));
		}

	}

	function handleXmlPublicationResponse(response){

		var xmlDoc = $.parseXML($.trim(response));
		var jXml = $(xmlDoc);

		if(jXml.find("PubmedArticleSet").length != 0) {

			var jTitle = jXml.find("PubmedArticleSet").find("PubmedArticle").find("MedlineCitation").find("Article").find("ArticleTitle");
			var jAbstract = jXml.find("Abstract").find("AbstractText");
			var jYear = jXml.find("PubmedArticleSet").find("PubmedArticle").find("MedlineCitation").find("Article").find("Journal").find("JournalIssue").find("PubDate").find("Year");
			var jMonth = jXml.find("PubmedArticleSet").find("PubmedArticle").find("MedlineCitation").find("Article").find("Journal").find("JournalIssue").find("PubDate").find("Month");
			var jAuthors = jXml.find("PubmedArticleSet").find("PubmedArticle").find("MedlineCitation").find("Article").find("AuthorList").find("Author");
			var jJournal = jXml.find("PubmedArticleSet").find("PubmedArticle").find("MedlineCitation").find("MedlineJournalInfo").find("MedlineTA");
			var eLocationId = jXml.find("PubmedArticleSet").find("ELocationID");

			var authors = "";

			jAuthors.each(function(){

				var jAuthor = $(this);

				var author = jAuthor.find("FirstName").text();

				var lastName = jAuthor.find("LastName").text();

				if(author != "" && lastName != "")
					author += " ";

				author += lastName;

				var initials = jAuthor.find("Initials").text();

				if(author != "" && initials != "")
					author += " ";

				author += initials;

				if(authors != "" && author != "")
					authors += ", ";
				authors += author;

			});


			if( $("##item_title").val().length == 0 )
				$("##item_title").val(jTitle.text());

			var publicationContent = '<p>'+authors+'</p>'+'<p>'+jJournal.text()+'. ';

			/*if( $.isNumeric(jMonth.text()) ) {
				var monthIndex = jMonth.text();
				// Get monthName from datepicker array
				var monthName = $.fn.datepicker.dates['en'].months[monthIndex];
				publicationContent = publicationContent+monthName+' ';
			}*/

			if( jMonth.text().length > 0 ) {
				publicationContent = publicationContent+jMonth.text()+' ';
			}

			if( $.isNumeric(jYear.text()) ) {
				publicationContent = publicationContent+jYear.text();
			}

			if( eLocationId.attr('EIdType') == "doi" )
				publicationContent = publicationContent+'. doi: '+eLocationId.text();

			publicationContent = publicationContent+'</p>';

			if( jAbstract.text().length > 0 )
			publicationContent = publicationContent+'<p>'+jAbstract.text()+'</p>';

			editor.setData(publicationContent);

		}else{
			alert("No se han encontrado datos relacionados con este id");
		}

		showLoadingPage(false);
	}
	</cfif>


	<cfif isDefined("item_id") AND read_only IS false>

		function deleteAttachedFile() {

			if(confirmAction('eliminar el archivo adjunto')) {

				goToUrl("#delete_attached_file_action#&item_id=#item_id#&area_id=#area_id#&itemTypeId=#itemTypeId#&return_page=#URLEncodedFormat('#CGI.SCRIPT_NAME#?#itemTypeName#=#item_id#')#");

			}
			return false;
		}

		function deleteAttachedImage() {

			if(confirmAction('eliminar la imagen adjunta')) {

				goToUrl("#delete_attached_image_action#&item_id=#item_id#&area_id=#area_id#&itemTypeId=#itemTypeId#&return_page=#URLEncodedFormat('#CGI.SCRIPT_NAME#?#itemTypeName#=#item_id#')#");

			}
			return false;
		}

	</cfif>

	</cfif><!--- END read_only IS false --->

</script>


<script>
	var railo_custom_form;

	if( typeof LuceeForms !== 'undefined' && $.isFunction(LuceeForms) )
		railo_custom_form = new LuceeForms('item_form');
	else
		railo_custom_form = new RailoForms('item_form');
</script>
<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>


<cfif itemTypeId IS 1 OR itemTypeId IS 7 OR itemTypeId IS 17>
	<cfset t_title = "Asunto">
<cfelse>
	<cfset t_title = "Título">
</cfif>
<cfif itemTypeId IS 2><!---Entradas--->
	<cfset title_required = false>
	<cfset t_display_type = "Tipo de visualización">
<cfelse>
	<cfset title_required = true>
</cfif>
<cfif itemTypeId IS 3>
	<cfset t_link = "URL">
	<cfset link_required = true>
<cfelse>
	<cfset t_link = "URL más información (enlace)">
	<cfset link_required = false>
</cfif>
<cfif itemTypeId IS 4>
	<cfset t_creation_date = "Fecha de creación">
</cfif>
<cfif itemTypeId IS 5 OR itemTypeId IS 6>
	<cfset t_start_date = "Fecha de inicio">
	<cfset t_end_date = "Fecha de fin">
	<cfif itemTypeId IS 5>
		<cfset t_start_time = "Hora">
		<cfset t_end_time = "Hora">
		<cfset t_place = "Lugar">
	<cfelse>
		<cfset t_recipient_user = "Usuario destinatario">
		<cfset t_estimated_value = "Valor estimado">
		<cfset t_real_value = "Valor real">
	</cfif>
<cfelse>
	<cfset t_email_addresses = "Destinatarios para pruebas">
</cfif>
<cfif itemTypeId IS 5 OR itemTypeId IS 8>
	<cfset t_price = "Valor">
</cfif>
<cfif itemTypeId IS 7 OR itemTypeId IS 8>
	<cfset t_identifier = "Identificador/Número">
</cfif>
<cfif itemTypeId IS 8>
	<cfset t_sub_type = "Tipo de">
</cfif>
<cfset t_position = "Posición">
<cfset t_iframe_display_type = "Tamaño contenido">

<cfif read_only IS true>
	<cfset passthrough = 'readonly="readonly"'>
<cfelse>
	<cfset passthrough = "">
</cfif>

<cfif itemTypeId IS 8>
<div class="row">

	<div class="col-md-6">

		<label class="control-label" for="sub_type_id" id="subTypeLabel"><span lang="es">#t_sub_type#</span> <span lang="es">#itemTypeNameEs#</span> *</label>

		<cfinvoke component="#APPLICATION.componentsPath#/ItemSubTypeManager" method="getSubTypes" returnvariable="subTypeQuery">
			<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
		</cfinvoke>

		<select name="sub_type_id" id="sub_type_id" class="form-control" <cfif read_only IS true>disabled="disabled"</cfif> onchange="subTypeChange($('##sub_type_id').val());">
			<cfloop query="subTypeQuery">
				<option value="#subTypeQuery.sub_type_id#" lang="es" <cfif objectItem.sub_type_id IS subTypeQuery.sub_type_id>selected="selected"</cfif>>#subTypeQuery.sub_type_title_es#</option>
			</cfloop>
		</select>

	</div>

</div>
</cfif>

<cfif itemTypeId IS NOT 7 OR NOT isDefined("parent_kind") OR parent_kind EQ "area">
<div class="row">
	<div class="col-xs-12 col-md-12"><!---<cfif APPLICATION.hideInputLabels IS false>control-label<cfelse>sr-only</cfif>--->
		<label class="control-label" for="item_title" <cfif itemTypeId IS 1>style="font-size:18px;"</cfif>><span lang="es">#t_title#</span> <cfif itemTypeId NEQ 17><span lang="es">#itemTypeNameEs#</span><cfelse><span lang="es">del email</span></cfif>: <cfif title_required IS true>*</cfif></label>
		<div>
			<cfinput type="text" name="title" id="item_title" value="#objectItem.title#" required="#title_required#" message="#t_title# requerido" passthrough="#passthrough# lang='es'" class="form-control">
		</div>
	</div>
</div>
<cfelse><!---Consultations--->
	<cfinput type="hidden" name="title" value="#objectItem.title#">
</cfif>

<cfif itemTypeWeb IS true AND ( NOT isDefined("area_type") OR len(area_type) GT 0 )><!--- WEB --->

	<div class="row">

		<cfif isDefined("objectItem.publication_hour")><!--- After send FORM --->

			<cfset publication_hour = objectItem.publication_hour>
			<cfset publication_minute = objectItem.publication_minute>

		<cfelse>

			<!---<cfif len(objectItem.publication_time) IS 0>
				<cfset objectItem.publication_time = createTime(0,0,0)>
			</cfif>--->

			<cfset publication_hour = timeFormat(objectItem.publication_date, "HH")>
			<cfset publication_minute = timeFormat(objectItem.publication_date, "mm")>

			<cfif len(objectItem.publication_date) GT 10>
				<cfset objectItem.publication_date = left(objectItem.publication_date, findOneOf(" ", objectItem.publication_date))>
			</cfif>

		</cfif>

		<!--- <cfif len(objectItem.publication_date) GT 10></cfif> --->

		<div class="col-xs-6 col-md-3">
			<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span> <span lang="es">#itemTypeNameEs#</span>:</label>
			<cfinput type="text" name="publication_date" id="publication_date" class="form-control" value="#objectItem.publication_date#" required="false" message="Fecha de publicación válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
		</div>

		<div class="col-xs-6">
			<!---
				<label class="control-label" for="publication_hour"><span lang="es">Hora de publicación</span></label>
							<div class="input-group" style="width:170px">
								<select name="publication_hour" id="publication_hour" class="form-control" style="width:70px;">
									<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
										<cfset curHour = TimeFormat(hour, 'HH')>
										<option value="#curHour#" <cfif curHour EQ publication_hour>selected="selected"</cfif>>#curHour#</option>
									</cfloop>
								</select><span class="input-group-addon">:</span><select name="publication_minute" class="form-control" style="width:70px;">
									<cfset minutesInOptions = false>
									<cfloop from="0" to="59" index="minutes" step="5">
										<cfif len(minutes) EQ 1>
											<cfset minutes = "0"&minutes>
										</cfif>
										<cfif minutes EQ publication_minute>
											<cfset minutesSelected = true>
											<cfset minutesInOptions = true>
										<cfelse>
											<cfset minutesSelected = false>
										</cfif>
										<option value="#minutes#" <cfif minutesSelected>selected="selected"</cfif>>#minutes#</option>
									</cfloop>
									<cfif minutesInOptions IS false AND len(publication_minute) GT 0>
										<option value="#publication_minute#" selected="selected">#publication_minute#</option>
									</cfif>
								</select>
							</div> --->

		</div>


		<input type="hidden" name="publication_hour" value="00"/>
		<input type="hidden" name="publication_minute" value="00"/>


	</div>

	<cfif isDefined("area_type")>
	<div class="row">
		<div class="col-sm-12">
			<!---<small class="help-block">Si está definida, <cfif itemTypeGender EQ "male">el<cfelse>la</cfif> #itemTypeNameEs# se publicará en la fecha especificada.</small>--->
			<small class="help-block" lang="es">Si está definida, este contenido se mostrará en la #area_type# en la fecha especificada.</small>
		</div>
	</div>
	</cfif>

	<cfif APPLICATION.publicationValidation IS true>

		<cfif isDefined("is_user_area_responsible")><!--- Está definida el área en la que se va a publicar el elemento --->

			<cfif is_user_area_responsible IS true>

				<div class="row">
					<div class="col-xs-12 col-sm-8">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="publication_validated" id="publication_validated" value="true" <cfif isDefined("objectItem.publication_validated") AND objectItem.publication_validated IS true>checked="checked"</cfif> /> <span lang="es">Aprobar publicación</span>
							</label>
							<small class="help-block" lang="es">Valida <cfif itemTypeGender EQ "male">el<cfelse>la</cfif> #itemTypeNameEs# para que pueda ser <cfif itemTypeGender EQ "male">publicado<cfelse>publicada</cfif>.</small>
						</div>
					</div>
				</div>

			</cfif>

		<cfelse>

			<input type="hidden" name="publication_validated" value="false"/>
			<small class="help-block" lang="es">La publicación del elemento deberá ser aprobada en cada una de las áreas en las que se publique.</small>

		</cfif>

	</cfif>

	<cfif APPLICATION.publicationRestricted IS true AND isDefined("area_type") AND area_type EQ "web">
		<div class="row">
			<div class="col-xs-12 col-sm-8">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="publication_restricted" id="publication_restricted" value="true" <cfif isDefined("objectItem.publication_restricted") AND objectItem.publication_restricted IS true>checked="checked"</cfif> /> <span lang="es">Visible sólo para usuarios identificados</span>
					</label>
					<small class="help-block" lang="es"><cfif itemTypeGender EQ "male">El<cfelse>La</cfif> #itemTypeNameEs# sólo podrá ser visible en la web por usuarios logueados.</small>
				</div>
			</div>
		</div>
	</cfif>

</cfif>

<cfif itemTypeId IS 4><!---News--->

	<div class="row">
		<div class="col-xs-6 col-md-3">

			<cfif len(objectItem.creation_date) GT 10>
				<cfset objectItem.creation_date = left(objectItem.creation_date, findOneOf(" ", objectItem.creation_date))>
			</cfif>

			<label class="control-label" for="creation_date" lang="es"><span lang="es">#t_creation_date#</span> <span lang="es">#itemTypeNameEs#</span>:</label>
			<cfinput type="text" name="creation_date" id="creation_date" class="form-control" value="#objectItem.creation_date#" required="true" message="#t_creation_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">

		</div>
		<div class="col-xs-6">
			<br/>
			<span style="font-size:10px"><span lang="es">Formato DD-MM-AAAA</span>.<br/> <span lang="es">Ejemplo</span>:</span><span style="font-size:10px"> #DateFormat(now(), "DD-MM-YYYY")#</span>

		</div>
	</div>

</cfif>

<cfif itemTypeId IS 5 OR itemTypeId IS 6><!---Events, Tasks--->

<cfif itemTypeId IS 6><!---Tasks--->
	<div class="row">
		<div class="col-md-12">

			<label class="control-label" for="recipient_user_full_name"><span lang="es">#t_recipient_user#</span> <span lang="es">#itemTypeNameEs#</span>:</label>

			<div class="row">
				<div class="col-sm-5" style="padding-right:0;">
					<input type="hidden" name="recipient_user" id="recipient_user" value="#objectItem.recipient_user#" required="true" class="form-control" />
					<cfinput type="text" name="recipient_user_full_name" id="recipient_user_full_name" class="form-control" value="#objectItem.recipient_user_full_name#" readonly="yes" required="true" message="Usuario destinatario requerido" onclick="openUserSelector()">
				</div>
				<div class="col-sm-7">
					<cfif read_only IS false> <button onclick="return openUserSelector();" class="btn btn-default" lang="es">Seleccionar usuario</button></cfif>
				</div>
			</div>

		</div>
	</div>
	<!---<div class="row">
		<div class="col-md-12">
			<cfif read_only IS false><span style="font-size:10px" lang="es">Usuario al que se le asignará la tarea</span></cfif>
		</div>
	</div>--->
</cfif>

<div class="row">

	<div class="col-xs-6 col-md-3">
		<label class="control-label" for="start_date"><span lang="es">#t_start_date#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
		<cfinput type="text" name="start_date" id="start_date" class="form-control input_datepicker" value="#objectItem.start_date#" required="true" message="#t_start_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
	</div>

	<cfif itemTypeId IS 5>

		<cfif isDefined("objectItem.start_time")>

			<cfif len(objectItem.start_time) IS 0>
				<cfset objectItem.start_time = createTime(0,0,0)>
			</cfif>

			<cfset start_hour = hour(objectItem.start_time)>
			<cfset start_minute = minute(objectItem.start_time)>

		<cfelse><!--- After send FORM --->

			<cfset start_hour = objectItem.start_hour>
			<cfset start_minute = objectItem.start_minute>

		</cfif>

		<div class="col-xs-6">
			<label class="control-label" for="start_hour"><span lang="es">#t_start_time#</span>:</label>
			<div class="input-group" style="width:180px">
				<select name="start_hour" id="start_hour" class="form-control" style="width:75px;">
					<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
						<cfset curHour = TimeFormat(hour, 'HH')>
						<option value="#curHour#" <cfif curHour EQ start_hour>selected="selected"</cfif>>#curHour#</option>
					</cfloop>
				</select><span class="input-group-addon">:</span><select name="start_minute" class="form-control" style="width:75px;">
					<cfloop from="0" to="59" index="minutes" step="5">
						<cfif minutes EQ "0">
							<cfset minutes = "00">
						</cfif>
						<option value="#minutes#" <cfif minutes EQ start_minute>selected="selected"</cfif>>#minutes#</option>
					</cfloop>
				</select>
			</div>
		</div>

	</cfif>

</div>

<div class="row">

	<div class="col-xs-6 col-md-3">
		<label class="control-label" for="end_date"><span lang="es">#t_end_date#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
		<cfinput type="text" name="end_date" id="end_date" class="form-control" value="#objectItem.end_date#" required="true" message="#t_end_date# válida requerida" validate="eurodate" mask="DD-MM-YYYY" passthrough="#passthrough#">
	</div>

	<cfif itemTypeId IS 5>

		<cfif isDefined("objectItem.end_time")>

			<cfif len(objectItem.end_time) IS 0>
				<cfset objectItem.end_time = createTime(0,0,0)>
			</cfif>

			<cfset end_hour = hour(objectItem.end_time)>
			<cfset end_minute = minute(objectItem.end_time)>

		<cfelse><!--- After send FORM --->

			<cfset end_hour = objectItem.end_hour>
			<cfset end_minute = objectItem.end_minute>

		</cfif>

		<div class="col-xs-6">
			<label class="control-label" for="end_hour"><span lang="es">Hora de fin</span>: </label>
			<div class="input-group" style="width:180px">
				<select name="end_hour" id="end_hour" class="form-control" style="width:75px;">
					<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
						<cfset curHour = TimeFormat(hour, 'HH')>
						<option value="#curHour#" <cfif curHour EQ end_hour>selected="selected"</cfif>>#curHour#</option>
					</cfloop>
				</select><span class="input-group-addon">:</span><select name="end_minute" class="form-control" style="width:75px;">
					<cfloop from="0" to="59" index="minutes" step="5">
						<cfif minutes EQ "0">
							<cfset minutes = "00">
						</cfif>
						<option value="#minutes#" <cfif minutes EQ end_minute>selected="selected"</cfif>>#minutes#</option>
					</cfloop>
				</select>
			</div>
		</div>

	</cfif>
</div>

</cfif>


<cfif itemTypeId IS 5><!---Events--->
<div class="row">
	<div class="col-md-3">
		<label class="control-label" for="place"><span lang="es">#t_place#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
		<cfinput type="text" name="place" id="place" class="form-control" value="#objectItem.place#" required="true" message="#t_place# requerido" passthrough="#passthrough#">
	</div>
</div>

<cfelseif itemTypeId IS 6><!---Tasks--->

<div class="row">

	<div class="col-xs-5 col-md-2">

		<label class="control-label" for="estimated_value"><span lang="es">#t_estimated_value#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
		<cfinput type="text" name="estimated_value" id="estimated_value" class="form-control" value="#objectItem.estimated_value#" required="true" validate="float" message="#t_estimated_value# debe ser un decimal" passthrough="#passthrough#"><!---&nbsp;<span style="font-size:10px">Valor (tiempo, coste, ...) estimado para la tarea.</span>--->

	</div>

	<div class="col-xs-6 col-md-2">

		<label class="control-label" for="real_value"><span lang="es">#t_real_value#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
		<cfinput type="text" name="real_value" id="real_value" class="form-control" value="#objectItem.real_value#" required="true" validate="float" message="#t_real_value# debe ser un decimal"><!---&nbsp;<span style="font-size:10px">Valor real de la tarea una vez realizada.</span>--->

	</div>

</div>

<div class="row">

    <div class="col-md-12">
	    <div class="checkbox">

			<label>
				<input type="checkbox" name="done" value="true" title="Tarea realizada" lang="es" <cfif isDefined("objectItem.done") AND objectItem.done IS true>checked="checked"</cfif>>
				<img src="#APPLICATION.htmlPath#/assets/v3/icons/task_done.png" alt="Tarea realizada" style="width:45px"/>
				<span lang="es">Tarea realizada</span>
			</label>

		</div>
	</div>

</div>

</cfif>

<cfif itemTypeId IS 7 OR itemTypeId IS 8>

	<!---<label class="control-label">##</label>--->
	<div class="row">

    	<div class="col-xs-6 col-md-3">
    		<label class="control-label" for="identifier" id="identifierLabel"><span lang="es">#t_identifier#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
			<cfinput type="text" name="identifier" id="identifier" class="form-control" value="#objectItem.identifier#" placeholder="Identificador" passthrough="#passthrough#" lang="es">

		</div>

		<!---<div class="col-xs-6 col-md-3">
		</div>--->

	</div>

	<cfif itemTypeId IS 8>
	<div class="row">
    	<div class="col-xs-12">
			<button type="button" class="btn btn-default btn-xs" id="getPublicationDataButton" lang="es" onclick="getPublicationData($('##identifier').val())">Obtener datos de PubMed</button>

			<button type="button" class="btn btn-default btn-xs" id="openInPubMedButton" lang="es" onclick="openPublicationInPubMed($('##identifier').val())">Ver en PubMed</button>
    	</div>
    </div>
    </cfif>
	<!---<div style="height:5px;"><!-- --></div>--->
</cfif>

<cfif itemTypeId IS 5 OR itemTypeId IS 8><!---Events, Publications--->
	<div class="row" id="fieldPrice">
		<div class="col-xs-6 col-md-3">
			<label class="control-label" for="price"><span lang="es">#t_price#</span> <span lang="es">#itemTypeNameEs#</span>: *</label>
			<cfinput type="text" name="price" id="price" class="form-control" value="#objectItem.price#" required="true" validate="float" message="#t_price# debe ser un número entero o decimal" passthrough="#passthrough#" placeholder="Valor">
		</div>
	</div>
</cfif>

<cfif read_only IS false AND itemTypeId IS 20><!--- DoPlanning Document --->

	<cfif page_type IS 1 OR objectItem.user_in_charge EQ SESSION.user_id>

		<div class="row">
			<div class="col-xs-12 col-sm-8">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="area_editable" id="area_editable" value="true" <cfif isDefined("objectItem.area_editable") AND objectItem.area_editable IS true>checked="checked"</cfif> /> <span lang="es">Documento editable por los usuarios del área</span>
					</label>
					<small class="help-block" lang="es">Permite que los usuarios del área puedan editar el documento y habilita el sistema de bloqueo del documento</small>
				</div>
			</div>
		</div>

	</cfif>

	<cfif isDefined("objectItem.area_editable") AND objectItem.area_editable IS true>
		<div class="row">
			<div class="col-xs-12">

				<div class="checkbox">
				    <label>
				    	<input type="checkbox" name="unlock" value="true" checked><span lang="es">Desbloquear archivo tras guardar modificación</span>
				    </label>
				    <small class="help-block" lang="es">Si el archivo está bloqueado no puede ser editado por otros usuarios</small>
			  	</div>

			</div>
		</div>
	<cfelseif page_type NEQ 1>

		<input type="hidden" name="unlock" value="true" checked>

	</cfif>

</cfif>

<div class="row">
	<div class="col-xs-12">

		<div style="clear:both; height:15px;"><!-- --></div>

	</div>
</div>


<cfif itemTypeId IS 17><!--- Mailing --->

	<cfif page_type IS 1>

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/ItemTemplate" method="getTemplates" returnvariable="getTemplates">
		</cfinvoke>

		<cfset mailingTemplate = getTemplates.templates>

		<cfif mailingTemplate.recordCount GT 0>

			<!---<cfset querySetCell(objectItem, template_id, mailingTemplate.template_id )>
			<cfset querySetCell(objectItem, content_styles, mailingTemplate.content_styles )>
			<cfset querySetCell(objectItem, head_content, mailingTemplate.head_content )>
			<cfset querySetCell(objectItem, foot_content, mailingTemplate.foot_content )>--->

			<cfset objectItem.template_id = mailingTemplate.template_id>
			<cfset objectItem.content_styles = mailingTemplate.content_styles>
			<cfset objectItem.head_content = mailingTemplate.head_content>
			<cfset objectItem.foot_content = mailingTemplate.foot_content>

		<cfelse>

			<!---<cfset querySetCell(objectItem, template_id, "" )>
			<cfset querySetCell(objectItem, content_styles, "" )>
			<cfset querySetCell(objectItem, head_content, "" )>
			<cfset querySetCell(objectItem, foot_content, "" )>--->

			<cfset objectItem.template_id = "">
			<cfset objectItem.content_styles = "">
			<cfset objectItem.head_content = "">
			<cfset objectItem.foot_content = "">

		</cfif>

	</cfif>

	<input type="hidden" name="template_id" value="#objectItem.template_id#" />
	<input type="hidden" name="content_styles" value="#objectItem.content_styles#" />

	<div class="row">
		<div class="col-md-12" style="margin-bottom:10px;">
				<label for="head_content" lang="es">Encabezado del email:</label>
				<textarea name="head_content" id="head_content" class="form-control" style="height:200px;" readonly="readonly">#objectItem.head_content#</textarea>
		</div>
	</div>


</cfif>

<div class="row">

	<div class="col-md-12">

		<cfif itemTypeId IS 17>
			<label for="summernote" lang="es">Contenido del email:</label>
		<cfelse>
			<label class="sr-only" for="summernote" lang="es">Contenido</label>
		</cfif>

<!---style="margin-bottom:10px; margin-top:5px;"---><textarea name="description" class="form-control summernote" id="summernote" style="height:200px;" <cfif read_only IS true>readonly="readonly"</cfif>>#objectItem.description#</textarea>

	</div>

</div>

<cfif itemTypeId IS 17><!--- Mailing --->

	<div class="row">
		<div class="col-md-12" style="margin-top:10px;">
			<cfif itemTypeId IS 17>
				<label for="foot_content" lang="es">Pie del email:</label>
			</cfif>
			<textarea name="foot_content" id="foot_content" class="form-control" style="height:200px;" readonly="readonly">#objectItem.foot_content#</textarea>
			<cfif itemTypeId IS 17><!---Mailing--->
				<small class="help-block" lang="es">Si aplicas formato al contenido del email, el aspecto que visualizará el usuario podrá variar dependiendo de su cliente de correo.</small>
			</cfif>
		</div>
	</div>

</cfif>

<div class="row">
	<div class="col-xs-12">

		<div style="height:10px;"><!-- --></div>

	</div>
</div>

<cfif read_only IS false>

	<cfif itemTypeId IS NOT 3 AND itemTypeId IS NOT 9 AND itemTypeId IS NOT 20 AND itemTypeId IS NOT 17>

		<cfif isDefined("objectItem.attached_file_name") AND len(objectItem.attached_file_name) GT 0 AND objectItem.attached_file_name NEQ "-">

			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->

				<div class="row">
					<div class="col-xs-12">

						<label class="control-label" lang="es">Archivo adjunto</label> <a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_file_id#&#itemTypeName#=#objectItem.id#" onclick="return downloadFileLinked(this,event)">#objectItem.attached_file_name#</a>

						<button onclick="return deleteAttachedFile()" class="btn btn-xs btn-danger"><i class="icon-remove"></i> <span lang="es">Eliminar archivo adjunto</span></button>

					</div>
				</div>


			<cfelse><!---Es para copiar elemento--->

				<cfif itemTypeId IS NOT 3 AND isNumeric(objectItem.attached_file_id) AND objectItem.attached_file_id GT 0><!---No es enlace y el archivo está definido--->
					<div class="row">
						<div class="col-xs-12">

							<div class="checkbox">

								<label><input type="checkbox" name="copy_attached_file_id" value="#objectItem.attached_file_id#" checked="checked" />&nbsp;<span lang="es">Archivo adjunto:</span> <span class="texto_normal">#objectItem.attached_file_name#</span>
								</label>

							</div>

						</div>
					</div>
				</cfif>

			</cfif>


		<cfelse>

			<div class="row">
				<div class="col-md-12">

					<label for="filedata" class="control-label"><i class="icon-file icon-large" title="Archivo" lang="es"></i> <span lang="es">Archivo</span>:</label>
					<cfinput type="file" name="Filedata" id="filedata">

				</div>
			</div>
		</cfif>

	</cfif>

	<cfif APPLICATION.moduleWeb IS true AND itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 20 AND itemTypeId IS NOT 17>

		<cfif isDefined("objectItem.attached_image_name") AND len(objectItem.attached_image_name) GT 0 AND objectItem.attached_image_name NEQ "-">

			<cfif isNumeric(objectItem.id)><!---No es para copiar elemento--->

				<div class="row">
					<div class="col-md-12">

						<label class="control-label" lang="es">Imagen adjunta</label> <a href="#APPLICATION.htmlPath#/file_download.cfm?id=#objectItem.attached_image_id#&#itemTypeName#=#objectItem.id#" onclick="return downloadFileLinked(this,event)">#objectItem.attached_image_name#</a>

						<button onclick="return deleteAttachedImage()" class="btn btn-xs btn-danger"><i class="icon-remove"></i> <span lang="es">Eliminar imagen adjunta</span></button>

					</div>
				</div>

			<cfelse><!---Es para copiar elemento--->

				<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND isNumeric(objectItem.attached_image_id) AND objectItem.attached_image_id GT 0><!---No es mensaje y el archivo está definido--->

					<div class="row">
						<div class="col-md-12">

							<label class="checkbox"><input type="checkbox" name="copy_attached_image_id" value="#objectItem.attached_image_id#" checked="checked" />&nbsp;<span lang="es">Imagen adjunta</span>: <span class="texto_normal">#objectItem.attached_image_name#</span>
							</label>

						</div>
					</div>

				</cfif>

			</cfif>
		<cfelse>
			<div class="row">
				<div class="col-md-12">

					<label for="imagedata" class="control-label"><i class="icon-camera icon-large" title="Imagen (jpg, png, gif)" lang="es"></i> <span lang="es">Imagen</span>: <cfif itemTypeId IS 9>*</cfif></label>
					<cfif itemTypeId IS NOT 9>
						<cfinput type="file" name="imagedata" id="imagedata" accept="image/*">
					<cfelse><!--- Image --->
						<cfinput type="file" name="imagedata" id="imagedata" accept="image/*" required="true" message="Archivo de imagen requerido">
					</cfif>

				</div>
			</div>
		</cfif>

	</cfif>
</cfif>


<cfif itemTypeId IS NOT 20 AND itemTypeId IS NOT 17><!--- IS NOT DoPlanning Document OR Mailings --->

	<fieldset>

		<legend lang="es">#t_link#</legend>

		<div class="row">

			<div class="col-xs-3 col-md-2">

				<label class="control-label" for="link"><span lang="es">URL</span>: <cfif link_required IS true>*</cfif></label>

			</div>

			<div class="col-xs-9 col-md-10">

				<cfinput type="text" name="link" id="link" value="#objectItem.link#" placeholder="http://" required="#link_required#" message="#t_link# válida con http:// requerida" class="form-control col-md-5" passthrough="#passthrough#"><!---validate="url" DA PROBLEMAS--->

			</div>

		</div>

		<cfif itemTypeId IS NOT 1 AND itemTypeId IS NOT 6 AND itemTypeId IS NOT 7 AND itemTypeId IS NOT 17><!---IS NOT Messages, Tasks, Consultations OR Mailings--->

		<div class="row">

			<div class="col-xs-3 col-md-2">

					<label class="control-label" for="link_target"><span lang="es">Abrir URL en</span>:</label>

			</div>

			<div class="col-xs-9 col-md-10">

				<select name="link_target" id="link_target" class="form-control">
					<option value="_blank" <cfif objectItem.link_target EQ "_blank">selected="selected"</cfif> lang="es">Nueva ventana</option>
					<option value="_self" <cfif objectItem.link_target EQ "_self">selected="selected"</cfif> lang="es">Misma ventana</option>
				</select>
				<cfif APPLICATION.moduleWeb EQ true><small lang="es">(Sólo para publicar en web)</small></cfif>

			</div>

		</div>

		</cfif>

	</fieldset>

</cfif>

<cfif itemTypeId IS 17><!--- Mailings --->

	<div class="row">
		<div class="col-md-12">
			<label class="control-label" for="email_addresses"><span lang="es">#t_email_addresses#</span>:</label>
			<cfinput type="text" name="email_addresses" id="email_addresses" class="form-control" value="#objectItem.email_addresses#" passthrough="#passthrough#">
			<cfif itemTypeId IS 17>
				<small class="help-block" lang="es">Introduce la lista de direcciones de email separadas por ; (hasta 5 direcciones).</small>
			</cfif>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<div class="checkbox">
				<label>
					<input type="checkbox" name="send_to_test_users" id="send_to_test_users" value="true" <cfif NOT isDefined("objectItem.send_to_test_users") OR objectItem.send_to_test_users IS true>checked="checked"</cfif> /> <span lang="es">Enviar prueba a destinatarios para pruebas</span>
				</label>
				<small class="help-block" lang="es">Si seleccionas esta opción se enviará el boletín a los destinatarios anteriores, podrá modificarlo y volver a enviarlo posteriormente.</small>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<div class="checkbox">
				<label>
					<input type="checkbox" name="send_to_area_users" id="send_to_area_users" value="true" <cfif isDefined("objectItem.send_to_area_users") AND objectItem.send_to_area_users IS true>checked="checked"</cfif> /> <span lang="es">Enviar boletín</span>
				</label>
				<small class="help-block" lang="es">CUIDADO: Si seleccionas esta opción se enviará de forma definitiva el boletín a todos los usuarios del área y ya no podrá modificarlo.</small>
			</div>
		</div>
	</div>

</cfif>


<!---Categories--->
<cfinclude template="#APPLICATION.htmlPath#/includes/area_item_categories_inputs.cfm">

<cfif itemTypeId IS 2 OR itemTypeId IS 4 OR itemTypeId IS 5>

	<cfif APPLICATION.moduleWeb EQ true>

	<div class="row">

		<div class="col-md-12"></div>

	</div>

	<fieldset>

		<legend><span lang="es">Incrustar contenido</span> <small lang="es">(Sólo para publicar en web)</small></legend>

		<div class="row">

			<div class="col-xs-3 col-md-2">

				<label class="control-label" for="iframe_url"><span lang="es">URL</span>:</label>

			</div>

			<div class="col-xs-9 col-md-10">

				<cfinput type="text" name="iframe_url" id="iframe_url" value="#objectItem.iframe_url#" placeholder="http://" message="URL válida con http:// requerida" class="form-control col-md-5" passthrough="#passthrough#"><!---validate="url" DA PROBLEMAS--->

			</div>

		</div>

		<div class="row">

			<div class="col-xs-3 col-md-2">

				<label class="control-label" for="iframe_display_type_id"><span lang="es">#t_iframe_display_type#</span>:</label>

			</div>

			<div class="col-xs-9 col-md-10">

				<cfinvoke component="#APPLICATION.componentsPath#/IframeDisplayTypeManager" method="getDisplayTypes" returnvariable="iframeDisplayTypeQuery">
				</cfinvoke>

				<select name="iframe_display_type_id" id="iframe_display_type_id" class="form-control" <cfif read_only IS true>disabled="disabled"</cfif>>
					<cfloop query="iframeDisplayTypeQuery">
						<option value="#iframeDisplayTypeQuery.iframe_display_type_id#" <cfif objectItem.iframe_display_type_id IS iframeDisplayTypeQuery.iframe_display_type_id>selected="selected"</cfif>>#iframeDisplayTypeQuery.iframe_display_type_title_es#</option>
					</cfloop>
				</select>

			</div>

		</div>

	</fieldset>


	<!---<cfset t_iframe_width = "Ancho">
	<cfset t_iframe_height = "Alto">

	<div class="form-group">
		<label class="control-label" for="iframe_width">#t_iframe_width#</label>

		<cfinput type="text" name="iframe_width" id="iframe_width" value="" required="true" message="#t_iframe_width# válido requerido" validate="integer" passthrough="#passthrough#" style="width:55px;"><!---#objectItem.iframe_width#--->

		&nbsp;<label class="control-label" for="iframe_height">#t_iframe_height#</label>

		<cfinput type="text" name="iframe_height" id="iframe_height" value="" required="true" message="#t_iframe_height# válido requerido" validate="integer" passthrough="#passthrough#" style="width:55px;">

	</div>
	--->

	<cfelse>
		<!--- Este valor es necesario porque la columna en la que se almacena tiene una referencia con otra tabla --->
		<input type="hidden" name="iframe_display_type_id" value="#objectItem.iframe_display_type_id#"/>

	</cfif>


</cfif>

<cfif itemTypeId IS 2 OR itemTypeId IS 3 OR itemTypeId IS 4><!---Entries, Links, News--->

	<!---<cfif SESSION.client_abb EQ "hcs">

		<div class="row">

			<div class="col-md-6">

				<label class="control-label" lang="es">#t_position#</label>

				<cfinput type="text" name="position" id="position" value="#objectItem.position#" required="true" validate="integer" message="#t_position# debe ser un número entero" style="width:50px;" passthrough="#passthrough#">

			</div>

		</div>

	</cfif>--->

	<cfif itemTypeId IS 2>
	<div class="row">

		<div class="col-md-6">

			<label class="control-label"><span lang="es">#t_display_type#</span>:</label> <small lang="es">(Sólo para publicar en web)</small>

			<cfinvoke component="#APPLICATION.componentsPath#/DisplayTypeManager" method="getDisplayTypes" returnvariable="displayTypeQuery">
			</cfinvoke>

			<select name="display_type_id" class="form-control" <cfif read_only IS true>disabled="disabled"</cfif>>
				<cfloop query="displayTypeQuery">
					<option value="#displayTypeQuery.display_type_id#" <cfif objectItem.display_type_id IS displayTypeQuery.display_type_id>selected="selected"</cfif>>#displayTypeQuery.display_type_title_es#</option>
				</cfloop>
			</select>

		</div>

	</div>
	</cfif>

</cfif>

<cfif itemTypeId IS 4 OR itemTypeId IS 5 OR itemTypeId IS 8><!---News, events and publications--->

	<cfif len(area_type) GT 0>

		<cfinvoke component="#APPLICATION.componentsPath#/WebManager" method="getWebFromArea" returnvariable="getWebsResult">
			<cfinvokeargument name="area_id" value="#area_id#">
		</cfinvoke>

		<cfif getWebsResult.result IS true>

			<cfset webQuery = getWebsResult.query>
			<cfset web_path_url = webQuery.path_url>
			<cfset web_language = webQuery.language>

		<cfelse>

			<cfset web_path_url = "">
			<cfset web_language = APPLICATION.defaultLanguage>

		</cfif>

	<cfelse>

		<cfset web_path_url = "">
		<cfset web_language = APPLICATION.defaultLanguage>

	</cfif>

	<cfif web_language EQ "es">
		<cfset pagePath = lcase(itemTypeNameEsP)>
	<cfelse>
		<cfif itemTypeId IS 4><!---News--->
			<cfset pagePath = itemTypeName>
		<cfelse>
			<cfset pagePath = itemTypeNameP>
		</cfif>
	</cfif>

	<script>

		$(function () {

			var urlIdInput = "##url_id_suffix";

			$(urlIdInput).focus( function() {

				var pageNameUrl = $('##item_title').val();

				if(pageNameUrl.length == 0){

					bootbox.alert(window.lang.translate("Debe introducir un título"), function(){

						$('##item_title').focus();

					});

				} else {

					if(	$(urlIdInput).val().length == 0 ) {

						$(urlIdInput).val(pageNameToUrl(pageNameUrl));
					}
				}

			});

			$(urlIdInput).mask("A", {
				translation: {
					"A": { pattern: /[\w\-.]/, recursive: true }
				}
			});

			$('##item_title').focusout( function() {

				var pageNameUrl = $('##item_title').val();

				if(	$(urlIdInput).val().length == 0 ) {
					$(urlIdInput).val(pageNameToUrl(pageNameUrl));
				}

			});


		});

	</script>

	<div class="row">

		<div class="col-md-12">

			<label class="control-label" for="url_id"><span lang="es">URL de la página</span>:</label> <small lang="es">(Sólo para publicar en web)</small>

			<div class="input-group">
				<cfif isDefined("web_path_url") AND len(web_path_url) GT 0>
			  	<span class="input-group-addon">#web_path_url#/<span id="url_id_prefix">#pagePath#/</span></span>
				</cfif>
				<input type="text" name="url_id_suffix" id="url_id_suffix" value="#listLast(objectItem.url_id,'/')#" class="form-control" passthrough="#passthrough#">
				<input type="hidden" name="url_id" id="url_id" value="#pagePath#/#listLast(objectItem.url_id,'/')#" />
			</div>

		</div>

	</div>

</cfif>

</cfoutput>

<cfif APPLICATION.identifier NEQ "dp"><!---SMS Deshabilitado para DoPlanning--->
	<cfif objectUser.sms_allowed IS true>
		<cfoutput>

		<div class="row">
			<div class="col-md-12">

				<label class="checkbox">
				<img src="#APPLICATION.htmlPath#/assets/v3/icons/sms.png" alt="Enviar SMS"/> <cfinput type="checkbox" name="notify_by_sms" value="true" title="Enviar notificación por SMS"> Enviar notificación por SMS
				</label>

			 </div>
		</div>

		</cfoutput>
	</cfif>
</cfif>

<cfif itemTypeId NEQ 1 AND itemTypeId NEQ 17>

	<!--- getClient --->
	<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>

	<cfif clientQuery.force_notifications IS false>

		<div class="row">
			<div class="col-md-12">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="no_notify" id="no_notify" value="true" <cfif isDefined("objectItem.no_notify") AND objectItem.no_notify IS true>checked="checked"</cfif> /> <span lang="es">NO enviar notificación por email</span>
					</label>
					<small class="help-block" lang="es">Si seleccionas esta opción no se enviará notificación instantánea por email de esta acción a los usuarios.</small>
				</div>
			</div>
		</div>

	</cfif>

</cfif>



<div style="clear:both"></div>

<cfif editorApp IS "summernote"><!---Messages o DP Documents--->

<script>
	$(document).ready(function() {

		<!---<cfoutput>
		document.emojiSource = '#APPLICATION.htmlPath#/assets/emojis'; //relative path to emojis
		</cfoutput>--->

		$('#summernote').summernote({
			height: 300

			<!---
			Esto da problemas en Internet Explorer
			, onChange: function(contents, $editable) {
			    preventClose = true;
			}
			--->

			, disableDragAndDrop: true,
			maximumImageFileSize: 40960,
			toolbar: [
			    ['style', ['style']],
			    ['font', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'clear']],
			    ['fontname', ['fontname']],
			    ['color', ['color']],
			    ['para', ['ul', 'ol', 'paragraph']],
			    ['height', ['height']],
			    ['table', ['table']],
			    ['insert', ['link', 'picture', 'hr']],
			    ['view', ['fullscreen']],
			    ['help', ['help']]
			    <!---, ['misc', ['emoji']]--->
			  ]
			<cfif SESSION.user_language EQ "es">
				, lang: 'es-ES'
			</cfif>
		});
	});
</script>

<cfelse>

	<!---<cfif itemTypeId IS 17 AND len(objectItem.content_styles) GT 0>
		<cfoutput>
			<script>
				CKEDITOR.on( 'instanceReady', function( event ){
						event.editor.addCss("body{ #objectItem.content_styles# }");
				});
			</script>
		</cfoutput>
	</cfif>--->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
		<cfinvokeargument name="name" value="description">
		<cfinvokeargument name="language" value="#SESSION.user_language#"/>
		<!---
		<cfif itemTypeId IS 1 OR itemTypeId IS 6><!--- Message, Task --->
			<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
			<cfinvokeargument name="toolbarCanCollapse" value="true"/>
		</cfif>--->
		<cfif itemTypeId IS 20 OR itemTypeId IS 17><!--- DoPlanning Document --->
			<cfinvokeargument name="height" value="500"/>
			<cfinvokeargument name="toolbar" value="DP_document"/>
		</cfif>
	</cfinvoke>

</cfif>

<cfif itemTypeId IS 17><!--- Mailing --->

	<cfoutput>
		<cfif page_type IS 1>

			<cfif isDefined("mailingTemplate.template_id") AND isNumeric(mailingTemplate.template_id)>
				<script>
					CKEDITOR.config.contentsCss = '#APPLICATION.htmlPath#/mailing_styles.cfm?template=#mailingTemplate.template_id#';
				</script>
			</cfif>

		<cfelse>

			<script>
				CKEDITOR.config.contentsCss = '#APPLICATION.htmlPath#/mailing_styles.cfm?mailing=#item_id#';
			</script>

		</cfif>
	</cfoutput>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
		<cfinvokeargument name="name" value="head_content">
		<cfinvokeargument name="language" value="#SESSION.user_language#"/>
		<cfinvokeargument name="height" value="100"/>
		<cfinvokeargument name="toolbar" value="DP_document"/>
		<cfinvokeargument name="readOnly" value="true"/>
		<cfinvokeargument name="toolbarCanCollapse" value="true"/>
		<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
		<cfinvokeargument name="removePlugins" value="elementspath,wordcount,toolbar"/>
		<cfinvokeargument name="allowedContent" value="true">
		<cfinvokeargument name="resize_enabled" value="false">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
		<cfinvokeargument name="name" value="foot_content">
		<cfinvokeargument name="language" value="#SESSION.user_language#"/>
		<cfinvokeargument name="height" value="100"/>
		<cfinvokeargument name="toolbar" value="DP_document"/>
		<cfinvokeargument name="readOnly" value="true"/>
		<cfinvokeargument name="toolbarCanCollapse" value="true"/>
		<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
		<cfinvokeargument name="removePlugins" value="elementspath,wordcount,toolbar"/>
		<cfinvokeargument name="allowedContent" value="true">
		<cfinvokeargument name="resize_enabled" value="false">
	</cfinvoke>

</cfif>
