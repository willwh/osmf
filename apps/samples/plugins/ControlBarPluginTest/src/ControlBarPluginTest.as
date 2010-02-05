package 
{
	import flash.display.Sprite;
	
	import org.osmf.composition.ParallelElement;
	import org.osmf.events.PluginManagerEvent;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.RegistrationPoint;
	import org.osmf.media.*;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.plugin.PluginInfoResource;
	import org.osmf.utils.URL;
	
	[SWF(width="640", height="360", backgroundColor="0x000000",frameRate="25")]
	public class ControlBarPluginTest extends Sprite
	{
		public function ControlBarPluginTest()
		{
			osmf = new OSMFConfiguration();
			
			osmf.mediaElement = constructRootElement();
			osmf.view = this;
			
			osmf.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginLoaded);
			osmf.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginLoadError);
			osmf.pluginManager.loadPlugin(pluginResource);
			
			osmf.container.width = 640;
			osmf.container.height = 360;
		}
		
		// Internals
		//
		
		private var osmf:OSMFConfiguration;
		private var rootElement:ParallelElement;
		
		private function onPluginLoaded(event:PluginManagerEvent):void
		{
			rootElement.addChild(constructControlBarElement());
		}
		
		private function onPluginLoadError(event:PluginManagerEvent):void
		{
			trace("ERROR: the control bar plugin failed to load.");
		}
		
		private function constructRootElement():MediaElement
		{
			rootElement = new ParallelElement();
			rootElement.addChild(constructVideoElement());
			
			return rootElement;
		}
		
		private function constructVideoElement():MediaElement
		{
			var controlBarTarget:KeyValueFacet
				= new KeyValueFacet
					( ControlBarPlugin.NS_CONTROL_BAR_TARGET
					, NullFacetSynthesizer
					);
			controlBarTarget.addValue(ID, "mainContent");
			
			var video:MediaElement = osmf.factory.createMediaElement(new URLResource(VIDEO_URL));
			video.metadata.addFacet(controlBarTarget);
			
			return video;
		}
		
		private function constructControlBarElement():MediaElement
		{
			var controlBarSettings:KeyValueFacet
				= new KeyValueFacet
					( ControlBarPlugin.NS_CONTROL_BAR_SETTINGS
					, NullFacetSynthesizer // Don't have this facet inherit.
					);
			controlBarSettings.addValue(ID, "mainContent");
			
			var resource:MediaResourceBase = new MediaResourceBase();
			resource.metadata.addFacet(controlBarSettings);
			
			var controlBar:MediaElement = osmf.factory.createMediaElement(resource);
			
			var layout:LayoutRendererProperties = new LayoutRendererProperties(controlBar);
			layout.alignment = RegistrationPoint.BOTTOM_MIDDLE;
			layout.order = 1;
			
			return controlBar;
		}
		
		/* static */
		
		private static const VIDEO_URL:URL
			= new URL("http://dl.dropbox.com/u/2980264/OSMF/logo_animated.flv");
			
		private static var ID:ObjectIdentifier = new ObjectIdentifier("ID");
		
		// Comment out to load the plug-in for a SWF (instead of using static linking, for testing):	
		//private static const pluginResource:URLResource = new URLResource(new URL("ControlBarPlugin.swf"));
		
		private static const pluginResource:PluginInfoResource = new PluginInfoResource(new ControlBarPlugin().pluginInfo);
	}
}