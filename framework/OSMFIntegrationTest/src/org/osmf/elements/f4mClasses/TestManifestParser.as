package org.osmf.elements.f4mClasses
{
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.osmf.elements.f4mClasses.Manifest;
	import org.osmf.elements.f4mClasses.ManifestParser;
	import org.osmf.events.ParseEvent;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.net.StreamingXMLResource;
	
	public class TestManifestParser
	{
		[Before]
		public function setUp():void
		{
			xmlResource = new StreamingXMLResource(F4M_CONTENT);
			parser = new ManifestParser();
		}
		
		[After]
		public function tearDown():void
		{
			parser = null;
			xmlResource = null;
		}
		
		[Test(async, description="Tests the creation of a DynamicStreamingResource.")]
		public function testCreateDynamicStreamingResource():void
		{
			Async.handleEvent(this, parser, ParseEvent.PARSE_COMPLETE, onParseComplete, TIMEOUT, this);
			Async.failOnEvent(this, parser, ParseEvent.PARSE_ERROR);
			
			parser.parse(xmlResource.manifest);
			
			function onParseComplete(event:ParseEvent, test:*):void
			{
				var manifest:Manifest = event.data as Manifest;
				var resource:DynamicStreamingResource = parser.createResource(manifest, xmlResource) as DynamicStreamingResource;
				
				assertTrue(resource.urlIncludesFMSApplicationInstance);
				assertEquals(resource.streamItems.length, 5);
			}
		}
		
		private var parser:ManifestParser;
		private var xmlResource:StreamingXMLResource;
		
		private static const F4M_CONTENT:String = 
			"<manifest xmlns=\"http://ns.adobe.com/f4m/1.0\">" +
			"<baseURL>rtmp://llnwqa.fcod.llnwd.net/a1218/o18/</baseURL>" + 
			"<urlIncludesFMSApplicationInstance>true</urlIncludesFMSApplicationInstance>" + 
			"<media url=\"mp4:lexsamplecontent/king_500.f4v\" bitrate=\"500\" width=\"480\" height=\"270\" />" + 
			"<media url=\"mp4:lexsamplecontent/king_800.f4v\" bitrate=\"800\" width=\"480\" height=\"270\" />" +
			"<media url=\"mp4:lexsamplecontent/king_1200.f4v\" bitrate=\"1200\" width=\"640\" height=\"360\" />" +
			"<media url=\"mp4:lexsamplecontent/king_1500.f4v\" bitrate=\"1500\" width=\"640\" height=\"360\"/>" +
			"<media url=\"mp4:lexsamplecontent/king_2400.f4v\" bitrate=\"2400\" width=\"640\" height=\"360\"/>" +
			"</manifest>";
		
		private static const TIMEOUT:Number = 1000;
	}
}