package org.osmf.test.captioning
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.captioning.CaptioningPluginInfo;
	import org.osmf.media.MediaInfo;
	import org.osmf.plugin.IPluginInfo;

	public class TestCaptioningPluginInfo extends TestCase
	{
		public function testGetMediaInfoAt():void
		{
			var pluginInfo:IPluginInfo = new CaptioningPluginInfo();
			
			assertNotNull(pluginInfo);
			
			var mediaInfo:MediaInfo = pluginInfo.getMediaInfoAt(0);
			
			assertNotNull(mediaInfo);
		}
		
		public function testGetMediaInfoAtWithBadIndex():void
		{
			var pluginInfo:IPluginInfo = new CaptioningPluginInfo();
			
			assertNotNull(pluginInfo);

			try
			{			
				var mediaInfo:MediaInfo = pluginInfo.getMediaInfoAt(10);
				fail();
			}
			catch(error:IllegalOperationError)
			{
			}
		}
		
		public function testIsFrameworkVersionSupported():void
		{
			var pluginInfo:IPluginInfo = new CaptioningPluginInfo();
			assertNotNull(pluginInfo);
			
			// Framework version 0.7.0 is the minimum this plugin supports.
			assertEquals(true, pluginInfo.isFrameworkVersionSupported("1.0.0"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.0.1"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.5.1"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.7.0"));
			assertEquals(true, pluginInfo.isFrameworkVersionSupported("0.8.0"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.4.9"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported(null));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported(""));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("abc"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("foo.bar"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("foobar."));
		}
		
		public function testNumMediaInfos():void
		{
			var pluginInfo:IPluginInfo = new CaptioningPluginInfo();
			assertNotNull(pluginInfo);

			assertTrue(pluginInfo.numMediaInfos > 0);			
		}
	}
}
