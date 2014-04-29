/**
 * @package     Dolphin Core
 * @copyright   Copyright (c) BoonEx Pty Limited - http://www.boonex.com/
 * @license     CC-BY - http://creativecommons.org/licenses/by/3.0/
 */



function getHtmlData( elem, url, callback, method , confirmation)
{
    if ('undefined' != typeof(confirmation) && confirmation && !confirm(_t('_are you sure?'))) 
        return false;

    // in most cases it is element ID, in other cases - object of jQuery
    if (typeof elem == 'string')
        elem = '#' + elem; // create selector from ID

    var $block = $(elem);

    var blockPos = $block.css('position');

    $block.css('position', 'relative'); // set temporarily for displaying "loading icon"

    bx_loading_content($block, true);
    var $loadingDiv = $block.find('.bx-loading-ajax');

    var iLeftOff = parseInt(($block.innerWidth() / 2.0) - ($loadingDiv.outerWidth()  / 2.0));
    var iTopOff  = parseInt(($block.innerHeight() / 2.0) - ($loadingDiv.outerHeight()));
    if (iTopOff<0) iTopOff = 0;

    $loadingDiv.css({
        position: 'absolute',
        left: iLeftOff,
        top:  iTopOff,
        zIndex:100
    });

    if (undefined != method && (method == 'post' || method == 'POST')) {

        $.post(url, function(data) {

            $block.html(data);
	        $block.css('position', blockPos).bxTime();
            if ($.isFunction($.fn.addWebForms))
                $block.addWebForms();

            if (typeof callback == 'function')
                callback.apply($block);
        });

    } else {

        $block.load(url + '&_r=' + Math.random(), function() {

	        $(this).css('position', blockPos).bxTime();
            if ($.isFunction($.fn.addWebForms))
                $(this).addWebForms();

            if (typeof callback == 'function')
                callback.apply(this);
        });

    }
}

/**
 * This function reloads page block automatically, 
 * just provide any element inside the block and this function will reload the block.
 * @param e - element inside the block
 * @return true on success, or false on error - particularly, if block isn't found
 */
function loadDynamicBlockAuto(e) {
    var sUrl = location.href;
    var sId = $(e).parents('.bx-page-block-container:first').attr('id');
    
    if (!sId || !sId.length)
        return false;

    var aMatches = sId.match(/\-(\d+)$/);
    if (!aMatches || !aMatches[1])
        return false;
        
    loadDynamicBlock(parseInt(aMatches[1]), sUrl);
    return true;
}

function loadDynamicBlock(iBlockID, sUrl) {
    getHtmlData($('#bx-page-block-' + iBlockID), bx_append_url_params(sUrl, 'dynamic=tab&pageBlock=' + iBlockID));
    return true;
}

function loadDynamicPopupBlock(iBlockID, sUrl) {
    if (!$('#dynamicPopup').length) {
        $('<div id="dynamicPopup" style="display:none;"></div>').prependTo('body');
    }

    $('#dynamicPopup').load(
        (sUrl + '&dynamic=popup&pageBlock=' + iBlockID),
        function() {
            $(this).dolPopup({
                left: 0,
                top: 0
            });
        }
    );
}

function closeDynamicPopupBlock() {
    $('#dynamicPopup').dolPopupHide();
}


/**
 * Translate string
 */
function _t(s, arg0, arg1, arg2) {
    if (!window.aDolLang || !aDolLang[s])
        return s;

    cs = aDolLang[s];
    cs = cs.replace(/\{0\}/g, arg0);
    cs = cs.replace(/\{1\}/g, arg1);
    cs = cs.replace(/\{2\}/g, arg2);
    return cs;
}


function showPopupLoginForm() {
    var oPopupOptions = {};

    if ($('#login_div').length)
        $('#login_div').dolPopup(oPopupOptions);
    else {
        $('<div id="login_div" style="visibility: none;"></div>').prependTo('body').load(
            sUrlRoot + 'member.php',
            {
                action: 'show_login_form',
                relocate: String(window.location)
            },
            function() {
                $(this).dolPopup(oPopupOptions);
            }
        );
    }
}

function showPopupAnyHtml(sUrl, sId) {

    var oPopupOptions = {};

    if (!sId || !sId.length)
        sId = 'login_div';

    $('#' + sId).remove();
    $('<div id="' + sId + '" style="display: none;"></div>').prependTo('body').load(
        sUrl.match('^http[s]{0,1}:\/\/') ? sUrl : sUrlRoot + sUrl,
        function() {
            $(this).dolPopup(oPopupOptions);
        }
    );
}


function bx_loading_btn (e, b) {
    e = $(e);

    if (e.children('div').size())
        e = e.children('div').first();

    if (!b) {
        e.find('.bx-loading-ajax-btn').remove();
    } else if (!e.find('.bx-loading-ajax-btn').length) {
        e.append('<b class="bx-loading-ajax-btn"></b>');
        new Spinner(aSpinnerSmallOpts).spin(e.find('.bx-loading-ajax-btn').get(0));
    }
}

function bx_loading_animate (e) {
    e = $(e);
    if (!e.length)
        return false;
    if (e.find('.bx-sys-spinner').length)
        return false;
    return new Spinner(aSpinnerOpts).spin(e.get(0));
}

function bx_loading_content (elem, b, isReplace) {
    var block = $(elem);
    if (!b) {
        block.find(".bx-loading-ajax").remove();
    } else if (!block.find('.bx-loading-ajax').length) {
        if ('undefined' != typeof(isReplace) && isReplace)
            block.html('<div class="bx-loading-ajax" style="position:static;"></div>');
        else
            block.append('<div class="bx-loading-ajax"></div>');
        bx_loading_animate(block.find('.bx-loading-ajax'));
    } 
}

function bx_loading (elem, b) {

    if (typeof elem == 'string')
        elem = '#' + elem;

    var block = $(elem);

    if (1 == b || true == b) {

        bx_loading_content(block, b);

        e = block.find(".bx-loading-ajax");
        e.css('left', parseInt(block.width()/2.0 - e.width()/2.0));

        var he = e.outerHeight();
        var hc = block.outerHeight();

        if (block.css('position') != 'relative' && block.css('position') != 'absolute') {
            if (!block.data('css-save-position'))
                block.data('css-save-position', block.css('position'));
            block.css('position', 'relative');
        }

        if (hc > he) {
            e.css('top', parseInt(hc/2.0 - he/2.0));
        }

        if (hc < he) {
            if (!block.data('css-save-min-height'))
                block.data('css-save-min-height', block.css('min-height'));
            block.css('min-height', he);
        }

    } else {

        if (block.data('css-save-position'))
            block.css('position', block.data('css-save-position'));

        if (block.data('css-save-min-height'))
            block.css('min-height', block.data('css-save-min-height'));

        bx_loading_content(block, b);

    }

}


/**
 * Center content with floating blocks.
 * sSel - jQuery selector of content to be centered
 * sBlockSel - jquery selector of blocks
 */
function bx_center_content (sSel, sBlockStyle) {
    var sId = 'id' + (new Date()).getTime();
    $(sSel).wrap('<div id="'+sId+'"></div>');

    var eCenter = $('#' + sId);
    var iAll = $('#' + sId + ' ' + sBlockStyle).size();
    var iWidthUnit = $('#' + sId + ' ' + sBlockStyle + ':first').outerWidth(true);
    var iWidthContainer = eCenter.innerWidth();           
    var iPerRow = parseInt(iWidthContainer/iWidthUnit);
    var iLeft = (iWidthContainer - (iAll > iPerRow ? iPerRow * iWidthUnit : iAll * iWidthUnit)) / 2;
    eCenter.css("padding-left", iLeft);
}

/**
 * Show pointer popup with menu from URL.
 * @param o - menu object name
 * @param e - element to show popup at
 * @param options - popup options
 * @param vars - additional GET variables
 */
function bx_menu_popup (o, e, options, vars) {
    var options = options || {};
    var vars = vars || {};
    var o = $.extend({}, $.fn.dolPopupDefaultOptions, options, {id: o, url: bx_append_url_params('menu.php', $.extend({o:o}, vars))});
    $(e).dolPopupAjax(o);
}

/**
 * Show pointer popup with menu from existing HTML.
 * @param jSel - jQuery selector for html to show in popup
 * @param e - element to show popup at
 * @param options - popup options
 */
function bx_menu_popup_inline (jSel, e, options) {
    var options = options || {};
    var o = $.extend({}, $.fn.dolPopupDefaultOptions, options, {pointer:{el:$(e)}});
    if ($(jSel + ':visible').length) 
        $(jSel).dolPopupHide(); 
    else 
        $(jSel).dolPopup(o);
}

function validateLoginForm(eForm) {
    return true;
}

/**
 * convert <time> tags to human readable format
 * @param sLang - use sLang localization
 * @param isAutoupdate - for internal usage only
 */
function bx_time(sLang, isAutoupdate, sRootSel) {
    if ('undefined' == typeof(sRootSel))
        sRootSel = 'body';
    var iAutoupdate = 22*60*60; // autoupdate time in realtime if less than 22 hours
    var sSel = 'time';

    if ('undefined' == typeof(sLang)) {
        sLang = glBxTimeLang;
    } else {
        glBxTimeLang = sLang;
    }

    if ('undefined' != typeof(isAutoupdate) && isAutoupdate)
        sSel += '.bx-time-autoupdate';

    $(sRootSel).find(sSel).each(function () {
        var s;
        var sTime = $(this).attr('datetime');
        var iSecondsDiff = moment(sTime).unix() - moment().unix();
        if (iSecondsDiff < 0)
            iSecondsDiff = -iSecondsDiff;

        if (iSecondsDiff < $(this).attr('data-bx-autoformat'))
            s = moment(sTime).lang(sLang).fromNow(); // 'time ago' format
        else
            s = moment(sTime).lang(sLang).format($(this).attr('data-bx-format')); // custom format

        if (iSecondsDiff < iAutoupdate)
            $(this).addClass('bx-time-autoupdate');
        else
            $(this).removeClass('bx-time-autoupdate');

        $(this).html(s);
    });

    if ($('time.bx-time-autoupdate').size()) {
        setTimeout(function () {
            bx_time(sLang, true);
        }, 20000);
    }
}

(function($) {
    $.fn.bxTime = function() {
        bx_time(undefined, undefined, this);
        return this;
    }; 
} (jQuery));


/**
 * Perform connections AJAX request. 
 * In case of error - it shows js alert with error message.
 * In case of success - the page is reloaded.
 * 
 * @param sObj - connections object
 * @param sAction - 'add', 'remove' or 'reject'
 * @param iContentId - content id, initiator is always current logged in user
 * @param bConfirm - show confirmation dialog
 */
function bx_conn_action(e, sObj, sAction, iContentId, bConfirm) {
    if ('undefined' != typeof(bConfirm) && bConfirm && !confirm(_t('_are you sure?')))
        return;
                
    var aParams = {
        obj: sObj,
        act: sAction,
        id: iContentId
    };
    var fCallback = function (data) {
        bx_loading_btn(e, 0);
        if ('object' != typeof(data))
            return;
        if (data.err) {
            alert(data.msg);
        } else {
            if (!loadDynamicBlockAuto(e))
                location.reload();
            else
                $('#bx-popup-ajax-wrapper-bx_persons_view_actions_more').remove();
        }
    };

    bx_loading_btn(e, 1);

    $.ajax({
        dataType: 'json',
        url: sUrlRoot + 'conn.php',
        data: aParams,
        type: 'POST',
        success: fCallback
    });
}

function bx_append_url_params (sUrl, mixedParams) {
    var sParams = sUrl.indexOf('?') == -1 ? '?' : '&';

    if(mixedParams instanceof Array) {
    	for(var i in mixedParams)
            sParams += i + '=' + mixedParams[i] + '&';
        sParams = sParams.substr(0, sParams.length-1);
    }
    else if(mixedParams instanceof Object) {
    	$.each(mixedParams, function(sKey, sValue) {
    		sParams += sKey + '=' + sValue + '&';
    	});
        sParams = sParams.substr(0, sParams.length-1);
    }
    else
        sParams += mixedParams;

    return sUrl + sParams;
}
