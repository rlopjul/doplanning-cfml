/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
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
    ['Format','FontSize','TextColor','BGColor'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['Link','Unlink','Anchor','-','Table','HorizontalRule','SpecialChar','Smiley'],
    ['Image'],['InsertPre']
  ];

  config.toolbar_DP_hcs =
  [
    ['Undo','Redo','-','Bold','Italic','Underline','Strike','-','Subscript','Superscript','RemoveFormat'],
    ['PasteText','PasteFromWord','-','Find','Replace','SelectAll','-','ShowBlocks','Maximize'],
    ['Format','FontSize','TextColor','BGColor'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['Link','Unlink','Anchor','-','Table','HorizontalRule','SpecialChar']
  ];/*,['InsertPre']*/

  config.toolbar_DP_document =
  [
    ['Undo','Redo','-','Bold','Italic','Underline','Strike','-','Subscript','Superscript','RemoveFormat'],
    ['PasteText','PasteFromWord','-','Find','Replace','SelectAll','-','ShowBlocks','Maximize'],
    ['Format','FontSize','TextColor','BGColor'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ['Link','Unlink','Anchor','-','Table','HorizontalRule','SpecialChar'],
    ['Image'],['InsertPre']
  ];

  config.toolbar_DPAdmin =
  [
    ['Undo','Redo','-','Bold','Italic','Underline','Strike','-','Subscript','Superscript','RemoveFormat'],['Source'],
    ['PasteText','PasteFromWord','-','Find','Replace','SelectAll','-','ShowBlocks','Maximize'],
    ['Format','FontSize','TextColor','BGColor'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
    ['Link','Unlink','Anchor','-','Table','HorizontalRule','SpecialChar','Smiley'],
    ['Image','Flash','Iframe'],['InsertPre'],['TweetableText']
  ];

  //Insert pre tag plugin
  //config.extraPlugins = 'insertpre';
  //config.insertpre_class = '';

  //config.extraPlugins = 'tweetabletext,autogrow';
  config.autoGrow_onStartup = true;
  //config.autoGrow_bottomSpace = 80;

  //Para que solo se pueda introducir texto plano
  config.forcePasteAsPlainText = true;

  config.format_tags = 'p;h1;h2;h3;h4;h5;h6;pre;address';

  //Para que no se conviertan los caracteres especiales en entidades HTML
  config.entities_greek = false;
  config.entities_latin = false;
  config.entities_processNumerical = false;

  //config.filebrowserBrowseUrl = '../../app/filemanager/index.html'; // ESTO SÓLO SE PUEDE HABILITAR PARA LOS DP CON SERVIDOR PROPIO

  config.extraAllowedContent = 'script[src];'+ //Para permitir etiquetas <script> (necesario para subir animaciones html en nanomyp)
    ' a(*)[*];'+ //Para embeber widgets de twitter
    ' pre(*)'; //Para incluir código

  //config.protectedSource.push(/<pre>[\s\S]*?<\/pre>/gi); //Esto oculta este código, y no lo muestra en el editor

  /*config.htmlEncodeOutput = true;
  config.entities = false;*/
  
};
