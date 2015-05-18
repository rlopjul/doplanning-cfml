<cfoutput>
<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.min.js?v=2.2"></script>
<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.widgets.min.js?v=2.2"></script>
<script src="#APPLICATION.path#/jquery/tablesorter/widgets/widget-math.min.js?v=2.2"></script>
<script src="#APPLICATION.path#/jquery/tablesorter/widgets/widget-columnSelector.min.js?v=2.2"></script>

<script src="#APPLICATION.path#/jquery/jquery.doubleScroll.js"></script>

<!---
<cfset curPageFile = GetFileFromPath(CGI.SCRIPT_NAME)>
<cfif curPageFile NEQ "area_items.cfm" AND curPageFile NEQ "list_rows.cfm" AND curPageFile NEQ "form_rows.cfm" AND curPageFile NEQ "all_users.cfm" AND curPageFile NEQ "lists_search.cfm"><!---En esta página no se cargan estos scripts que yan no son necesarios y porque dan problemas en los navegadores cuando hay muchos registros--->
	<script src="#APPLICATION.path#/jquery/jquery-migrate-1.2.1.min.js"></script><!---Se añade este script para poder seguir usando jquery.tablesorter.extras-0.1.22.min.js ya que usa la funcion  $.browser--->
	<script src="#APPLICATION.path#/jquery/tablesorter/jquery.tablesorter.extras-0.1.22.min.js"></script>
</cfif>
--->

<!---<link href="#APPLICATION.path#/jquery/tablesorter/css/style.min.css" rel="stylesheet" media="all" />--->

<link href="#APPLICATION.path#/jquery/tablesorter/css/theme.bootstrap.min.css" rel="stylesheet" media="all" />
</cfoutput>

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

	$.tablesorter.themes.bootstrap = {
	    // these classes are added to the table. To see other table classes available,
	    // look here: http://getbootstrap.com/css/#tables
	    table        : 'table table-bordered table-striped',
	    caption      : 'caption',
	    // header class names
	    header       : 'bootstrap-header', // give the header a gradient background (theme.bootstrap_2.css)
	    sortNone     : '',
	    sortAsc      : '',
	    sortDesc     : '',
	    active       : '', // applied when column is sorted
	    hover        : '', // custom css required - a defined bootstrap style may not override other classes
	    // icon class names
	    icons        : '', // add "icon-white" to make them white; this icon class is added to the <i> in the header
	    iconSortNone : 'fa fa-sort', // class name added to icon when column is not sorted
	    iconSortAsc  : 'fa fa-sort-asc', // class name added to icon when column has ascending sort
	    iconSortDesc : 'fa fa-sort-desc', // class name added to icon when column has descending sort
	    filterRow    : '', // filter row class
	    footerRow    : '',
	    footerCells  : '',
	    even         : '', // even row zebra striping
	    odd          : ''  // odd row zebra striping
	  };
		
</script>