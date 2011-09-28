package org.osmf.elements.f4mClasses
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.osmf.elements.f4mClasses.MultiLevelManifestParser;
	import org.osmf.events.ParseEvent;
	import org.osmf.net.StreamType;
	
	public class TestMultiLevelManifestParser
	{
		[Before]
		public function setUp():void
		{
			parser = new MultiLevelManifestParser();
		}
		
		[After]
		public function tearDown():void
		{
			parser = null;
		}
		
		[Test(async, description="Tests backwards compatibility with a 1.0 F4M.")]
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
			parser.parse(resourceData);	
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
			
			manifest.media.sort(compareMediasByBitrate);
			Assert.assertEquals(Media(manifest.media[0]).bitrate, 1000);
			Assert.assertEquals(Media(manifest.media[1]).bitrate, 1400);
		}
		
		private function handleTimeout( passThroughData:Object ):void {
			Assert.fail( "Timeout reached before event." );
		}
		
		private function compareMediasByBitrate(a:Media, b:Media):Number
		{
			return a.bitrate - b.bitrate;
		}
		
		private static const F4M_SOURCE:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/original.f4m";
		private static const MLM_SOURCE:String = "http://catherine.corp.adobe.com/osmf/mlm_tests/mlm.f4m";
		private static const TIMEOUT:Number = 1000;
		
		private var parser:MultiLevelManifestParser;
	}
}