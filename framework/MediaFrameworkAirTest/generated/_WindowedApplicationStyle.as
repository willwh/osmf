
package 
{

import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import mx.skins.halo.WindowBackground;
import mx.skins.halo.WindowRestoreButtonSkin;
import mx.skins.halo.StatusBarBackgroundSkin;
import mx.skins.halo.WindowCloseButtonSkin;
import mx.skins.halo.ApplicationTitleBarBackgroundSkin;
import mx.skins.halo.WindowMinimizeButtonSkin;
import mx.skins.halo.WindowMaximizeButtonSkin;

[ExcludeClass]

public class _WindowedApplicationStyle
{

    public static function init(fbs:IFlexModuleFactory):void
    {
        var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("WindowedApplication");
    
        if (!style)
        {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("WindowedApplication", style, false);
        }
    
        if (style.defaultFactory == null)
        {
            style.defaultFactory = function():void
            {
                this.statusTextStyleName = "statusTextStyle";
                this.minimizeButtonSkin = mx.skins.halo.WindowMinimizeButtonSkin;
                this.gripperPadding = 3;
                this.borderStyle = "solid";
                this.restoreButtonSkin = mx.skins.halo.WindowRestoreButtonSkin;
                this.closeButtonSkin = mx.skins.halo.WindowCloseButtonSkin;
                this.highlightAlphas = [1.0, 1.0];
                this.cornerRadius = 8;
                this.titleBarBackgroundSkin = mx.skins.halo.ApplicationTitleBarBackgroundSkin;
                this.backgroundImage = mx.skins.halo.WindowBackground;
                this.borderThickness = 1;
                this.buttonPadding = 2;
                this.statusBarBackgroundColor = 0xcccccc;
                this.titleBarButtonPadding = 5;
                this.buttonAlignment = "auto";
                this.titleTextStyleName = "titleTextStyle";
                this.borderColor = 0xa6a6a6;
                this.roundedBottomCorners = false;
                this.titleAlignment = "auto";
                this.showFlexChrome = true;
                this.titleBarColors = [0xffffff, 0xbababa];
                this.gripperStyleName = "gripperSkin";
                this.maximizeButtonSkin = mx.skins.halo.WindowMaximizeButtonSkin;
                this.backgroundColor = 0xc0c0c0;
                this.statusBarBackgroundSkin = mx.skins.halo.StatusBarBackgroundSkin;
            };
        }
    }
}

}
