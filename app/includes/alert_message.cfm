<cfif isDefined("URL.msg")>
	
	<cfset msg = URLDecode(URL.msg)>
	<!---<cfoutput>
	
		<cfif NOT isDefined("URL.res") OR URL.res IS 1>
			<div class="alert alert-success">
				<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
				<span lang="es">#msg#</span>
			</div>
		<cfelse>
			<div class="alert alert-danger">
				<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
				<i class="icon-warning-sign"></i> <span lang="es">#msg#</span>
			</div>
		</cfif>
		
	</cfoutput>--->

	<div id="pageAlertContainer" style="display:none;">
	  <button type="button" class="close" data-dismiss="alert">&times;</button>
	</div>

	<cfif isDefined("URL.res")>

		<cfset msg_res = URL.res>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryStringDeleteVar" returnvariable="newQueryString">
			<cfinvokeargument name="variable" value="msg,res">
		</cfinvoke>

	<cfelse>

		<cfset msg_res = 0>

		<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="queryStringDeleteVar" returnvariable="newQueryString">
			<cfinvokeargument name="variable" value="msg">
		</cfinvoke>

	</cfif>

	<cfif len(newQueryString) GT 0>
		<cfset newUrl = "#CGI.SCRIPT_NAME#?#newQueryString#">
	<cfelse>
		<cfset newUrl = "#CGI.SCRIPT_NAME#">
	</cfif>

	
	<script>

		function showPageAlertMessage(msg, res){

			if($("#pageAlertContainer span").length != 0)
				$("#pageAlertContainer span").remove();

			if(res == true)
				$("#pageAlertContainer").attr("class", "alert alert-success");
			else
				$("#pageAlertContainer").attr("class", "alert alert-danger");
			
			$("#pageAlertContainer button").after('<span>'+window.lang.translate(msg)+'</span>');

			$("#pageAlertContainer").fadeIn('slow');

			<!---setTimeout(function(){
				    
			    hidePageAlertMessage();

			    }, 9500);--->	
		}

		function hidePageAlertMessage(){

			$("#pageAlertContainer").fadeOut('slow', function() {
			    $("#pageAlertContainer span").remove();
			});

		}

		<cfoutput>
		$(function () {

			showPageAlertMessage('#msg#', #msg_res#);

		    History.replaceState(History.getState().data, History.options.initialTitle, "#newUrl#");

		});
		</cfoutput>

		<!---(function(window,undefined){

		    // Bind to StateChange Event
		    History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
		        var State = History.getState(); // Note: We are using History.getState() instead of event.state
		    });

		})(window);--->

	</script>

<cfelseif isDefined("URL.message") AND NOT isNumeric(URL.message)>

	<cfset alert_message_text = URLDecode(URL.message)>
	<cfoutput>
		<div class="alert alert-warning">
			<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
			<span lang="es">#alert_message_text#</span>
		</div>
	</cfoutput>

</cfif>