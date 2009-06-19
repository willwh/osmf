
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _winRestoreButtonStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_down.png', original='win_restore_down.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_down.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='276')]
    private static var _embed_css_win_restore_down_png_1224077798:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_up.png', original='win_restore_up.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_up.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='274')]
    private static var _embed_css_win_restore_up_png_1387154140:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_over.png', original='win_restore_over.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$win_restore_over.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='275')]
    private static var _embed_css_win_restore_over_png_318640574:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winRestoreButton");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winRestoreButton", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_win_restore_up_png_1387154140;
                this.downSkin = _embed_css_win_restore_down_png_1224077798;
                this.overSkin = _embed_css_win_restore_over_png_318640574;
            };
        }
    }
}

}
