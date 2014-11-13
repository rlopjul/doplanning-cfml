/* Archivo con traducciones generales que se aplican a distintos contenidos*/

var area_menu_en_regex = {

	"regex": [
		[/^Descripción:?$/, "Description"],
		[/^Responsable:?$/, "Responsible"],
		[/^Fecha de creación:?$/, "Creation date"]
	]

};
$.extend(Lang.prototype.pack.en, area_menu_en_regex);