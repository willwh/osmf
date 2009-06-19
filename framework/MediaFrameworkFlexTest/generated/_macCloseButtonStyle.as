
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _macCloseButtonStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_over.png', original='mac_close_over.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_over.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='96')]
    private static var _embed_css_mac_close_over_png_1856448972:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_up.png', original='mac_close_up.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_up.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='97')]
    private static var _embed_css_mac_close_up_png_1936405314:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_down.png', original='mac_close_down.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_close_down.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='95')]
    private static var _embed_css_mac_close_down_png_1179775488:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".macCloseButton");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".macCloseButton", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_mac_close_up_png_1936405314;
                this.overSkin = _embed_css_mac_close_over_png_1856448972;
                this.downSkin = _embed_css_mac_close_down_png_1179775488;
            };
        }
    }
}

}
