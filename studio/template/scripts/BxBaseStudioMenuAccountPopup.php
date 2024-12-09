<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    UnaView UNA Studio Representation classes
 * @ingroup     UnaStudio
 * @{
 */

class BxBaseStudioMenuAccountPopup extends BxDolStudioMenuAccountPopup
{
    public function __construct ($aObject, $oTemplate)
    {
        parent::__construct ($aObject, $oTemplate);

        $this->addMarkers(array(
            'js_object' => BxTemplStudioMenuTop::getInstance()->getJsObject(),
            'url_root' => BX_DOL_URL_ROOT,
            'url_studio' => BX_DOL_URL_STUDIO
        ));
    }
    
    protected function _getMenuItem ($aItem)
    {
        $aItem = parent::_getMenuItem($aItem);
        if($aItem === false)
            return $aItem;
        
        if(!isset($aItem['class_add']))
            $aItem['class_add'] = '';

        $aItem['class_add'] .= str_replace('_', ' ', $aItem['name']);

        return $aItem;
    }
}

/** @} */
