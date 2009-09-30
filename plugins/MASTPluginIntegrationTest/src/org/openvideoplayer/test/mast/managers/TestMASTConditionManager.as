package org.openvideoplayer.test.mast.managers
{
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.display.MediaPlayerSprite;
	import org.openvideoplayer.events.MediaErrorEvent;
	import org.openvideoplayer.events.PluginLoadEvent;
	import org.openvideoplayer.mast.MASTPluginInfo;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.plugin.PluginClassResource;
	import org.openvideoplayer.plugin.PluginManager;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.*;
	import org.openvideoplayer.video.VideoElement;

	public class TestMASTConditionManager extends TestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			_eventDispatcher = new EventDispatcher();
		}
		
		override public function tearDown():void
		{
			_eventDispatcher = null;
			_timer = null;
		}

		public function testConditionManager():void
		{
			mediaFactory = new MediaFactory();
			pluginManager = new PluginManager(mediaFactory);

 			sprite = new MediaPlayerSprite();

			loadPlugin(MAST_PLUGIN_INFOCLASS);
		}
		
		private function loadPlugin(source:String):void
		{
			var pluginResource:IMediaResource;
			if (source.substr(0, 4) == "http" || source.substr(0, 4) == "file")
			{
				// This is a URL, create a URLResource
				pluginResource = new URLResource(new URL(source));
			}
			else
			{
				// Assume this is a class
				var pluginInfoRef:Class = getDefinitionByName(source) as Class;
				pluginResource = new PluginClassResource(pluginInfoRef);
			}
			
			loadPluginFromResource(pluginResource);			
		}
		
		private function loadPluginFromResource(pluginResource:IMediaResource):void
		{
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, onPluginLoaded);
			pluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, onPluginLoadFailed);
			pluginManager.loadPlugin(pluginResource);
		}
		
		private function onPluginLoaded(event:PluginLoadEvent):void
		{
			trace(">>> Plugin successfully loaded.");
			loadMainVideo(REMOTE_STREAM);
		}
		
		private function onPluginLoadFailed(event:PluginLoadEvent):void
		{
			trace(">>> Plugin failed to load.");
		}
					
		private function loadMainVideo(url:String):void
		{	
			var resource:IURLResource = new URLResource(new FMSURL(url));

			// Assign to the resource the metadata that indicates that it should have a MAST
			// document applied (and include the URL of that MAST document).
			var kvFacet:KeyValueFacet = new KeyValueFacet(new URL("http://www.akamai.com/mast"));
			kvFacet.addValue(new ObjectIdentifier("url"), MAST_URL_TEST);
			resource.metadata.addFacet(kvFacet);
			
			var mediaElement:MediaElement = mediaFactory.createMediaElement(resource);
			
			if (mediaElement == null)
			{
				var netLoader:NetLoader = new NetLoader();
				
				// Add a default VideoElement
				mediaFactory.addMediaInfo(new MediaInfo("org.openvideoplayer.video", netLoader, VideoElement, [netLoader]));
				mediaElement = mediaFactory.createMediaElement(resource);
			}
			
			mediaElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError, false, 0, true);
			
			_eventDispatcher.addEventListener("testComplete", addAsync(mustReceiveEvent, ASYNC_DELAY));
			_timer = new Timer(30000, 1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			
			sprite.element = mediaElement;
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_eventDispatcher.dispatchEvent(new Event("testComplete"));				
		}
		
		private function mustReceiveEvent(event:Event):void
		{
			// Placeholder to ensure an event is received.
		}
		
   		private function onMediaError(event:MediaErrorEvent):void
   		{
   			var errMsg:String = "Media error : code="+event.error.errorCode+" description="+event.error.description;
   			
   			trace(errMsg);
   		}
		
		private var sprite:MediaPlayerSprite;
		private var pluginManager:PluginManager;
		private var mediaFactory:MediaFactory;
		private var _eventDispatcher:EventDispatcher;
		private var _timer:Timer;
		
		private static const ASYNC_DELAY:Number = 90000;

		private static const MAST_PLUGIN_INFOCLASS:String = "org.openvideoplayer.mast.MASTPluginInfo";		
		private static const loadTestRef:MASTPluginInfo = null;
		
		private static const MAST_URL_TEST:String = "http://mediapm.edgesuite.net/osmf/content/mast/mast_sample_integration_test.xml";
		
		private static const REMOTE_STREAM:String
			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short";
		
	}
}