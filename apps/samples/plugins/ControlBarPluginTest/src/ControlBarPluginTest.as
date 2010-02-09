package 
{
	import flash.display.Sprite;
	
	import org.osmf.elements.ParallelElement;
	import org.osmf.events.PluginManagerEvent;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.VerticalAlign;
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
			// Construct an OSMFConfiguration helper class:	
			osmf = new OSMFConfiguration();
			
			// Construct the main element to play back. This will be a
			// parallel element, that will hold the main content to
			// playback, and the control bar (from a plug-in) as its
			// children:
			osmf.mediaElement = constructRootElement();
			osmf.view = this;
			
			// Add event listeners to the plug-in manager so we'll get
			// a heads-up when the control bar plug-in finishes loading:
			osmf.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD, onPluginLoaded);
			osmf.pluginManager.addEventListener(PluginManagerEvent.PLUGIN_LOAD_ERROR, onPluginLoadError);
			
			// Ask the plug-in manager to load the control bar plug-in:
			osmf.pluginManager.loadPlugin(pluginResource);
		}
		
		// Internals
		//
		
		private var osmf:OSMFConfiguration;
		private var rootElement:ParallelElement;
		
		private function onPluginLoaded(event:PluginManagerEvent):void
		{
			// The plugin loaded successfully. We can now construct a control
			// bar media element, and add it as a child to the root parallel
			// element:
			rootElement.addChild(constructControlBarElement());
		}
		
		private function onPluginLoadError(event:PluginManagerEvent):void
		{
			trace("ERROR: the control bar plugin failed to load.");
		}
		
		private function constructRootElement():MediaElement
		{
			// Construct a parallel media element to hold the main content,
			// and later on, the control bar.
			rootElement = new ParallelElement();
			rootElement.addChild(constructVideoElement());
			
			// Use the layout api to set the parallel elements width and
			// height. Make it as big as the stage currently is:
			var rootElementLayout:LayoutRendererProperties = new LayoutRendererProperties(rootElement);
			rootElementLayout.width = stage.stageWidth;
			rootElementLayout.height = stage.stageHeight;
			
			return rootElement;
		}
		
		private function constructVideoElement():MediaElement
		{
			// Construct a metadata facet that we can append to the video's collection
			// of metadata. The control bar plug-in will use the metadata to identify
			// the video element as its target:
			var controlBarTarget:KeyValueFacet
				= new KeyValueFacet
					( ControlBarPlugin.NS_CONTROL_BAR_TARGET
					, NullFacetSynthesizer
					);
			controlBarTarget.addValue(ID, "mainContent");
			
			// Construct a video element:
			var video:MediaElement = osmf.factory.createMediaElement(new URLResource(VIDEO_URL));
			
			// Add the metadata facet to the video's metadata:
			video.metadata.addFacet(controlBarTarget);
			
			return video;
		}
		
		private function constructControlBarElement():MediaElement
		{
			// Construct a metadata facet that we'll send to the media factory on
			// requesting a control bar element to be instantiated. The factory
			// will use it to parameterize the element. Specifically, the ID field
			// will tell the plug-in what the ID of the content it should control
			// is:
			var controlBarSettings:KeyValueFacet
				= new KeyValueFacet
					( ControlBarPlugin.NS_CONTROL_BAR_SETTINGS
					, NullFacetSynthesizer // Don't have this facet inherit.
					);
			controlBarSettings.addValue(ID, "mainContent");
			
			// Add the metadata facet to an otherwise empty media resource object:
			var resource:MediaResourceBase = new MediaResourceBase();
			resource.metadata.addFacet(controlBarSettings);
			
			// Request the media factory to construct a control bar element. The
			// factory will infer a control bar element is requested by inspecting
			// the resource's metadata (and encountering a facet of namespace
			// NS_CONTROL_BAR_SETTINGS there):
			var controlBar:MediaElement = osmf.factory.createMediaElement(resource);
			
			// Set some layout properties on the control bar. Specifically, have it
			// appear at the bottom of the parallel element, horizontally centererd:
			var layout:LayoutRendererProperties = new LayoutRendererProperties(controlBar);
			layout.verticalAlignment = VerticalAlign.BOTTOM;
			layout.horizontalAlignment = HorizontalAlign.CENTER;
			
			// Make sure that the element shows over the video: element's with a
			// higher order number set are placed higher in the display list:
			layout.index = 1;
			
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