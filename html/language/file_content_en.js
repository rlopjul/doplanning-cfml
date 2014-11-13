var file_content_en = {
	"token": {
		'Si ELIMINA el archivo, se borrará de TODAS las áreas a las que esté asociado. ¿Seguro que desea borrar el archivo?':'If you DELETE the file, it will be deleted from ALL areas to which it is associated. Are you sure you want to delete the file?',
		
		'Descargar':'Download',
		'Abrir':'Open',
		'Visualizar':'View',
		'Reemplazar':'Replace',
		'Ampliar':'Enlarge',
		'Abrir en nueva ventana':'Open in new window',
		'Asociar a áreas':'Associate to areas',
		'Modificar datos':'Modify data',
		'Quitar del área':'Remove from area',
		'Eliminar':'Delete',
		'Visualizar en':'View in',
		'Versiones':'Versions',
		'Validar versión':'Validate version',
		'Rechazar versión':'Reject version',
		'Cancelar revisión':'Cancel revision',
		'Bloquear':'Lock',
		'Desbloquear':'Unlock',
		'Cambiar propietario':'Change owner',
		
		'Propiedad del área':'Property of area',	
		'Creado por':'Created by',
		'Último reemplazo por':'Last version by',
		'Última version por':'Last version by',
		'Revisor':'Reviser user',
		'Aprobador':'Approval user',
		'Nombre de archivo':'File name',
		'Fecha de creación':'Creation date',
		'Fecha de reemplazo':'Replacement date',
		'Fecha de última versión':'Last version date',
		'Fecha de publicación':'Publication date',
		'Fecha de envío a revisión':'Send to revision date',
		'Tipo de archivo':'File type',
		'Tamaño':'Size',
		'Descripción':'Description',
		'Generando archivo...':'Generating file...',
		'Tipología':'Typology',
		'Ámbito de publicación':'Publication scope',
		'Nombre físico':'Physical name',
		'Motivo de rechazo en aprobación':'Reason for rejection on approval',
		'Motivo de rechazo en revisión':'Reason for rejection on revision',
		'Analizado por Antivirus':'Analyzed by Antivirus',
		
		/*area_file_new.cfm*/
		'Nuevo Archivo':'New File',	
		'Nuevo Archivo de área':'New area File',
		'Archivo':'File',
		'Nombre':'Name',
		'Enviar':'Send',
		'Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.':'After clicking the button, the application will take depending on the file size.',
		'Enviando archivo...':'Sending file...',

		'Este archivo te pertenecerá a ti y sólo tú podrás modificarlo. Cada vez que subas una versión del archivo se sobreescribirá la anterior.':'This file will belong to you and only you can change it. Each time you upload a file version will overwrite the previous.',

		'Este archivo pertenecerá a esta <b>área</b> y podrá ser modificado por cualquier usuario con acceso a la misma.':'This file will belong to this <b>area</b> and anyone with access to this area will be able to modify it.',

		'<b>Sin circuito de calidad</b>: cada vez que se suba una versión del archivo se sobreescribirá la anterior (no se guardan las versiones previas del archivo)</p><br><b>Con circuito de calidad</b>: se guardan las distintas versiones del archivo y es requerido un proceso de revisión y aprobación de las versiones.':
		'<b>Without quality circuit</b>: each time a file is uploaded will overwrite the previous version (previous versions of the file are not saved)</p><br><b>With quality circuit</b>: different versions of the file are saved and is required a process of review and approval of the versions',

		'Área de publicación':'Publication area',
		'Seleccionar área':'Select area',
		'Tipo de documento de área':'Area document type',
		'Sin circuito de calidad':'Without quality circuit',
		'Con circuito de calidad':'With quality circuit',
		'Esta opción no se puede cambiar una vez creado el documento':'This option can not be changed after the creation of the document',
		'Usuario revisor':'Reviser user',
		'Usuario aprobador':'Approval user',
		'Seleccionar usuario':'Select user',
		'Básica':'Basic',

		'Define dónde se podrá publicar el documento':'Set the areas where the document can be published',

		'Si está definida, el archivo se publicará en la fecha especificada (sólo para publicación en web e intranet).':'If set, the file will be published on the specified date (for publication on web and intranet only).',

		'Aprobar publicación':'Approve publication',
		'Valida el archivo para que pueda ser publicado (sólo para publicación en web e intranet).':'Validates the file so that it can be published (only for publication on website and intranet)',

		'* Campos obligatorios.':'* Required fields',
		/*END area_file_new.cfm*/
		
		/*area_file_modify.cfm*/
		'Modificar Archivo':'Modify File',
		'Enviando...':'Sending...',
		'Guardar':'Save',
		'Cancelar':'Cancel',
		/*END area_file_modify.cfm*/
		
		/*area_file_replace.cfm*/
		'Reemplazar Archivo':'Replace File',
		/*END area_file_replace.cfm*/
		
		/*area_file_upload.cfm, area_file_replace_upload.cfm*/
		'Ha ocurrido un error al subir el archivo.':'Failed to upload the file',
		'Archivo reemplazado correctamente.':'File replaced.',
		/*END area_file_upload.cfm, area_file_replace_upload.cfm*/
		
		/*file_associate.cfm*/
		'Asociar archivo al área':'Associate file to area',
		/*END file_associate.cfm*/
		
		/*file_view_content.cfm*/
		'Visualizar archivo':'View file',
		'Volver':'Back',
		/*END file_view_content.cfm*/

		/*file.cfm*/
		'Debe bloquear el archivo para poder realizar cualquier modificación.':'You have to lock the file to make any changes.',
		'URL del archivo en DoPlanning':'File URL in DoPlanning',
		'URL de descarga desde DoPlanning':'Download URL from DoPlanning',
		/*END file.cfm*/

		/*search_2_bar.cfm*/
		'Todas':'All',
		'Se muestran las tipologías usadas en al menos un archivo':'The typologies listed are used at least in one file'
		/*END search_2_bar.cfm*/
	}
};
$.extend(Lang.prototype.pack.en.token, file_content_en.token);