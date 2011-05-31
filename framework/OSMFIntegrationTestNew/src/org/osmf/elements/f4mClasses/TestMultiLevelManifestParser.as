package org.osmf.elements.f4mClasses
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.osmf.elements.f4mClasses.MultiLevelManifestParser;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.ParseEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.URLResource;
	import org.osmf.net.StreamType;
	import org.osmf.traits.DVRTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class TestMultiLevelManifestParser
	{
		[Before]
		public function setUp():void
		{
			parser = new MultiLevelManifestParser();
			parser2 = new MultiLevelManifestParser();

		}
		
		[After]
		public function tearDown():void
		{
			parser = null;
			parser2 = null;
			
		}
		
		[Test(async, description="Tests backwards compatability with a 1.0 F4M.")]
		public function testParseF4M():void
		{
			var asyncHandler:Function = Async.asyncHandler(this, handleTestParseF4MLoad, TIMEOUT, null, handleTimeout);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, asyncHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleTestParseF4MError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleTestParseF4MError);
			loader.load(new URLRequest(F4M_SOURCE));
		}
		
		private function handleTestParseF4MLoad(event:Event, passThroughData:Object):void
		{
			var resourceData:String = String((event.target as URLLoader).data);
			
			var asyncHandler:Function = Async.asyncHandler(this, handleParseF4MComplete, TIMEOUT, null, handleTimeout);
			parser.addEventListener(ParseEvent.PARSE_COMPLETE, asyncHandler, false, 0, true);
			parser.parse(resourceData);	
		}
		
		private function handleTestParseF4MError(event:Event):void
		{
			throw new Error( "Error loading F4M file." );
		}
		
		private function handleParseF4MComplete(event:ParseEvent, passThroughData:Object):void
		{
			var manifest:Manifest = event.data as Manifest;
			
			Assert.assertNotNull(manifest);
			Assert.assertEquals(manifest.id, "myvideo");
			Assert.assertTrue(isNaN(manifest.duration));
			Assert.assertEquals(manifest.streamType, StreamType.RECORDED);	
			Assert.assertEquals(manifest.mimeType, "video/mp4");
			Assert.assertEquals(manifest.media.length, 5);
		}
		
		[Test(async, description="Tests a 2.0 F4M.")]
		public function testParseMultiLevelF4M():void
		{
			var asyncHandler:Function = Async.asyncHandler(this, handleTestParseMultiLevelF4MLoad, TIMEOUT, null, handleTimeout);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, asyncHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleTestParseMultiLevelF4MError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleTestParseMultiLevelF4MError);
			loader.load(new URLRequest(MLM_SOURCE));
		}
		
		private function handleTestParseMultiLevelF4MLoad(event:Event, passThroughData:Object):void
		{
			var resourceData:String = String((event.target as URLLoader).data);
			
			var asyncHandler:Function = Async.asyncHandler(this, handleParseMultiLevelF4MComplete, TIMEOUT, null, handleTimeout);
			parser.addEventListener(ParseEvent.PARSE_COMPLETE, asyncHandler, false, 0, true);
			parser.parse(resourceData, MLM_PATH);	
		}
		
		private function handleTestParseMultiLevelF4MError(event:Event):void
		{
			throw new Error( "Error loading F4M file." );
		}
		
		private function handleParseMultiLevelF4MComplete(event:ParseEvent, passThroughData:Object):void
		{
			var manifest:Manifest = event.data as Manifest;
			
			Assert.assertNotNull(manifest);
			Assert.assertEquals(manifest.id, "myvideo");
			Assert.assertEquals(manifest.duration, 605);
			Assert.assertEquals(manifest.streamType, StreamType.RECORDED);	
			Assert.assertEquals(manifest.mimeType, null);
			Assert.assertEquals(manifest.media.length, 2);
			Assert.assertEquals(Media(manifest.media[0]).bitrate, 1400);
			Assert.assertEquals(Media(manifest.media[1]).bitrate, 1000);
		}
		
		private function handleTimeout( passThroughData:Object ):void {
			Assert.fail( "Timeout reached before event." );
		}
		
		
		[Test(description="Tests that the windowDuration parameter is parsed.")]
		public function testWindowDuration():void
		{
			parser2.parse(F4M_WITH_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						Assert.assertEquals(manifest.dvrInfo.windowDuration, WINDOW_DURATION);
					}
				);
		}
		
		[Test(description="Tests that a negative windowDuration parameter is parsed.")]
		public function testWindowNegativeDuration():void
		{
			parser2.parse(F4M_WITH_NEGATIVE_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						Assert.assertEquals(manifest.dvrInfo.windowDuration, 0);
					}
				);
		}
		
		[Test(description="Tests that a null/empty windowDuration parameter is parsed.")]
		public function testWindowNullDuration():void
		{
			parser2.parse(F4M_WITH_NULL_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						assertEquals(manifest.dvrInfo.windowDuration, 0);
					}
				);
		}
		
		[Test(description="Tests when zero windowDuration parameter is parsed.")]
		public function testWindowZeroDuration():void
		{
			parser2.parse(F4M_WITH_ZERO_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						assertEquals(manifest.dvrInfo.windowDuration, 0);
					}
				);
		}
		
		[Test(description="Tests when float windowDuration parameter is parsed.")]
		public function testWindowFloatDuration():void
		{
			parser2.parse(F4M_WITH_FLOAT_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						assertEquals(manifest.dvrInfo.windowDuration, 180.6);
					}
				);
		}
		
		[Test(description="Tests when alpha windowDuration parameter is parsed.")]
		public function testWindowAlphaDuration():void
		{
			parser2.parse(F4M_WITH_ALPHA_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						assertEquals(manifest.dvrInfo.windowDuration, 0);
					}
				);
		}
		
		[Test(description="Tests when no windowDuration parameter is parsed.")]
		public function testWindowNoDuration():void
		{
			parser2.parse(F4M_WITH_NO_WINDOW_DURATION);
			parser.addEventListener
				( ParseEvent.PARSE_COMPLETE 
					, function(event:ParseEvent):void
					{
						var manifest:Manifest = event.data as Manifest;
						assertEquals(manifest.dvrInfo.windowDuration, 0);
						assertEquals(manifest.dvrInfo.id, "myid");

					}
				);
		}
		
		[Test(async, description="Tests if dvrinfo duration is found in dvr trait.")]
		public function testWindowDurationInTraitForV2():void
		{
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_V2_DVR_DURATION_VOD));
			
			var player:MediaPlayer = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			
			function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
			{
				switch (event.state)
				{
					case MediaPlayerState.READY:
					{	
						trace("started");
						assertEquals((mediaElement.getTrait(MediaTraitType.DVR) as DVRTrait).windowDuration, 177);
						player.play();
					}
						break;
					case MediaPlayerState.PLAYING:
						break;
				}
			}
			
			function onMediaError(event:MediaErrorEvent):void
			{
				trace("[Error]", event.toString());	
				fail("Media Error");
			}
		}
		
		[Test(async, description="Tests if dvrinfo duration is found in dvr trait, but ignored since it's f4m v1")]
		public function testWindowDurationInTraitForV1():void
		{
			var mediaFactory:MediaFactory = new DefaultMediaFactory();
			var mediaElement:MediaElement = mediaFactory.createMediaElement(new URLResource(F4M_V1_DVR_DURATION_VOD));
			
			var player:MediaPlayer = new MediaPlayer();
			player.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, onPlayerStateChange);
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaError);
			
			function onPlayerStateChange(event:MediaPlayerStateChangeEvent):void
			{
				switch (event.state)
				{
					case MediaPlayerState.READY:
					{	
						trace("started");
						assertEquals((mediaElement.getTrait(MediaTraitType.DVR) as DVRTrait).windowDuration, 0);
						player.play();
					}
						break;
					case MediaPlayerState.PLAYING:
						break;
				}
			}
			
			function onMediaError(event:MediaErrorEvent):void
			{
				trace("[Error]", event.toString());	
				fail("Media Error");
			}
		}
		
		private static const F4M_V2_DVR_DURATION_VOD:String = "http://catherine.corp.adobe.com/osmf/rolling_window/v2.f4m";
		private static const F4M_V1_DVR_DURATION_VOD:String = "http://catherine.corp.adobe.com/osmf/rolling_window/v1.f4m";

		
		private static const F4M_WITH_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"" + WINDOW_DURATION + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const WINDOW_DURATION:Number = 180;
		
		
		private static const F4M_WITH_NEGATIVE_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"-" + WINDOW_DURATION + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_WITH_NULL_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"" + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_WITH_ZERO_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"" + 0 + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_WITH_FLOAT_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"" + 180.6 + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_WITH_ALPHA_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo windowDuration=\"" + "notanumber" + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_WITH_NO_WINDOW_DURATION:String = 
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<id>1_rps9u31c</id>" +
			"<mimeType>video/x-flv</mimeType>" +
			"<streamType>recorded</streamType>" +
			"<dvrInfo id=\"" + "myid" + "\" />" +
			"<duration>2824</duration>" +
			"<media url=\"http://cdnbakmi.kaltura.com/p/7463/sp/746300/serveFlavor/flavorId/1_69z5anh0/name/1_69z5anh0.flv\"" +
			"bitrate=\"368\" width=\"624\" height=\"352\" />" +
			"</manifest>";
		
		private static const F4M_SOURCE:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/original.f4m";
		private static const MLM_SOURCE:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/mlm.f4m";
		private static const MLM_PATH:String = "http://catherine.corp.adobe.com/osmf/mlm_tests";
		private static const TIMEOUT:Number = 4000;
		
		private var parser:MultiLevelManifestParser;
		private var parser2:MultiLevelManifestParser;

	}
}