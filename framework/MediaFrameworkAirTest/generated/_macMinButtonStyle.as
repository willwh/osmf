
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _macMinButtonStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_up.png', original='mac_min_up.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_up.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='126')]
    private static var _embed_css_mac_min_up_png_920223042:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_over.png', original='mac_min_over.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_over.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='125')]
    private static var _embed_css_mac_min_over_png_230360320:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_down.png', original='mac_min_down.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_down.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='124')]
    private static var _embed_css_mac_min_down_png_1792137732:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_dis.png', original='mac_min_dis.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$mac_min_dis.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='123')]
    private static var _embed_css_mac_min_dis_png_508110068:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".macMinButton");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".macMinButton", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_mac_min_up_png_920223042;
                this.overSkin = _embed_css_mac_min_over_png_230360320;
                this.downSkin = _embed_css_mac_min_down_png_1792137732;
                this.disabledSkin = _embed_css_mac_min_dis_png_508110068;
                this.alpha = 0.5;
            };
        }
    }
}

}
