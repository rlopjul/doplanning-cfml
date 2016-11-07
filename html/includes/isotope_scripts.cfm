<script src="//cdnjs.cloudflare.com/ajax/libs/jquery.isotope/2.2.2/isotope.pkgd.min.js"></script>
<script src="//npmcdn.com/imagesloaded@4.1/imagesloaded.pkgd.min.js"></script>


<cfoutput>
<script>
<!---/**
 * Remove Accents to a string
 */
String.prototype.removeAccents = function() {
  return this
    .toLowerCase()
    .replace(/[áàãâä]/gi, "a")
    .replace(/[éèëê]/gi, "e")
    .replace(/[íìïî]/gi, "i")
    .replace(/[óòöôõø]/gi, "o")
    .replace(/[úùüû]/gi, "u")
    .replace(/[ç]/gi, "c")
    .replace(/[ñ]/gi, "n")
    .replace(/[^a-zA-Z0-9]/g, " ");
}--->

var itemTypesStruct = #serializeJSON(itemTypesStruct)#;

var $itemsContainer;

function setItemsFilter(filterValue) {

	if(filterValue == "*") {

		$itemsContainer.isotope({ filter: filterValue });

    var itemsCounter = $itemsContainer.data('isotope').filteredItems.length;
    $("##totalItemsValue").text(itemsCounter);

		$("##curFilterImg").attr("src", "#APPLICATION.htmlPath#/assets/v3/icons_dp/area.png");

		<cfif isDefined("area_id")>
			<!---$("##curFilterLabel").text(window.lang.translate("Elementos del área"));--->
			$("##curFilterLabel").text("Elementos del área");
			$("##listModeLink").attr("href", "area_items.cfm?area=#area_id#&mode=list");
			$("##listModeLink").show();
      //$("##totalItemsLabel").show();
		<cfelse>
			$("##curFilterLabel").text("Elementos de área");
		</cfif>

	} else {

    //$("##totalItemsLabel").hide();

		var filterBy = "."+filterValue;

		$itemsContainer.isotope({ filter: filterBy });

		jQuery.each(itemTypesStruct, function(index, itemType) {

			if(itemType.name == filterValue) {

        var itemsCounter = $itemsContainer.data('isotope').filteredItems.length;
        $("##totalItemsValue").text(itemsCounter);

				<!---$("##curFilterLabel").text(window.lang.translate(itemType.labelPlural));--->
				$("##curFilterLabel").text(itemType.labelPlural);
				$("##curFilterImg").attr("src", "#APPLICATION.htmlPath#/assets/v3/icons/"+itemType.name+".png");

				<cfif isDefined("area_id")>
					$("##listModeLink").attr("href", itemType.namePlural+".cfm?area=#area_id#");

					if(filterValue == "list_view" || filterValue == "form_view")
						$("##listModeLink").hide();
					else
						$("##listModeLink").show();


				</cfif>

			}

		});

	}

}

function setItemsSort(sortValue) {

	$itemsContainer.isotope({ sortBy: sortValue });

}

$( document ).ready( function() {

  <!--- init Isotope --->

  $itemsContainer = $('.elements_container').imagesLoaded( function() {

		$itemsContainer.isotope({
	    itemSelector: '.element_item',
	    layoutMode: 'vertical',
	    transitionDuration: 0 <!--- en iPad las transiciones dan problemas https://github.com/metafizzy/isotope/issues/502--->
	  });

	});

  <cfif isDefined("URL.filter")>

	setItemsFilter("#URL.filter#");

  </cfif>

});
</script>

</cfoutput>
