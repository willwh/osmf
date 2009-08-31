package org.openvideoplayer.plugin
{
	import flash.display.Loader;
	
	import flexunit.framework.TestCase;

	public class TestPluginLoadedContext extends TestCase
	{
		public function TestPluginLoadedContext(methodName:String=null)
		{
			super(methodName);
		}
		
		public function testPluginLoadedContext():void
		{
			var pluginInfo:SimpleVideoPluginInfo = new SimpleVideoPluginInfo();
			var loader:Loader = new Loader();
			var context:PluginLoadedContext = new PluginLoadedContext(pluginInfo, loader);
			
			assertTrue(context.loader == loader);
			assertTrue(context.pluginInfo == pluginInfo);
		}
	}
}