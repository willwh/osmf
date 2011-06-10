package org.osmf.elements.f4mClasses
{
	import flash.utils.Proxy;
	
	import flashx.textLayout.operations.PasteOperation;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.osmf.elements.F4MElement;
	import org.osmf.elements.ProxyElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.elements.f4mClasses.builders.ManifestBuilder;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.net.StreamingXMLResource;



	public class TestManifestParser
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test(async, timeout="10000", description="Tests Conviva xml use case")]
		public function testXMLParser():void
		{
			const XML_PATH:String = "http://catherine.corp.adobe.com/osmf";
			
			const XML_F4M:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?> " +
				"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\"> <id>myvideo</id> " +
				"<streamType>recorded</streamType> " +
				"<baseURL>http://catherine.corp.adobe.com/osmf/mlm_tests</baseURL> " +
				"<base href=\"http://catherine.corp.adobe.com/osmf/mlm_tests\" /> " +
				"<media url=\"rtmp://cp67126.edgefcs.net/ondemand/mp4:mediapm/osmf/content/test/spacealonehd_sounas_640_700.mp4\" bitrate=\"700\"/> " +
				"</manifest>";

			var streamingXMLResource:StreamingXMLResource = new StreamingXMLResource(XML_F4M, XML_PATH);
			var f4MElement1:F4MElement = new F4MElement(streamingXMLResource);			
			var player:MediaPlayer = new MediaPlayer();
			
			Async.handleEvent(this, player,
				MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
				onStateChange, TIMEOUT, this);
			
			player.muted = false;
			player.loop = false;
			player.autoPlay = false;
			player.media = f4MElement1;
			player.bufferTime = 5;
			
			assertEquals((f4MElement1.proxiedElement.resource as URLResource).url, "rtmp://cp67126.edgefcs.net/ondemand/mp4:mediapm/osmf/content/test/spacealonehd_sounas_640_700.mp4");
			assertEquals(((player.media as ProxyElement).proxiedElement.resource as URLResource).url, "rtmp://cp67126.edgefcs.net/ondemand/mp4:mediapm/osmf/content/test/spacealonehd_sounas_640_700.mp4");

			function onStateChange(event:MediaPlayerStateChangeEvent, test:*):void
			{
				//media was loaded, no media error
				assertTrue(true);
			}
		}

		/// Internals
		private static const TIMEOUT:Number = 4000;
	}
}