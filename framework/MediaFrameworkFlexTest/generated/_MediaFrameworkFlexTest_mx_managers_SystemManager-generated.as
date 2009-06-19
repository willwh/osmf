package
{

import flash.text.Font;
import flash.text.TextFormat;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;

import mx.managers.SystemManager;

public class _MediaFrameworkFlexTest_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    public function _MediaFrameworkFlexTest_mx_managers_SystemManager()
    {

        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "MediaFrameworkFlexTest" : String(params[0]);
        var mainClass:Class = Class(getDefinitionByName(mainClassName));
        if (!mainClass)
            return null;

        var instance:Object = new mainClass();
        if (instance is IFlexModule)
            (IFlexModule(instance)).moduleFactory = this;
        return instance;
    }

    override    public function info():Object
    {
        return {
            compiledLocales: [ "en_US" ],
            compiledResourceBundleNames: [ "containers", "core", "effects", "skins", "styles" ],
            creationComplete: "onComplete()",
            currentDomain: ApplicationDomain.currentDomain,
            layout: "absolute",
            mainClassName: "MediaFrameworkFlexTest",
            mixins: [ "_MediaFrameworkFlexTest_FlexInit", "_macMinButtonStyle", "_alertButtonStyleStyle", "_ScrollBarStyle", "_winMaxButtonStyle", "_activeTabStyleStyle", "_textAreaHScrollBarStyleStyle", "_ToolTipStyle", "_winCloseButtonStyle", "_macCloseButtonStyle", "_statusTextStyleStyle", "_gripperSkinStyle", "_comboDropdownStyle", "_winRestoreButtonStyle", "_textAreaVScrollBarStyleStyle", "_ContainerStyle", "_globalStyle", "_linkButtonStyleStyle", "_windowStatusStyle", "_windowStylesStyle", "_activeButtonStyleStyle", "_errorTipStyle", "_richTextEditorTextAreaStyleStyle", "_todayStyleStyle", "_CursorManagerStyle", "_dateFieldPopupStyle", "_plainStyle", "_dataGridStylesStyle", "_winMinButtonStyle", "_macMaxButtonStyle", "_ApplicationStyle", "_headerDateTextStyle", "_ButtonStyle", "_popUpMenuStyle", "_titleTextStyleStyle", "_swatchPanelTextFieldStyle", "_opaquePanelStyle", "_weekDayStyleStyle", "_headerDragProxyStyleStyle" ]
        }
    }
}

}
