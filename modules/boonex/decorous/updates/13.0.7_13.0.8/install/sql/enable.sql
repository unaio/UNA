SET @sName = 'bx_decorous';


-- INJECTIONS
UPDATE `sys_injections` SET `data`='a:3:{s:6:"module";s:11:"bx_decorous";s:6:"method";s:14:"include_css_js";s:6:"params";a:1:{i:0;s:4:"head";}}' WHERE `name`=@sName;

DELETE FROM `sys_injections` WHERE `name`='bx_decorous_footer';
INSERT INTO `sys_injections` (`name`, `page_index`, `key`, `type`, `data`, `replace`, `active`) VALUES
('bx_decorous_footer', 0, 'injection_footer', 'service', 'a:3:{s:6:"module";s:11:"bx_decorous";s:6:"method";s:14:"include_css_js";s:6:"params";a:1:{i:0;s:6:"footer";}}', 0, 1);
