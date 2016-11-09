
-- This script is required for the module to convert files with OpenOffice/LibreOffice

CREATE TABLE `doplanning_app`.`app_file_types` (
  `file_type` varchar(10) NOT NULL,
  `name_es` varchar(100) NOT NULL,
  `name_en` varchar(100) NOT NULL,
  PRIMARY KEY  USING BTREE (`file_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `doplanning_app`.`app_file_types` VALUES ('.doc','Word','Word'),('.html','HTML','HTML'),('.odt','OpenDocument','OpenDocument'),('.pdf','PDF','PDF'),('.ppt','PowerPoint','PowerPoint'),('.rtf','Rich Text Format','Rich Text Format'),('.swf','Flash (SWF)','Flash (SWF)'),('.xls','Excel','Excel');

CREATE TABLE `doplanning_app`.`app_file_types_conversion` (
  `file_type_from` varchar(10) NOT NULL,
  `file_type_to` varchar(10) NOT NULL,
  `order` int(10) unsigned NOT NULL,
  `enabled` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  USING BTREE (`file_type_from`,`file_type_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `app_file_types_conversion` VALUES ('.csv','.html',1,1),('.csv','.pdf',2,1),('.doc','.html',4,1),('.doc','.odt',3,0),('.doc','.pdf',1,1),('.doc','.rtf',2,0),('.docx','.pdf',1,1),('.odp','.html',2,1),('.odp','.pdf',1,1),('.ods','.html',1,1),('.ods','.pdf',2,1),('.odt','.doc',1,1),('.odt','.html',4,1),('.odt','.pdf',2,1),('.odt','.rtf',3,1),('.ppt','.html',3,1),('.ppt','.pdf',1,1),('.ppt','.swf',2,0),('.pptx','.html',2,1),('.pptx','.pdf',1,1),('.xls','.html',1,1),('.xls','.pdf',2,1),('.xlsx','.html',1,1),('.xlsx','.pdf',2,1);
