package org.openvideoplayer.test.mast
{
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.mast.MASTPluginInfo;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.plugin.IPluginInfo;

	public class TestMASTPluginInfo extends TestCase
	{
		public function testGetMediaInfoAt():void
		{
			var pluginInfo:IPluginInfo = new MASTPluginInfo();
			
			assertNotNull(pluginInfo);
			
			var mediaInfo:IMediaInfo = pluginInfo.getMediaInfoAt(0);
			
			assertNotNull(mediaInfo);
		}
		
		public function testGetMediaInfoAtWithBadIndex():void
		{
			var pluginInfo:IPluginInfo = new MASTPluginInfo();
			
			assertNotNull(pluginInfo);

			try
			{			
				var mediaInfo:IMediaInfo = pluginInfo.getMediaInfoAt(10);
				fail();
			}
			catch(error:IllegalOperationError)
			{
			}
		}
		
		public function testIsFrameworkVersionSupported():void
		{
			var pluginInfo:IPluginInfo = new MASTPluginInfo();
			assertNotNull(pluginInfo);
			
			// Framework version 0.5.0 is the minimum this plugin supports.
			assertEquals(true, pluginInfo.isFrameworkVersionSupported("1.0.0"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.0.1"));
			assertEquals(true, pluginInfo.isFrameworkVersionSupported("0.5.1"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("0.4.9"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported(null));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported(""));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("abc"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("foo.bar"));
			assertEquals(false, pluginInfo.isFrameworkVersionSupported("foobar."));
		}
		
		public function testNumMediaInfos():void
		{
			var pluginInfo:IPluginInfo = new MASTPluginInfo();
			assertNotNull(pluginInfo);

			assertTrue(pluginInfo.numMediaInfos > 0);			
		}
	}
}
