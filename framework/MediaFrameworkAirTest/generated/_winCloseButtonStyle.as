
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _winCloseButtonStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_up.png', original='win_close_up.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_up.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='165')]
    private static var _embed_css_win_close_up_png_1495060488:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_over.png', original='win_close_over.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_over.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='164')]
    private static var _embed_css_win_close_over_png_1596880394:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_down.png', original='win_close_down.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_close_down.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='163')]
    private static var _embed_css_win_close_down_png_1164241398:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winCloseButton");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winCloseButton", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_win_close_up_png_1495060488;
                this.overSkin = _embed_css_win_close_over_png_1596880394;
                this.downSkin = _embed_css_win_close_down_png_1164241398;
            };
        }
    }
}

}
