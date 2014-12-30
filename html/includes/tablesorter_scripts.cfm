<cfoutput>
<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js?v=2.18"></script>
<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.widgets.min.js?v=2.18"></script>
<script src="#APPLICATION.path#/jquery/tablesorter/widgets/widget-math.js?v=2.1"></script>

<cfset curPageFile = GetFileFromPath(CGI.SCRIPT_NAME)>
<cfif curPageFile NEQ "area_items.cfm" AND curPageFile NEQ "list_rows.cfm" AND curPageFile NEQ "form_rows.cfm" AND curPageFile NEQ "all_users.cfm"><!---En esta página no se cargan estos scripts que yan no son necesarios y porque dan problemas en los navegadores cuando hay muchos registros--->
	<script src="#APPLICATION.path#/jquery/jquery-migrate-1.2.1.min.js"></script><!---Se añade este script para poder seguir usando jquery.tablesorter.extras-0.1.22.min.js ya que usa la funcion  $.browser--->
	<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
</cfif>

<link href="#APPLICATION.path#/jquery/tablesorter/css/style.min.css" rel="stylesheet" media="all" />

<script>
	
	$.tablesorter.addParser({
		id: "datetime",
		is: function(s) {
			return false; 
		},
		format: function(s,table) {
			s = s.replace(/\-/g,"/");
			s = s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/, "$3/$2/$1");
			return $.tablesorter.formatFloat(new Date(s).getTime());
		},
		type: "numeric"
	});
		
</script>
</cfoutput>