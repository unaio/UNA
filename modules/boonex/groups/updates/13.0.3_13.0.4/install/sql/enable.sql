-- MENUS
UPDATE `sys_menu_items` SET `active`='0' WHERE `set_name`='bx_groups_menu_manage_tools' AND `name`='delete-with-content';


-- GRIDS
UPDATE `sys_grid_actions` SET `active`='0' WHERE `object`='bx_groups_administration' AND `type`='bulk' AND `name`='delete_with_content';

UPDATE `sys_grid_actions` SET `active`='0' WHERE `object`='bx_groups_common' AND `type`='bulk' AND `name`='delete_with_content';
