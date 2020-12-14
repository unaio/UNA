<?php defined('BX_DOL') or die('hack attempt');
/**
 * Copyright (c) UNA, Inc - https://una.io
 * MIT License - https://opensource.org/licenses/MIT
 *
 * @defgroup    UnaView UNA Studio Representation classes
 * @ingroup     UnaStudio
 * @{
 */

define('BX_DOL_STUDIO_LAUNCHER_JS_CLASS', 'BxDolStudioLauncher');
define('BX_DOL_STUDIO_LAUNCHER_JS_OBJECT', 'oBxDolStudioLauncher');

class BxBaseStudioLauncher extends BxDolStudioLauncher
{
    protected $_sTourTheme = 'default';

    public function __construct()
    {
        parent::__construct();

        $this->sPageUrl = BX_DOL_URL_STUDIO . 'launcher.php';
    }

    public function getPageCss()
    {
        $aCss = array(
            'launcher.css',
            BX_DIRECTORY_PATH_PLUGINS_PUBLIC . 'flag-icon-css/css/|flag-icon.min.css',
            BX_DIRECTORY_PATH_PLUGINS_PUBLIC . 'shepherd/css/|shepherd-theme-' . $this->_sTourTheme . '.css',
        );
        foreach($this->aIncludes as $sName => $oInclude)
            $aCss = array_merge($aCss, $oInclude->getCss());

        return array_merge(parent::getPageCss(), $aCss);
    }

    public function getPageJs()
    {
        $aJs = array(
            'jquery-ui/jquery.ui.core.min.js',
            'jquery-ui/jquery.ui.widget.min.js',
            'jquery-ui/jquery.ui.mouse.min.js',
            'jquery-ui/jquery.ui.sortable.min.js',
            'jquery.ui.touch-punch.min.js',
            'jquery.easing.js',
            'jquery.cookie.min.js',
            'launcher.js',
            'shepherd/js/tether.min.js',
            'shepherd/js/shepherd.min.js',
        );
        foreach($this->aIncludes as $sName => $oInclude)
            $aJs = array_merge($aJs, $oInclude->getJs());

        return $aJs;
    }

    public function getPageJsClass()
    {
        return BX_DOL_STUDIO_LAUNCHER_JS_CLASS;
    }

    public function getPageJsObject()
    {
        return BX_DOL_STUDIO_LAUNCHER_JS_OBJECT;
    }

    public function getPageJsCode($aOptions = array(), $bWrap = true)
    {
        return parent::getPageJsCode(array_merge($aOptions, array(
            'sActionUrl' => $this->sPageUrl
        )), $bWrap);
    }

    public function getPageCode($sPage = '', $bWrap = true)
    {
        $sResult = parent::getPageCode($sPage, $bWrap);
        if($sResult === false)
            return false;

        $oTemplate = BxDolStudioTemplate::getInstance();

        $sIncludes = '';
        foreach($this->aIncludes as $sName => $oInclude)
            $sIncludes .= $oInclude->getJsCode();

        $sResult = $oTemplate->parseHtmlByName('launcher.html', array(
            'js_object' => $this->getPageJsObject(),
            'js_code' => $this->getPageJsCode(),
            'includes' => $sIncludes,
            'items' => $sResult,
        ));

        if (getParam('site_tour_studio') == 'on')
            $sResult .= $oTemplate->parseHtmlByName('launcher_tour.html', array('tour_theme' => $this->_sTourTheme));

        $oTemplate->addInjection('injection_body_style', 'text', ' bx-std-page-launcher');
        return $sResult;
    }

    public function getPopupBrowser()
    {
        $iAccountId = getLoggedId();

        $oUtils = BxDolStudioRolesUtils::getInstance();
        $oTemplate = BxDolStudioTemplate::getInstance();

        $aTypes = parent::getPageTypes();
        
        $sSelected = reset($aTypes)['Value'];
        $aMarkers = array();

        $aMenuItems = array();
        $aTmplVarsTypes = array();
        foreach($aTypes as $sType => $aType) {
            if(!$oUtils->isActionAllowed('use ' . $sType, $iAccountId))
                continue;

            $aTypeData = unserialize($aType['Data']);

            //--- Menu
            $aMenuItems[] = array(
                'name' => $sType,
                'title' => _t($aType['LKey']),
                'link' => 'javascript:void(0)',
                'onclick' => $this->getPageJsObject() . '.browserChangeType(this, \'' . $sType . '\')',
                'icon' => !empty($aTypeData['icon']) ? $aTypeData['icon'] : '',
                'selected' => $sType == $sSelected
            );

            //--- Conetent
            $aTmplVarsTypes[] = array(
                'type' => $sType, 
                'class' => $sType == $sSelected ? 'bx-std-lbw-active' : '',
                'widgets' => $this->getWidgets($this->aPage['name'], $this->oDb->getWidgets(array(
                    'type' => 'by_page_id', 
                    'value' => $this->aPage['id'], 
                    'wtype' => $sType != BX_DOL_STUDIO_WTYPE_DEFAULT ? $sType : ''
                )))
            );
        }

        $oMenu = new BxTemplStudioMenu(array('template' => 'menu_launcher_browser.html', 'menu_items' => $aMenuItems));
        if(!empty($aMarkers))
            $oMenu->addMarkers($aMarkers);

        $sName = 'bx-std-launcher-browser';
        $sContent = $oTemplate->parseHtmlByName('launcher_browser.html', array(
            'logo' => BxTemplStudioFunctions::getInstance()->getLogo(),
            'logo_url' => $this->sPageUrl,
            'menu' => $oMenu->getCode(),
            'bx_repeat:types' => $aTmplVarsTypes
        ));

        return array(
            'html' => BxTemplStudioFunctions::getInstance()->transBox($sName, $sContent),
            'options' => array(
                'closeOnOuterClick' => true,
                'pointer' => array(
                    'el' => '.bx-menu-breadcrumb .bx-menu-bc-home',
                )
            )
        );
    }

    public function serviceGetCacheUpdater()
    {
        check_logged();
        if(!isAdmin())
            return '';

        $oTemplate = BxDolStudioTemplate::getInstance();
        $sContent = $oTemplate->addJs('launcher.js', true);
        $sContent .= $oTemplate->parseHtmlByName('launcher_cache_updater.html', array(
            'js_object' => $this->getPageJsObject()
        ));

        return $sContent;
    }
}

/** @} */
