
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;

[ExcludeClass]

public class _TreeStyle
{
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$defaults.css', _line='1552', symbol='TreeDisclosureOpen')]
    private static var _embed_css_Assets_swf_TreeDisclosureOpen_36803628:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$defaults.css', _line='1550', symbol='TreeNodeIcon')]
    private static var _embed_css_Assets_swf_TreeNodeIcon_619387368:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$defaults.css', _line='1551', symbol='TreeDisclosureClosed')]
    private static var _embed_css_Assets_swf_TreeDisclosureClosed_2037434574:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$defaults.css', _line='1554', symbol='TreeFolderOpen')]
    private static var _embed_css_Assets_swf_TreeFolderOpen_2015077165:Class;
    [Embed(_resolvedSource='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', original='Assets.swf', source='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$Assets.swf', _file='/Users/oconnell/src/strobe/dev/trunk/build/sdk/20090212apms/frameworks/libs/framework.swc$defaults.css', _line='1553', symbol='TreeFolderClosed')]
    private static var _embed_css_Assets_swf_TreeFolderClosed_705539265:Class;

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Tree");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Tree", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.paddingLeft = 2;
                this.folderClosedIcon = _embed_css_Assets_swf_TreeFolderClosed_705539265;
                this.defaultLeafIcon = _embed_css_Assets_swf_TreeNodeIcon_619387368;
                this.paddingRight = 0;
                this.verticalAlign = "middle";
                this.disclosureClosedIcon = _embed_css_Assets_swf_TreeDisclosureClosed_2037434574;
                this.folderOpenIcon = _embed_css_Assets_swf_TreeFolderOpen_2015077165;
                this.disclosureOpenIcon = _embed_css_Assets_swf_TreeDisclosureOpen_36803628;
            };
        }
    }
}

}
