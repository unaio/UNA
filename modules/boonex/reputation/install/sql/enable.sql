SET @sName = 'bx_reputation';


-- SETTINGS
-- SET @iTypeOrder = (SELECT MAX(`order`) FROM `sys_options_types` WHERE `group` = 'modules');
-- INSERT INTO `sys_options_types`(`group`, `name`, `caption`, `icon`, `order`) VALUES 
-- ('modules', @sName, '_bx_reputation', 'bx_reputation@modules/boonex/ewts/|std-icon.svg', IF(ISNULL(@iTypeOrder), 1, @iTypeOrder + 1));
-- SET @iTypeId = LAST_INSERT_ID();

-- INSERT INTO `sys_options_categories` (`type_id`, `name`, `caption`, `order`)
-- VALUES (@iTypeId, @sName, '_bx_reputation', 10);
-- SET @iCategId = LAST_INSERT_ID();

-- INSERT INTO `sys_options` (`name`, `value`, `category_id`, `caption`, `type`, `extra`, `check`, `check_error`, `order`) VALUES
-- ('bx_reputation_badge_persons', '', @iCategId, '_bx_reputation_option_badge_persons', 'select', 'a:3:{s:6:"module";s:13:"bx_reputation";s:6:"method";s:17:"get_options_badge";s:6:"params";a:1:{i:0;s:13:"bx_reputation";}}', '', '', 10);


-- PAGES: add page block on home
SET @iPBCellHome = 2;
SET @iPBOrderHome = (SELECT IFNULL(MAX(`order`), 0) FROM `sys_pages_blocks` WHERE `object` = 'sys_home' AND `cell_id` = @iPBCellHome ORDER BY `order` DESC LIMIT 1);
INSERT INTO `sys_pages_blocks`(`object`, `cell_id`, `module`, `title_system`, `title`, `designbox_id`, `tabs`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `active`, `order`) VALUES 
('sys_home', @iPBCellHome, @sName, '_bx_reputation_page_block_title_system_summary', '_bx_reputation_page_block_title_summary', 13, 0, 2147483644, 'service', 'a:2:{s:6:"module";s:13:"bx_reputation";s:6:"method";s:17:"get_block_summary";}', 0, 1, 1, @iPBOrderHome + 1);

-- PAGES: add page block to profiles modules (trigger* page objects are processed separately upon modules enable/disable)
SET @iPBCellProfile = 3;
INSERT INTO `sys_pages_blocks` (`object`, `cell_id`, `module`, `title_system`, `title`, `designbox_id`, `visible_for_levels`, `type`, `content`, `deletable`, `copyable`, `active`, `order`) VALUES
('trigger_page_profile_view_entry', @iPBCellProfile, @sName, '_bx_reputation_page_block_title_system_summary', '_bx_reputation_page_block_title_summary', 13, 2147483647, 'service', 'a:3:{s:6:"module";s:13:"bx_reputation";s:6:"method";s:17:"get_block_summary";s:6:"params";a:1:{i:0;s:12:"{profile_id}";}}', 0, 0, 1, 0);


-- GRIDS: administration tools
INSERT INTO `sys_objects_grid` (`object`, `source_type`, `source`, `table`, `field_id`, `field_order`, `field_active`, `paginate_url`, `paginate_per_page`, `paginate_simple`, `paginate_get_start`, `paginate_get_per_page`, `filter_fields`, `filter_fields_translatable`, `filter_mode`, `sorting_fields`, `sorting_fields_translatable`, `visible_for_levels`, `override_class_name`, `override_class_file`) VALUES
('bx_reputation_manage', 'Sql', 'SELECT * FROM `bx_reputation_handlers` WHERE 1 ', 'bx_reputation_handlers', 'id', '', 'active', '', 20, NULL, 'start', '', 'type,alert_unit,alert_action', '', 'like', 'reports', '', 192, 'BxReputationGridManage', 'modules/boonex/reputation/classes/BxReputationGridManage.php');

INSERT INTO `sys_grid_fields` (`object`, `name`, `title`, `width`, `translatable`, `chars_limit`, `params`, `order`) VALUES
('bx_reputation_manage', 'checkbox', '_sys_select', '2%', 0, '', '', 1),
('bx_reputation_manage', 'switcher', '_bx_reputation_grid_column_title_active', '8%', 0, 0, '', 2),
('bx_reputation_manage', 'alert_unit', '_bx_reputation_grid_column_title_alert_unit', '25%', 0, 0, '', 3),
('bx_reputation_manage', 'alert_action', '_bx_reputation_grid_column_title_alert_action', '21%', 0, 0, '', 4),
('bx_reputation_manage', 'points_active', '_bx_reputation_grid_column_title_points_active', '12%', 0, 0, '', 5),
('bx_reputation_manage', 'points_passive', '_bx_reputation_grid_column_title_points_passive', '12%', 0, 0, '', 6),
('bx_reputation_manage', 'actions', '', '20%', 0, 0, '', 7);

INSERT INTO `sys_grid_actions` (`object`, `type`, `name`, `title`, `icon`, `icon_only`, `confirm`, `order`) VALUES
('bx_reputation_manage', 'bulk', 'activate', '_bx_reputation_grid_action_title_activate', '', 0, 0, 1),
('bx_reputation_manage', 'bulk', 'deactivate', '_bx_reputation_grid_action_title_deactivate', '', 0, 0, 2),
('bx_reputation_manage', 'single', 'edit', '_bx_reputation_grid_action_title_edit', 'pencil-alt', 1, 0, 1);


-- ALERTS
INSERT INTO `sys_alerts_handlers` (`name`, `class`, `file`, `service_call`) VALUES 
(@sName, 'BxReputationAlertsResponse', 'modules/boonex/reputation/classes/BxReputationAlertsResponse.php', '');
SET @iHandler := LAST_INSERT_ID();

INSERT INTO `sys_alerts` (`unit`, `action`, `handler_id`) VALUES
('profile', 'delete', @iHandler);
