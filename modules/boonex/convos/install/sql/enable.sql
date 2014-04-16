
-- SETTINGS

SET @iTypeOrder = (SELECT MAX(`order`) FROM `sys_options_types` WHERE `group` = 'modules');
INSERT INTO `sys_options_types`(`group`, `name`, `caption`, `icon`, `order`) VALUES 
('modules', 'bx_convos', '_bx_cnv', 'bx_convos@modules/boonex/convos/|std-mi.png', IF(ISNULL(@iTypeOrder), 1, @iTypeOrder + 1));
SET @iTypeId = LAST_INSERT_ID();

INSERT INTO `sys_options_categories` (`type_id`, `name`, `caption`, `order`)
VALUES (@iTypeId, 'bx_convos', '_bx_cnv', 1);
SET @iCategId = LAST_INSERT_ID();

INSERT INTO `sys_options` (`name`, `value`, `category_id`, `caption`, `type`, `check`, `check_error`, `extra`, `order`) VALUES
('bx_convos_per_page_browse', '12', @iCategId, '_bx_cnv_option_per_page_browse', 'digit', '', '', '', 1);

-- STORAGES & TRANSCODERS

SET @iTotalFilesSize = (SELECT SUM(`size`) FROM `bx_convos_files`);
SET @iTotalFilesNum = (SELECT COUNT(*) FROM `bx_convos_files`);
SET @iTotalResizedSize = (SELECT SUM(`size`) FROM `bx_convos_photos_resized`);
SET @iTotalResizedNum = (SELECT COUNT(*) FROM `bx_convos_photos_resized`);

INSERT INTO `sys_objects_storage` (`object`, `engine`, `params`, `token_life`, `cache_control`, `levels`, `table_files`, `ext_mode`, `ext_allow`, `ext_deny`, `quota_size`, `current_size`, `quota_number`, `current_number`, `max_file_size`, `ts`) VALUES
('bx_convos_files', 'Local', '', 360, 2592000, 3, 'bx_convos_files', 'deny-allow', '', 'action,apk,app,bat,bin,cmd,com,command,cpl,csh,exe,gadget,inf,ins,inx,ipa,isu,job,jse,ksh,lnk,msc,msi,msp,mst,osx,out,paf,pif,prg,ps1,reg,rgs,run,sct,shb,shs,u3p,vb,vbe,vbs,vbscript,workflow,ws,wsf', 0, @iTotalFilesSize, 0, @iTotalFilesNum, 0, 0),
('bx_convos_photos_resized', 'Local', '', 360, 2592000, 3, 'bx_convos_photos_resized', 'allow-deny', 'jpg,jpeg,jpe,gif,png', '', 0, @iTotalResizedSize, 0, @iTotalResizedNum, 0, 0);

INSERT INTO `sys_objects_transcoder_images` (`object`, `storage_object`, `source_type`, `source_params`, `private`, `atime_tracking`, `atime_pruning`, `ts`) VALUES 
('bx_convos_preview', 'bx_convos_photos_resized', 'Storage', 'a:1:{s:6:"object";s:15:"bx_convos_files";}', 'no', '1', '2592000', '0');

INSERT INTO `sys_transcoder_images_filters` (`transcoder_object`, `filter`, `filter_params`, `order`) VALUES 
('bx_convos_preview', 'Resize', 'a:4:{s:1:"w";s:3:"300";s:1:"h";s:3:"200";s:11:"crop_resize";s:1:"1";s:10:"force_type";s:3:"jpg";}', '0');

-- PAGE: dash

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `active`, `order`) VALUES 
('sys_dashboard', 3, 'bx_convos', '_bx_cnv_page_block_title_convos', 11, 2147483646, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:17:\"messages_previews\";}', 0, 1, 1, 0);


-- PAGE: create entry

INSERT INTO `sys_objects_page`(`object`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `uri`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_create_entry', '_bx_cnv_page_title_sys_create_entry', '_bx_cnv_page_title_create_entry', 'bx_convos', 5, 2147483647, 1, 'start-convo', 'page.php?i=start-convo', '', '', '', 0, 1, 0, 'BxCnvPageBrowse', 'modules/boonex/convos/classes/BxCnvPageBrowse.php');

INSERT INTO `sys_pages_blocks` (`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES
('bx_convos_create_entry', 1, 'bx_convos', '_bx_cnv_page_block_title_create_entry', 11, 2147483647, 'service', 'a:2:{s:6:"module";s:9:"bx_convos";s:6:"method";s:13:"entity_create";}', 0, 1, 1);


-- PAGE: view entry

INSERT INTO `sys_objects_page`(`object`, `uri`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_view_entry', 'view-convo', '_bx_cnv_page_title_sys_view_entry', '_bx_cnv_page_title_view_entry', 'bx_convos', 10, 2147483647, 1, '', '', '', '', 0, 1, 0, 'BxCnvPageEntry', 'modules/boonex/convos/classes/BxCnvPageEntry.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `active`, `order`) VALUES 
('bx_convos_view_entry', 4, 'bx_convos', '_bx_cnv_page_block_title_entry_text', 13, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:17:\"entity_text_block\";}', 0, 0, 1, 0),
('bx_convos_view_entry', 3, 'bx_convos', '_bx_cnv_page_block_title_entry_collaborators', 0, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:20:\"entity_collaborators\";}', 0, 0, 1, 0),
('bx_convos_view_entry', 1, 'bx_convos', '_bx_cnv_page_block_title_entry_actions', 0, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:14:\"entity_actions\";}', 0, 0, 1, 0),
('bx_convos_view_entry', 2, 'bx_convos', '_bx_cnv_page_block_title_entry_author', 0, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:13:\"entity_author\";}', 0, 0, 1, 0),
('bx_convos_view_entry', 4, 'bx_convos', '_bx_cnv_page_block_title_entry_attachments', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:18:\"entity_attachments\";}', 0, 0, 1, 1),
('bx_convos_view_entry', 4, 'bx_convos', '_bx_cnv_page_block_title_entry_comments', 11, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:15:\"entity_comments\";}', 0, 0, 1, 2);


-- PAGE: module home

INSERT INTO `sys_objects_page`(`object`, `title_system`, `title`, `module`, `layout_id`, `visible_for_levels`, `visible_for_levels_editable`, `uri`, `url`, `meta_description`, `meta_keywords`, `meta_robots`, `cache_lifetime`, `cache_editable`, `deletable`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_home', '_bx_cnv_page_title_sys_folder', '_bx_cnv_page_title_folder', 'bx_convos', 5, 2147483647, 1, 'convos-folder', 'modules/?r=convos/folder/1', '', '', '', 0, 1, 0, 'BxCnvPageBrowse', 'modules/boonex/convos/classes/BxCnvPageBrowse.php');

INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `order`) VALUES 
('bx_convos_home', 1, 'bx_convos', '_bx_cnv_page_block_title_folder', 0, 2147483647, 'service', 'a:2:{s:6:\"module\";s:9:\"bx_convos\";s:6:\"method\";s:4:\"home\";}', 0, 1, 0);


-- MENU: actions menu for view entry 

INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_view', '_bx_cnv_menu_title_view_entry', 'bx_convos_view', 'bx_convos', 9, 0, 1, 'BxCnvMenuView', 'modules/boonex/convos/classes/BxCnvMenuView.php');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_convos_view', 'bx_convos', '_bx_cnv_menu_set_title_view_entry', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_convos_view', 'bx_convos', 'delete-convo', '_bx_cnv_menu_item_title_system_delete_entry', '_bx_cnv_menu_item_title_delete_entry', 'javascript:void(0);', 'bx_cnv_delete(this, \'{content_id}\')', '', 'remove', '', 0, 1, 0, 1),
('bx_convos_view', 'bx_convos', 'mark-unread-convo', '_bx_cnv_menu_item_title_system_mark_unread_entry', '_bx_cnv_menu_item_title_mark_unread_entry', 'javascript:void(0);', 'bx_cnv_mark_unread(this, \'{content_id}\')', '', 'check', '', 0, 1, 0, 2);


-- MENU: module sub-menu

INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_submenu', '_bx_cnv_menu_title_submenu', 'bx_convos_submenu', 'bx_convos', 8, 0, 1, '', '');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_convos_submenu', 'bx_convos', '_bx_cnv_menu_set_title_submenu', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_convos_submenu', 'bx_convos', 'convos-folder-inbox', '_bx_cnv_menu_item_title_system_folder_inbox', '_bx_cnv_menu_item_title_folder_inbox', 'modules/?r=convos/folder/1', '', '', '', '', 2147483647, 1, 1, 1),
('bx_convos_submenu', 'bx_convos', 'convos-folder-more', '_bx_cnv_menu_item_title_system_folder_more', '_bx_cnv_menu_item_title_folder_more', 'javascript:void(0);', 'bx_menu_popup(''bx_convos_menu_folders_more'', this);', '', '', '', 2147483647, 1, 1, 2);


-- MENU: more folders

INSERT INTO `sys_objects_menu`(`object`, `title`, `set_name`, `module`, `template_id`, `deletable`, `active`, `override_class_name`, `override_class_file`) VALUES 
('bx_convos_menu_folders_more', '_bx_cnv_menu_title_folders_more', 'bx_convos_menu_folders_more', 'bx_convos', 4, 0, 1, '', '');

INSERT INTO `sys_menu_sets`(`set_name`, `module`, `title`, `deletable`) VALUES 
('bx_convos_menu_folders_more', 'bx_convos', '_bx_cnv_menu_set_title_folders_more', 0);

INSERT INTO `sys_menu_items`(`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES 
('bx_convos_menu_folders_more', 'bx_convos', 'convos-drafts', '_bx_cnv_menu_item_title_system_folder_drafts', '_bx_cnv_menu_item_title_folder_drafts', 'modules/?r=convos/folder/2', '', '', '', '', 2147483647, 1, 1, 1),
('bx_convos_menu_folders_more', 'bx_convos', 'convos-spam', '_bx_cnv_menu_item_title_system_folder_spam', '_bx_cnv_menu_item_title_folder_spam', 'modules/?r=convos/folder/3', '', '', '', '', 2147483647, 1, 1, 2),
('bx_convos_menu_folders_more', 'bx_convos', 'convos-trash', '_bx_cnv_menu_item_title_system_folder_trash', '_bx_cnv_menu_item_title_folder_trash', 'modules/?r=convos/folder/4', '', '', '', '', 2147483647, 1, 1, 3);


-- MENU: notifications

INSERT INTO `sys_menu_items` (`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `addon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES
('sys_account_notifications', 'bx_convos', 'notifications-convos', '_bx_cnv_menu_item_title_system_convos', '_bx_cnv_menu_item_title_convos', 'modules/?r=convos/folder/1', '', '', 'envelope col-red1', 'a:2:{s:6:"module";s:9:"bx_convos";s:6:"method";s:23:"get_unread_messages_num";}', '', 2147483646, 1, 0, 2);


-- MENU: profile stats

INSERT INTO `sys_menu_items` (`set_name`, `module`, `name`, `title_system`, `title`, `link`, `onclick`, `target`, `icon`, `addon`, `submenu_object`, `visible_for_levels`, `active`, `copyable`, `order`) VALUES
('sys_profile_stats', 'bx_convos', 'profile-stats-unread-messages', '_bx_cnv_menu_item_title_system_unread_messages', '_bx_cnv_menu_item_title_unread_messages', 'modules/?r=convos/folder/1', '', '', 'envelope col-red1', 'a:2:{s:6:"module";s:9:"bx_convos";s:6:"method";s:23:"get_unread_messages_num";}', '', 2147483646, 1, 0, 2);


-- GRID

INSERT INTO `sys_objects_grid` (`object`, `source_type`, `source`, `table`, `field_id`, `field_order`, `paginate_url`, `paginate_per_page`, `paginate_simple`, `paginate_get_start`, `paginate_get_per_page`, `filter_fields`, `filter_mode`, `sorting_fields`, `visible_for_levels`, `override_class_name`, `override_class_file`) VALUES
('bx_convos', 'Sql', 'SELECT `c`.`id`, `c`.`author`, `c`.`text`, `c`.`added`, `c`.`comments`, `f`.`read_comments`, `last_reply_timestamp`, `last_reply_profile_id` FROM `bx_convos_conversations` AS `c` INNER JOIN `bx_convos_conv2folder` AS `f` ON (`c`.`id` = `f`.`conv_id` AND `f`.`folder_id` = {folder_id} AND `f`.`collaborator` = {profile_id})', 'bx_convos_conversations', 'id', 'last_reply_timestamp', '', 10, NULL, 'start', '', 'text', 'auto', 'comments,last_reply_timestamp', 2147483646, 'BxCnvGrid', 'modules/boonex/convos/classes/BxCnvGrid.php');

INSERT INTO `sys_grid_fields` (`object`, `name`, `title`, `width`, `params`, `order`) VALUES
('bx_convos', 'checkbox', '_sys_select', '2%', '', 1),
('bx_convos', 'collaborators', '_bx_cnv_field_collaborators', '25%', '', 2),
('bx_convos', 'preview', '_bx_cnv_field_preview', '48%', '', 3),
('bx_convos', 'comments', '_bx_cnv_field_comments', '12%', '', 4),
('bx_convos', 'last_reply_timestamp', '_bx_cnv_field_updated', '13%', '', 5);

INSERT INTO `sys_grid_actions` (`object`, `type`, `name`, `title`, `icon`, `confirm`, `order`) VALUES
('bx_convos', 'bulk', 'delete', '_bx_cnv_grid_action_delete', '', 1, 1),
('bx_convos', 'independent', 'add', '_bx_cnv_grid_action_compose', '', 0, 1);


-- ACL

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_convos', 'create entry', NULL, '_bx_cnv_acl_action_create_entry', '', 1, 1);
SET @iIdActionEntryCreate = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_convos', 'delete entry', NULL, '_bx_cnv_acl_action_delete_entry', '', 1, 1);
SET @iIdActionEntryDelete = LAST_INSERT_ID();

INSERT INTO `sys_acl_actions` (`Module`, `Name`, `AdditionalParamName`, `Title`, `Desc`, `Countable`, `DisabledForLevels`) VALUES
('bx_convos', 'view entry', NULL, '_bx_cnv_acl_action_view_entry', '', 1, 1);
SET @iIdActionEntryView = LAST_INSERT_ID();


SET @iUnauthenticated = 1;
SET @iStandard = 2;
SET @iUnconfirmed = 3;
SET @iPending = 4;
SET @iSuspended = 5;
SET @iModerator = 6;
SET @iAdministrator = 7;
SET @iPremium = 8;

INSERT INTO `sys_acl_matrix` (`IDLevel`, `IDAction`) VALUES

-- entry create
(@iStandard, @iIdActionEntryCreate),
(@iModerator, @iIdActionEntryCreate),
(@iAdministrator, @iIdActionEntryCreate),
(@iPremium, @iIdActionEntryCreate),

-- entry delete
(@iStandard, @iIdActionEntryDelete),
(@iModerator, @iIdActionEntryDelete),
(@iAdministrator, @iIdActionEntryDelete),
(@iPremium, @iIdActionEntryDelete),

-- entry view
(@iUnauthenticated, @iIdActionEntryView),
(@iStandard, @iIdActionEntryView),
(@iUnconfirmed, @iIdActionEntryView),
(@iPending, @iIdActionEntryView),
(@iModerator, @iIdActionEntryView),
(@iAdministrator, @iIdActionEntryView),
(@iPremium, @iIdActionEntryView);


-- COMMENTS
INSERT INTO `sys_objects_cmts` (`Name`, `Table`, `CharsPostMin`, `CharsPostMax`, `CharsDisplayMax`, `Nl2br`, `PerView`, `PerViewReplies`, `BrowseType`, `IsBrowseSwitch`, `PostFormPosition`, `NumberOfLevels`, `IsDisplaySwitch`, `IsRatable`, `ViewingThreshold`, `IsOn`, `RootStylePrefix`, `BaseUrl`, `ObjectVote`, `TriggerTable`, `TriggerFieldId`, `TriggerFieldTitle`, `TriggerFieldComments`, `ClassName`, `ClassFile`) VALUES
('bx_convos', 'bx_convos_cmts', 1, 5000, 1000, 1, 5, 3, 'tail', 1, 'bottom', 1, 1, 0, -3, 1, 'cmt', 'page/view-convo&id={object_id}', '', 'bx_convos_conversations', 'id', '', 'comments', 'BxCnvCmts', 'modules/boonex/convos/classes/BxCnvCmts.php');

-- VIEWS
INSERT INTO `sys_objects_view` (`name`, `table_track`, `period`, `is_on`, `trigger_table`, `trigger_field_id`, `trigger_field_count`, `class_name`, `class_file`) VALUES 
('bx_convos', 'bx_convos_views_track', '86400', '1', 'bx_convos_conversations', 'id', 'views', '', '');

-- ALERTS

INSERT INTO `sys_alerts_handlers` (`name`, `class`, `file`, `eval`) VALUES 
('bx_convos', 'BxCnvAlertsResponse', 'modules/boonex/convos/classes/BxCnvAlertsResponse.php', '');
SET @iHandler := LAST_INSERT_ID();

INSERT INTO `sys_alerts` (`unit`, `action`, `handler_id`) VALUES
('bx_convos', 'commentPost', @iHandler),
('bx_convos', 'commentRemoved', @iHandler);

