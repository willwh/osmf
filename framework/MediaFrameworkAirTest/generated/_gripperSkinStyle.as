
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _gripperSkinStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$gripper_up.png', original='gripper_up.png', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$gripper_up.png', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/air/airframework.swc$defaults.css', _line='70')]
    private static var _embed_css_gripper_up_png_2032861924:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".gripperSkin");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".gripperSkin", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.upSkin = _embed_css_gripper_up_png_2032861924;
                this.overSkin = _embed_css_gripper_up_png_2032861924;
                this.downSkin = _embed_css_gripper_up_png_2032861924;
            };
        }
    }
}

}
