package org.osmf.metadata
{
	import __AS3__.vec.Vector;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.URLResource;
	import org.osmf.utils.MediaFrameworkStrings;
	import org.osmf.utils.URL;

	public class TestMetadataUtils extends TestCase
	{
		public function testMatch():void
		{
			var supportedMedia:Vector.<String> = new Vector.<String>;
			supportedMedia.push(MediaType.AUDIO);
			var supportedMime:Vector.<String> = new Vector.<String>;
			supportedMime.push("audio/mp3");	
			supportedMime.push("audio/mpeg");
			
			assertEquals(MetadataUtils.METADATA_MATCH_FOUND, MetadataUtils.checkMetadataMatch(MediaType.AUDIO, "audio/mp3", supportedMedia, supportedMime));
			assertEquals(MetadataUtils.METADATA_MATCH_UNKNOWN, MetadataUtils.checkMetadataMatch(null, null, supportedMedia, supportedMime));		
			assertEquals(MetadataUtils.METADATA_CONFLICTS_FOUND, MetadataUtils.checkMetadataMatch(MediaType.VIDEO, null, supportedMedia, supportedMime));
			assertEquals(MetadataUtils.METADATA_CONFLICTS_FOUND, MetadataUtils.checkMetadataMatch(MediaType.AUDIO, "video/x-flv", supportedMedia, supportedMime));
			assertEquals(MetadataUtils.METADATA_MATCH_FOUND, MetadataUtils.checkMetadataMatch(MediaType.AUDIO, null, supportedMedia, supportedMime));
			assertEquals(MetadataUtils.METADATA_MATCH_FOUND, MetadataUtils.checkMetadataMatch(null, "audio/mpeg", supportedMedia, supportedMime));						
		}
		
		private function testResourceWithData(expectedResult:int, mediaType:String, mimeType:String, supportedMedia:Vector.<String>, supportedMime:Vector.<String>):void
		{
			var resource:URLResource = new URLResource(new URL("test"));
			resource.metadata.addFacet(new MediaTypeFacet(mediaType, mimeType));
			assertEquals(expectedResult, MetadataUtils.checkMetadataMatchWithResource(resource, supportedMedia, supportedMime));
		}
		
		public function testResourceMatch():void
		{
			var supportedMedia:Vector.<String> = new Vector.<String>;
			supportedMedia.push(MediaType.AUDIO);
			var supportedMime:Vector.<String> = new Vector.<String>;
			supportedMime.push("audio/mp3");	
			supportedMime.push("audio/mpeg");
								
			assertEquals(testResourceWithData(MetadataUtils.METADATA_MATCH_FOUND,MediaType.AUDIO, "audio/mp3", supportedMedia, supportedMime));			
			assertEquals(testResourceWithData(MetadataUtils.METADATA_MATCH_UNKNOWN, null, null, supportedMedia, supportedMime));					
			assertEquals(testResourceWithData(MetadataUtils.METADATA_CONFLICTS_FOUND, MediaType.VIDEO, null, supportedMedia, supportedMime));			
			assertEquals(testResourceWithData(MetadataUtils.METADATA_CONFLICTS_FOUND, MediaType.AUDIO, "video/x-flv", supportedMedia, supportedMime));			
			assertEquals(testResourceWithData(MetadataUtils.METADATA_MATCH_FOUND, MediaType.AUDIO, null, supportedMedia, supportedMime));			
			assertEquals(testResourceWithData(MetadataUtils.METADATA_MATCH_FOUND, null, "audio/mpeg", supportedMedia, supportedMime));						
		}
		
		public function testWatchFacet():void
		{
			var callbackArgument:IFacet = null;
			var callbackCount:int = 0;
			function facetChangeCallback(facet:IFacet):void
			{
				callbackArgument = facet;
				callbackCount++;
			}
			
			var facet1NS:URL = new URL("http://www.facet1NS.com");
			var facet2NS:URL = new URL("http://www.facet2NS.com");
			var metaData:Metadata = new Metadata();
			var watcher:MetadataWatcher = MetadataUtils.watchFacet(metaData, facet1NS, facetChangeCallback);
			
			assertEquals(1,callbackCount);
			assertNull(callbackArgument);
			
			var facet1:KeyValueFacet = new KeyValueFacet(facet1NS);
			metaData.addFacet(facet1);
			
			assertEquals(2, callbackCount);
			assertEquals(callbackArgument, facet1);
			
			metaData.removeFacet(facet1);
			
			assertEquals(3, callbackCount);
			assertNull(callbackArgument);
			
			var facet2:KeyValueFacet = new KeyValueFacet(facet2NS);
			metaData.addFacet(facet2);
			
			assertEquals(3, callbackCount);
			assertNull(callbackArgument);
			
			metaData.addFacet(facet1);
			
			assertEquals(4, callbackCount);
			assertEquals(callbackArgument, facet1);
			
			facet1.addValue(new ObjectIdentifier("myKey"),"someValue");
			
			assertEquals(5, callbackCount);
			assertEquals(callbackArgument, facet1);
		}
		
		public function testWatchFacetValue():void
		{
			var callbackArgument:* = null;
			var callbackCount:int = 0;
			function facetValueChangeCallback(value:*):void
			{
				callbackArgument = value;
				callbackCount++;
			}
			
			var facet1NS:URL = new URL("http://www.facet1NS.com");
			var facet2NS:URL = new URL("http://www.facet2NS.com");
			var metaData:Metadata = new Metadata();
			var watcher:MetadataWatcher
				= MetadataUtils.watchFacetValue
					( metaData
					, facet1NS
					, new ObjectIdentifier("myKey")
					, facetValueChangeCallback
					);
			
			assertEquals(1,callbackCount);
			assertNull(callbackArgument);
			
			var facet1:KeyValueFacet = new KeyValueFacet(facet1NS);
			metaData.addFacet(facet1);
			
			assertEquals(2, callbackCount);
			
			metaData.removeFacet(facet1);
			
			assertEquals(3, callbackCount);
			
			var facet2:KeyValueFacet = new KeyValueFacet(facet2NS);
			metaData.addFacet(facet2);
			
			assertEquals(3, callbackCount);
			
			metaData.addFacet(facet1);
			
			assertEquals(4, callbackCount);
			
			facet1.addValue(new ObjectIdentifier("myKey"),"someValue");
			
			assertEquals(5, callbackCount);
			assertEquals(callbackArgument, "someValue");
			
			facet1.addValue(new ObjectIdentifier("myKey"),23);
			
			assertEquals(6, callbackCount);
			assertEquals(callbackArgument,23);
			
			facet1.removeValue(new ObjectIdentifier("myKey"));
			
			assertEquals(7, callbackCount);
			assertNull(callbackArgument);
		}
	}
}