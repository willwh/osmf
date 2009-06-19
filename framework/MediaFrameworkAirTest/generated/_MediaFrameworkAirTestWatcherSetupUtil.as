






package
{
import flash.display.Sprite;
import mx.core.IFlexModuleFactory;
import mx.binding.ArrayElementWatcher;
import mx.binding.FunctionReturnWatcher;
import mx.binding.IWatcherSetupUtil;
import mx.binding.PropertyWatcher;
import mx.binding.RepeaterComponentWatcher;
import mx.binding.RepeaterItemWatcher;
import mx.binding.StaticPropertyWatcher;
import mx.binding.XMLWatcher;
import mx.binding.Watcher;

[ExcludeClass]
[Mixin]
public class _MediaFrameworkAirTestWatcherSetupUtil extends Sprite
    implements mx.binding.IWatcherSetupUtil
{
    public function _MediaFrameworkAirTestWatcherSetupUtil()
    {
        super();
    }

    public static function init(fbs:IFlexModuleFactory):void
    {
        import MediaFrameworkAirTest;
        (MediaFrameworkAirTest).watcherSetupUtil = new _MediaFrameworkAirTestWatcherSetupUtil();
    }

    public function setup(target:Object,
                          propertyGetter:Function,
                          bindings:Array,
                          watchers:Array):void
    {
        import mx.core.DeferredInstanceFromFunction;
        import mx.core.UIComponentDescriptor;
        import mx.core.mx_internal;
        import flexunit.framework.TestSuite;
        import com.adobe.strobe.strobeunit.StrobeUnitTestApp;
        import mx.core.IPropertyChangeNotifier;
        import mx.core.IFactory;
        import mx.binding.IBindingClient;
        import mx.core.DeferredInstanceFromClass;
        import mx.core.IDeferredInstance;
        import mx.core.ClassFactory;


    }
}

}
