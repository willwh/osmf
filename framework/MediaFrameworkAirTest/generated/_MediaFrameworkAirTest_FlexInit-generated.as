package {
import flash.utils.*;
import mx.core.IFlexModuleFactory;
import flash.system.*
import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.utils.ObjectProxy;
import mx.effects.EffectManager;
import mx.core.mx_internal;

[Mixin]
public class _MediaFrameworkAirTest_FlexInit
{
   public function _MediaFrameworkAirTest_FlexInit()
   {
       super();
   }
   public static function init(fbs:IFlexModuleFactory):void
   {
      EffectManager.mx_internal::registerEffectTrigger("addedEffect", "added");
      EffectManager.mx_internal::registerEffectTrigger("closeEffect", "windowClose");
      EffectManager.mx_internal::registerEffectTrigger("completeEffect", "complete");
      EffectManager.mx_internal::registerEffectTrigger("creationCompleteEffect", "creationComplete");
      EffectManager.mx_internal::registerEffectTrigger("focusInEffect", "focusIn");
      EffectManager.mx_internal::registerEffectTrigger("focusOutEffect", "focusOut");
      EffectManager.mx_internal::registerEffectTrigger("hideEffect", "hide");
      EffectManager.mx_internal::registerEffectTrigger("itemsChangeEffect", "itemsChange");
      EffectManager.mx_internal::registerEffectTrigger("minimizeEffect", "windowMinimize");
      EffectManager.mx_internal::registerEffectTrigger("mouseDownEffect", "mouseDown");
      EffectManager.mx_internal::registerEffectTrigger("mouseUpEffect", "mouseUp");
      EffectManager.mx_internal::registerEffectTrigger("moveEffect", "move");
      EffectManager.mx_internal::registerEffectTrigger("removedEffect", "removed");
      EffectManager.mx_internal::registerEffectTrigger("resizeEffect", "resize");
      EffectManager.mx_internal::registerEffectTrigger("resizeEndEffect", "resizeEnd");
      EffectManager.mx_internal::registerEffectTrigger("resizeStartEffect", "resizeStart");
      EffectManager.mx_internal::registerEffectTrigger("rollOutEffect", "rollOut");
      EffectManager.mx_internal::registerEffectTrigger("rollOverEffect", "rollOver");
      EffectManager.mx_internal::registerEffectTrigger("showEffect", "show");
      EffectManager.mx_internal::registerEffectTrigger("unminimizeEffect", "windowUnminimize");
      try {
      if (flash.net.getClassByAlias("flex.messaging.io.ArrayCollection") == null){
          flash.net.registerClassAlias("flex.messaging.io.ArrayCollection", mx.collections.ArrayCollection);}
      } catch (e:Error) {
          flash.net.registerClassAlias("flex.messaging.io.ArrayCollection", mx.collections.ArrayCollection); }
      try {
      if (flash.net.getClassByAlias("flex.messaging.io.ArrayList") == null){
          flash.net.registerClassAlias("flex.messaging.io.ArrayList", mx.collections.ArrayList);}
      } catch (e:Error) {
          flash.net.registerClassAlias("flex.messaging.io.ArrayList", mx.collections.ArrayList); }
      try {
      if (flash.net.getClassByAlias("flex.messaging.io.ObjectProxy") == null){
          flash.net.registerClassAlias("flex.messaging.io.ObjectProxy", mx.utils.ObjectProxy);}
      } catch (e:Error) {
          flash.net.registerClassAlias("flex.messaging.io.ObjectProxy", mx.utils.ObjectProxy); }
      var styleNames:Array = ["fontWeight", "modalTransparencyBlur", "backgroundDisabledColor", "barColor", "textAlign", "disabledIconColor", "fontStyle", "titleBarBackgroundSkin", "depthColors", "statusBarBackgroundColor", "modalTransparencyDuration", "titleTextStyleName", "strokeWidth", "fontGridFitType", "disabledColor", "modalTransparencyColor", "titleAlignment", "alternatingItemColors", "dropShadowColor", "titleBarColors", "fontThickness", "labelWidth", "fontSharpness", "textDecoration", "statusBarBackgroundSkin", "dividerColor", "statusTextStyleName", "strokeColor", "textRollOverColor", "rollOverColor", "textIndent", "fontSize", "kerning", "footerColors", "dropdownBorderColor", "buttonPadding", "textSelectedColor", "buttonAlignment", "modalTransparency", "selectionColor", "fontAntiAliasType", "selectionDisabledColor", "leading", "shadowColor", "iconColor", "themeColor", "letterSpacing", "indicatorGap", "fontFamily", "color", "errorColor", "headerColors"];

      import mx.styles.StyleManager;

      for (var i:int = 0; i < styleNames.length; i++)
      {
         StyleManager.registerInheritingStyle(styleNames[i]);
      }
   }
}  // FlexInit
}  // package
