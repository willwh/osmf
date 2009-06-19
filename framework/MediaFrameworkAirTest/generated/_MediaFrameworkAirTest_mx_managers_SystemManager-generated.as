package
{

import flash.text.Font;
import flash.text.TextFormat;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;
import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.EmbeddedFontRegistry;

import mx.managers.SystemManager;

public class _MediaFrameworkAirTest_mx_managers_SystemManager
    extends mx.managers.SystemManager
    implements IFlexModuleFactory
{
    public function _MediaFrameworkAirTest_mx_managers_SystemManager()
    {

        super();
    }

    override     public function create(... params):Object
    {
        if (params.length > 0 && !(params[0] is String))
            return super.create.apply(this, params);

        var mainClassName:String = params.length == 0 ? "MediaFrameworkAirTest" : String(params[0]);
        var mainClass:Class = Class(getDefinitionByName(mainClassName));
        if (!mainClass)
            return null;

        var instance:Object = new mainClass();
        if (instance is IFlexModule)
            (IFlexModule(instance)).moduleFactory = this;
        if (params.length == 0)
            EmbeddedFontRegistry.registerFonts(info()["fonts"], this);
        return instance;
    }

    override    public function info():Object
    {
        return {
            compiledLocales: [ "en_US" ],
            compiledResourceBundleNames: [ "SharedResources", "collections", "containers", "controls", "core", "effects", "formatters", "logging", "skins", "styles" ],
            currentDomain: ApplicationDomain.currentDomain,
            fonts:       {
"Myriad Pro" : {regular:true, bold:true, italic:false, boldItalic:false}
,
"Myriad Pro SemiCond" : {regular:true, bold:false, italic:false, boldItalic:false}
}
,
            logName: "MediaFrameworkAirTest",
            mainClassName: "MediaFrameworkAirTest",
            mixins: [ "_MediaFrameworkAirTest_FlexInit", "_alertButtonStyleStyle", "_ScrollBarStyle", "_winMaxButtonStyle", "_ToolTipStyle", "_HDividedBoxStyle", "_ComboBoxStyle", "_winCloseButtonStyle", "_macCloseButtonStyle", "_comboDropdownStyle", "_gripperSkinStyle", "_ListBaseStyle", "_winRestoreButtonStyle", "_ProgressBarStyle", "_globalStyle", "_PanelStyle", "_windowStylesStyle", "_DividedBoxStyle", "_activeButtonStyleStyle", "_errorTipStyle", "_CursorManagerStyle", "_dateFieldPopupStyle", "_HRuleStyle", "_dataGridStylesStyle", "_AlertStyle", "_macMinButtonStyle", "_ControlBarStyle", "_activeTabStyleStyle", "_textAreaHScrollBarStyleStyle", "_TreeStyle", "_DragManagerStyle", "_statusTextStyleStyle", "_TextAreaStyle", "_WindowedApplicationStyle", "_HTMLStyle", "_textAreaVScrollBarStyleStyle", "_ContainerStyle", "_linkButtonStyleStyle", "_windowStatusStyle", "_WindowStyle", "_richTextEditorTextAreaStyleStyle", "_FormItemStyle", "_todayStyleStyle", "_TextInputStyle", "_plainStyle", "_winMinButtonStyle", "_macMaxButtonStyle", "_FormStyle", "_ApplicationStyle", "_SWFLoaderStyle", "_FormItemLabelStyle", "_headerDateTextStyle", "_ButtonStyle", "_popUpMenuStyle", "_titleTextStyleStyle", "_swatchPanelTextFieldStyle", "_opaquePanelStyle", "_weekDayStyleStyle", "_headerDragProxyStyleStyle", "_com_adobe_strobe_strobeunit_StrobeUnitTestAppWatcherSetupUtil", "_flexunit_flexui_TestRunnerBaseWatcherSetupUtil", "_flexunit_flexui_controls_RightHandSideWatcherSetupUtil", "_flexunit_flexui_controls_LeftHandSideWatcherSetupUtil", "_flexunit_flexui_controls_right_TestsCompleteWatcherSetupUtil", "_flexunit_flexui_controls_right_RunningTestsWatcherSetupUtil", "_flexunit_flexui_controls_right_StackTraceContainerWatcherSetupUtil", "_flexunit_flexui_controls_left_TestCasesTreeWatcherSetupUtil", "_flexunit_flexui_controls_left_FilterAreaWatcherSetupUtil", "_flexunit_flexui_controls_right_SelectedTestCaseFormWatcherSetupUtil", "_MediaFrameworkAirTestWatcherSetupUtil" ],
            suite: "{new MediaFrameworkTests()}"
        }
    }
}

}
