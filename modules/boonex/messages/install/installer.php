<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) BoonEx Pty Limited - http://www.boonex.com/
 * CC-BY License - http://creativecommons.org/licenses/by/3.0/
 * 
 * @defgroup    Messages Messages
 * @ingroup     DolphinModules
 *
 * @{
 */

bx_import('BxBaseModTextInstaller');

class BxMsgInstaller extends BxBaseModTextInstaller 
{
    function __construct($aConfig) 
    {
        parent::__construct($aConfig);
    }

    function uninstall($aParams, $bDisable = false) 
    {
        // TODO: delete photo files before deleting files tables
        return parent::uninstall($aParams, $bDisable);
    }
}

/** @} */ 
