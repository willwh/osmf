package org.osmf.net
{
	import __AS3__.vec.Vector;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.net.dynamicstreaming.DynamicStreamingItem;
	import org.osmf.net.dynamicstreaming.DynamicStreamingResource;
	import org.osmf.utils.URL;

	public class TestManifestParser extends TestCase
	{
		
		public function testDefaults():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
							</manifest>;
			
			var manifest:Manifest = ManifestParser.parse(test);
			assertEquals(manifest.id, "myvideo");
			assertEquals(manifest.duration, NaN);
			assertEquals(manifest.media.length, 0);
			assertEquals(manifest.streamType, null);	
			assertEquals(manifest.mimeType, null);					
		}
		
		public function testNoURL():void
		{
			var errorSeen:Boolean = false;
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<startTime>2009-11-29T21:53:12-08:00</startTime>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<deliveryType>streaming</deliveryType>
								<media  bitrate="408" width="640" height="480"/>
								<media url="rtmp://example.com/myvideo/medium" bitrate="908" width="800" height="600"/>
								<media url="rtmp://example.com/myvideo/high" bitrate="1708" width="1920" height="1080"/>
							</manifest>;
			try
			{
				var manifest:Manifest = ManifestParser.parse(test);			
			}
			catch(error:ArgumentError)
			{
				errorSeen = true;
			}
			assertTrue(errorSeen);
		}
		
		public function testNoProfile():void
		{
			var errorSeen:Boolean = false;
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<startTime>2009-11-29T21:53:12-08:00</startTime>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<deliveryType>streaming</deliveryType>
								<bootstrapInfo url="/mybootstrapinfo"/>
								<media url="http://example.com/myvideo/low" bitrate="408" width="640" height="480"/>
								<media url="http://example.com/myvideo/medium" bitrate="908" width="800" height="600"/>
								<media url="http://example.com/myvideo/high" bitrate="1708" width="1920" height="1080"/>
							</manifest>;
			try
			{
				var manifest:Manifest = ManifestParser.parse(test);			
			}
			catch(error:ArgumentError)
			{
				errorSeen = true;
			}
			assertTrue(errorSeen);
			
		}
		
		public function testNoBitrate():void
		{
			var errorSeen:Boolean = false;
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<startTime>2009-11-29T21:53:12-08:00</startTime>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<deliveryType>streaming</deliveryType>
								<media url="rtmp://example.com/myvideo/low"  width="640" height="480"/>
								<media url="rtmp://example.com/myvideo/medium"  width="800" height="600"/>
								<media url="rtmp://example.com/myvideo/high"  width="1920" height="1080"/>
							</manifest>;
			try
			{
				var manifest:Manifest = ManifestParser.parse(test);			
			}
			catch(error:ArgumentError)
			{
				errorSeen = true;
			}
			assertTrue(errorSeen);
		}
						
		public function testTopLevelTags():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<startTime>2009-11-29T21:53:12-08:00</startTime>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<deliveryType>streaming</deliveryType>
								<media url="rtmp://example.com/myvideo/low" bitrate="408" width="640" height="480"/>
								<media url="rtmp://example.com/myvideo/medium" bitrate="908" width="800" height="600"/>
								<media url="rtmp://example.com/myvideo/high" bitrate="1708" width="1920" height="1080"/>
							</manifest>;
			
			var manifest:Manifest = ManifestParser.parse(test);
			assertEquals(manifest.id, "myvideo");
			assertEquals(manifest.duration, 253);
			assertEquals(manifest.mimeType, "video/x-flv");		
			assertEquals(manifest.media.length, 3);
			assertEquals(manifest.streamType, "recorded");
			assertEquals(manifest.deliveryType, "streaming");
			assertEquals(1259560392000, manifest.startTime.time);
							
		}
		
		public function testMediaParser():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<bootstrapInfo profile="named" >U2FtcGxlIEJvb3RzdHJhcCAx</bootstrapInfo>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<media url="http://example.com/myvideo/low" bitrate="408" width="640" height="480"/>
								<media url="http://example.com/myvideo/medium" bitrate="908" width="800" height="600"/>
								<media url="http://example.com/myvideo/high" bitrate="1708" width="1920" height="1080"/>
							</manifest>
			
			var manifest:Manifest = ManifestParser.parse(test);
			
			assertEquals(3, manifest.media.length);
			assertEquals("http://example.com/myvideo/low", Media(manifest.media[0]).url);
			assertEquals("http://example.com/myvideo/medium", Media(manifest.media[1]).url);
			assertEquals("http://example.com/myvideo/high", Media(manifest.media[2]).url);
			
			assertEquals("Some Sample Data", Media(manifest.media[0]).drmMetadata);
			assertEquals("Some Sample Data", Media(manifest.media[1]).drmMetadata);
			assertEquals("Some Sample Data", Media(manifest.media[2]).drmMetadata);
			
			assertEquals("Sample Bootstrap 1", Media(manifest.media[0]).bootstrapInfo);
			assertEquals("Sample Bootstrap 1", Media(manifest.media[1]).bootstrapInfo);
			assertEquals("Sample Bootstrap 1", Media(manifest.media[2]).bootstrapInfo);
			
			assertEquals("named", Media(manifest.media[0]).bootstrapProfile);
			assertEquals("named", Media(manifest.media[1]).bootstrapProfile);
			assertEquals("named", Media(manifest.media[2]).bootstrapProfile);
			
			assertEquals(480, Media(manifest.media[0]).height);
			assertEquals(600, Media(manifest.media[1]).height);
			assertEquals(1080, Media(manifest.media[2]).height);
			
			assertEquals(640, Media(manifest.media[0]).width);
			assertEquals(800, Media(manifest.media[1]).width);
			assertEquals(1920, Media(manifest.media[2]).width);
			
			assertEquals(408, Media(manifest.media[0]).bitrate);
			assertEquals(908, Media(manifest.media[1]).bitrate);
			assertEquals(1708, Media(manifest.media[2]).bitrate);
		}
		
		public function testResourceCreation():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<media url="http://example.com/myvideo/low.mp4" bitrate="408" width="640" height="480"/>
							</manifest>
			var manifest:Manifest = ManifestParser.parse(test);
			var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			
			assertTrue(resource is URLResource)
			assertEquals("http://example.com/myvideo/low.mp4", URLResource(resource).url.rawUrl)
			
			var facet:KeyValueFacet = URLResource(resource).metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet ;
			assertNotNull(facet);
			
			assertEquals("Some Sample Data", facet.getValue(new ObjectIdentifier(MetadataNamespaces.DRM_CONTENT_METADATA_KEY)));
					
		}
		
		public function testDynamicResourceCreation():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<media url="rtmp://example.com/myvideo/low" bitrate="408" width="640" height="480"/>
								<media url="rtmp://example.com/myvideo/medium" bitrate="908" width="800" height="600"/>
								<media url="rtmp://example.com/myvideo/high" bitrate="1708" width="1920" height="1080"/>
							</manifest>
							
			var manifest:Manifest = ManifestParser.parse(test);
			var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			
			assertTrue(resource is DynamicStreamingResource);
			assertEquals("low", DynamicStreamingItem(DynamicStreamingResource(resource).streamItems[0]).streamName);
			assertEquals("medium", DynamicStreamingItem(DynamicStreamingResource(resource).streamItems[1]).streamName);
			assertEquals("high", DynamicStreamingItem(DynamicStreamingResource(resource).streamItems[2]).streamName);
			
			
			var facet:KeyValueFacet = DynamicStreamingResource(resource).metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet ;
			assertNotNull(facet);
			var keys:Vector.<ObjectIdentifier> = facet.keys;
			assertEquals(3, keys.length);
			
			assertEquals("Some Sample Data", facet.getValue(keys[0]));
			assertEquals("Some Sample Data", facet.getValue(keys[1]));
			assertEquals("Some Sample Data", facet.getValue(keys[2]));					
		}
		
		public function testDynamicResourceIDMatchingCreation():void
		{
			//Some Sample Data == U29tZSBTYW1wbGUgRGF0YQ==
			//Some Sample Data 2 == U29tZSBTYW1wbGUgRGF0YSAy
			//Some Sample Data 3 == U29tZSBTYW1wbGUgRGF0YSAz
			
			//Sample Bootstrap 1 == U2FtcGxlIEJvb3RzdHJhcCAx
			//Sample Bootstrap 2 == U2FtcGxlIEJvb3RzdHJhcCAy
			//Sample Bootstrap 3 == U2FtcGxlIEJvb3RzdHJhcCAz
			
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
								<id>myvideo</id>
								<duration>253</duration>
								<mimeType>video/x-flv</mimeType>
								<streamType>recorded</streamType>
								<drmMetadata id='1'>U29tZSBTYW1wbGUgRGF0YQ==</drmMetadata>
								<drmMetadata id='2'>U29tZSBTYW1wbGUgRGF0YSAy</drmMetadata>
								<drmMetadata id='3'>U29tZSBTYW1wbGUgRGF0YSAz</drmMetadata>
								<bootstrapInfo profile="named" id='1'>U2FtcGxlIEJvb3RzdHJhcCAx==</bootstrapInfo>
								<bootstrapInfo profile="named" id='2'>U2FtcGxlIEJvb3RzdHJhcCAy==</bootstrapInfo>
								<bootstrapInfo profile="named" id='3'>U2FtcGxlIEJvb3RzdHJhcCAz==</bootstrapInfo>
								<media url="rtmp://example.com/myvideo/low"  bitrate="408" width="640" height="480" drmMetadataId='1'/>
								<media url="rtmp://example.com/myvideo/medium" bitrate="908" width="800" height="600" drmMetadataId='2'/>
								<media url="rtmp://example.com/myvideo/high" bitrate="1708" width="1920" height="1080" drmMetadataId='3'/>
							</manifest>
							
			var manifest:Manifest = ManifestParser.parse(test);
			var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			
			assertTrue(resource is DynamicStreamingResource);
								
			var facet:KeyValueFacet = DynamicStreamingResource(resource).metadata.getFacet(MetadataNamespaces.DRM_METADATA) as KeyValueFacet ;
			assertNotNull(facet);
			var keys:Vector.<ObjectIdentifier> = facet.keys;
			assertEquals(3, keys.length);
			
			var drmForKey:Object = {medium:'Some Sample Data 2',
									low:'Some Sample Data',
									high:'Some Sample Data 3'
			};
			
			assertEquals(drmForKey[keys[0].key.streamName], facet.getValue(keys[0]));
			assertEquals(drmForKey[keys[1].key.streamName], facet.getValue(keys[1]));
			assertEquals(drmForKey[keys[2].key.streamName], facet.getValue(keys[2]));					
		}
		
		public function testBaseURL():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
							<id>myvideo</id>
							<duration>253</duration>
							<mimeType>video/x-flv</mimeType>
							<streamType>recorded</streamType>
							<baseURL>rtmp://newbase.com/myserver</baseURL>
							<media url="rtmp://example.com/myvideo/low"  bitrate="408" width="640" height="480" />
							<media url="rtmp://example.com/myvideo/medium" bitrate="908" width="800" height="600" />
							<media url="rtmp://example.com/myvideo/high" bitrate="1708" width="1920" height="1080" />
						</manifest>
							
			var manifest:Manifest = ManifestParser.parse(test);
			var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			
			var dynResource:DynamicStreamingResource = resource as DynamicStreamingResource;
			
			assertEquals(dynResource.streamItems.length, 3);
			
			assertEquals(dynResource.host.rawUrl, "rtmp://newbase.com/myserver");
			
			assertEquals(dynResource.streamItems[0].streamName, "low");
			assertEquals(dynResource.streamItems[1].streamName, "medium");
			assertEquals(dynResource.streamItems[2].streamName, "high");			
		}
		
		public function testRelativeURL():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
							<id>myvideo</id>
							<duration>253</duration>
							<mimeType>video/x-flv</mimeType>
							<streamType>recorded</streamType>
							<media url="myvideo/low.flv"  bitrate="408" width="640" height="480" />
						</manifest>
							
			var manifest:Manifest = ManifestParser.parse(test);
			var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			
			assertTrue(resource is URLResource);
			
			var urlResource:URLResource = resource as URLResource;
				
			assertEquals(urlResource.url.rawUrl, "http://example.com/myvideo/low.flv");
						
		}
		
		public function testNoURLDynStreaming():void
		{
			var test:XML = <manifest xmlns="http://ns.adobe.com/f4m/1.0">
							<id>myvideo</id>
							<duration>253</duration>
							<mimeType>video/x-flv</mimeType>
							<streamType>recorded</streamType>
							<media url="low.flv"  bitrate="408" width="640" height="480" />
							<media url="medium.flv" bitrate="908" width="800" height="600" />
							<media url="high.flv" bitrate="1708" width="1920" height="1080" />
						</manifest>
							
			var manifest:Manifest = ManifestParser.parse(test);
			var errorSeen:Boolean = false;
			try
			{
				var resource:IMediaResource = ManifestParser.createResource(manifest, new URL('http://example.com/manifest.f4m'));
			}
			catch(error:Error)
			{
				errorSeen = true;
			}			
			assertTrue(errorSeen);
			
		}
			
	}
}