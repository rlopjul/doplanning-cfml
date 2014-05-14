/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	
	config.skin = 'moonocolor';
	
	config.toolbar_Full =
	[
		['Source','-','Save','NewPage','Preview','-','Templates'],
		['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'],
		['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
		'/',
		['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
		['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['Link','Unlink','Anchor'],
		['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak'],
		'/',
		['Styles','Format','Font','FontSize'],
		['TextColor','BGColor'],
		['Maximize', 'ShowBlocks','-','About']
	];
	
	config.toolbar_Basic =
	[
		['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-','About']
	];
	
	config.toolbar_DP =
	[		
		['Undo','Redo','-','Bold','Italic','Underline','Strike','-','Subscript','Superscript','RemoveFormat'],
		['PasteText','PasteFromWord','-','Find','Replace','SelectAll','-','ShowBlocks','Maximize'],
		['FontSize','TextColor','BGColor'],
		['NumberedList','BulletedList'],
		['Link','Unlink','-','Table','HorizontalRule','SpecialChar','Smiley'],
		['Image']
	];

	config.toolbar_DPAdmin =
	[		
		['Undo','Redo','-','Bold','Italic','Underline','Strike','-','Subscript','Superscript','RemoveFormat'],['Source'],
		['PasteText','PasteFromWord','-','Find','Replace','SelectAll','-','ShowBlocks','Maximize'],
		['Format','FontSize','TextColor','BGColor'],
		['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
		['Link','Unlink','-','Table','HorizontalRule','SpecialChar','Smiley'],
		['Image','Flash','Iframe']
	];
	
	//Para que solo se pueda introducir texto plano
	config.forcePasteAsPlainText = true;

	//Para que no se conviertan los caracteres especiales en entidades HTML
	config.entities_greek = false;
	config.entities_latin = false;
	config.entities_processNumerical = false;

	config.filebrowserBrowseUrl = '../../app/filemanager/index.html';

	//Para permitir etiquetas <script> (necesario para subir animaciones html en nanomyp)
	config.extraAllowedContent = 'script[src]';
};
