<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) BoonEx Pty Limited - http://www.boonex.com/
 * CC-BY License - http://creativecommons.org/licenses/by/3.0/
 *
 * @defgroup    FacebookConnect Facebook Connect
 * @ingroup     TridentModules
 *
 * @{
 */

class BxFaceBookConnectAlerts extends BxBaseModConnectAlerts
{
    function __construct()
    {
        parent::__construct();
        $this->oModule = BxDolModule::getInstance('bx_facebook');
    }
}

/** @} */
