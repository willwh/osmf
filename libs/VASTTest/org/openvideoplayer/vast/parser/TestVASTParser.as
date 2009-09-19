/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.openvideoplayer.vast.parser
{
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.vast.model.VASTAd;
	import org.openvideoplayer.vast.model.VASTDocument;
		
	public class TestVASTParser extends TestCase
	{
		override public function setUp():void
		{
			super.setUp();
			
			parser = new VASTParser();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			parser = null;
		}
		
		//---------------------------------------------------------------------
		
		// Success cases
		//

		public function testParseInvalidDocuments():void
		{
			assertTrue(parser.parse(new XML()) == null);
			assertTrue(parser.parse(<foo/>) == null);
			
			try
			{
				parser.parse(null);
				
				fail();
			}
			catch (error:ArgumentError)
			{
				// Swallow.
			}
		}
		
		public function testParseInlineAd():void
		{
			var document:VASTDocument = parser.parse(INLINE_VAST_DOCUMENT);
			assertTrue(document != null);
			assertTrue(document.ads.length == 1);
			var vastAd:VASTAd = document.ads[0];
			assertTrue(vastAd != null);
			assertTrue(vastAd.id == "myinlinead");
			assertTrue(vastAd.inlineAd != null);
			assertTrue(vastAd.wrapperAd == null);
			
			assertTrue(vastAd.inlineAd.adSystem == "DART");
			assertTrue(vastAd.inlineAd.adTitle == "Spiderman 3 Trailer");
			assertTrue(vastAd.inlineAd.description == "Spiderman video trailer");
			assertTrue(vastAd.inlineAd.errorURL == "http://www.primarysite.com/tracker?noPlay=true&impressionTracked=false");
			assertTrue(vastAd.inlineAd.surveyURL == "http://www.dynamiclogic.com/tracker?campaignId=234&site=yahoo");
		}

		public function testParseWrapperAd():void
		{
			var document:VASTDocument = parser.parse(WRAPPER_VAST_DOCUMENT);
			assertTrue(document != null);
			assertTrue(document.ads.length == 1);
			var vastAd:VASTAd = document.ads[0];
			assertTrue(vastAd != null);
			assertTrue(vastAd.id == "mywrapperad");
			assertTrue(vastAd.inlineAd == null);
			assertTrue(vastAd.wrapperAd != null);
			
			assertTrue(vastAd.wrapperAd.vastAdTagURL == "http://www.secondaryadserver.com/ad/tag/parameters?time=1234567");
		}
		
		private var parser:VASTParser;
		
		public static const INLINE_VAST_DOCUMENT:XML =
			<VideoAdServingTemplate xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="vast.xsd">
				<Ad id="myinlinead">
					<InLine>
						<AdSystem>DART</AdSystem>
						<AdTitle>Spiderman 3 Trailer</AdTitle>
						<Description>Spiderman video trailer</Description>
						<Survey>
							<URL><![CDATA[ http://www.dynamiclogic.com/tracker?campaignId=234&site=yahoo]]></URL>
						</Survey>
						<Error>
							<URL><![CDATA[http://www.primarysite.com/tracker?noPlay=true&impressionTracked=false]]></URL>
						</Error>
						<Impression>
							<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?imp]]></URL>
							<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?imp]]></URL>
						</Impression>
						<TrackingEvents>
							<Tracking event="start">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?start]]></URL>
							</Tracking>
							<Tracking event="midpoint">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?mid]]></URL>
								<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?mid]]></URL>
							</Tracking>
							<Tracking event="firstQuartile">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?fqtl]]></URL>
								<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?fqtl]]></URL>
							</Tracking>
							<Tracking event="thirdQuartile">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?tqtl]]></URL>
								<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?tqtl]]></URL>
							</Tracking>
							<Tracking event="complete">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?comp]]></URL>
								<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?comp]]></URL>
							</Tracking>
							<Tracking event="mute">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?mute]]></URL>
							</Tracking>
							<Tracking event="pause">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?pause]]></URL>
							</Tracking>
							<Tracking event="replay">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?replay]]></URL>
							</Tracking>
							<Tracking event="fullscreen">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?full]]></URL>
							</Tracking>
							<Tracking event="stop">
								<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?stop]]></URL>
							</Tracking>
						</TrackingEvents>
						<Video>
							<Duration>00:00:15</Duration>
							<AdID>AdID</AdID>
							<VideoClicks>
								<ClickThrough>
									<URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?click]]></URL>
								</ClickThrough>
								<ClickTracking>
									<URL id="anotheradsever"><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
									<URL id="athirdadsever"><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
								</ClickTracking>
								<CustomClick>
									<URL id="redclick"><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
									<URL id="blueclick"><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
								</CustomClick>
							</VideoClicks>
							<MediaFiles>
								<MediaFile delivery="streaming" bitrate="250" width="200" height="200" type="video/x-flv">
									<URL><![CDATA[rtmp://streamingserver/streamingpath/medium/filename.flv]]></URL>
								</MediaFile>
								<MediaFile delivery="streaming" bitrate="75" width="200" height="200" type="video/x-flv">
									<URL><![CDATA[rtmp://streamingserver/streamingpath/low/filename.flv]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="400" width="200" height="200" type="video/x-flv">
									<URL><![CDATA[http://progressive.hostlocation.com//high/filename.flv]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="200" width="200" height="200" type="video/x-flv">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/medium/filename.flv]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="75" width="200" height="200" type="video/x-flv">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/low/filename.flv]]></URL>
								</MediaFile>
								<MediaFile delivery="streaming" bitrate="400" width="200" height="200" type="video/x-ms-wmv">
									<URL><![CDATA[mms://streaming.hostlocaltion.com/ondemand/streamingpath/high/filename.wmv]]></URL>
			            </MediaFile>
			            <MediaFile delivery="streaming" bitrate="200" width="200" height="200" type="video/x-ms-wmv">
			                <URL><![CDATA[mms://streaming.hostlocaltion.com/ondemand/streamingpath/medium/filename.wmv]]></URL>
			            </MediaFile>
			            <MediaFile delivery="streaming" bitrate="75" width="200" height="200" type="video/x-ms-wmv">
			                <URL><![CDATA[mms://streaming.hostlocaltion.com/ondemand/streamingpath/low/filename.wmv]]></URL>
			            </MediaFile>
			            <MediaFile delivery="progressive" bitrate="400" width="200" height="200" type="video/x-ms-wmv">
			                <URL><![CDATA[http://progressive.hostlocation.com//high/filename.wmv]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="200" width="200" height="200" type="video/x-ms-wmv">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/medium/filename.wmv]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="75" width="200" height="200" type="video/x-ms-wmv">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/low/filename.wmv]]></URL>
								</MediaFile>
								<MediaFile delivery="streaming" bitrate="200" width="200" height="200" type="video/x-ra">
									<URL><![CDATA[rtsp://streaming.hostlocaltion.com/ondemand/streamingpath/medium/filename.ra]]></URL>
			            </MediaFile>
			            <MediaFile delivery="streaming" bitrate="75" width="200" height="200" type="video/x-ra">
			                <URL><![CDATA[rtsp://streaming.hostlocaltion.com/ondemand/streamingpath/low/filename.ra]]></URL>
			            </MediaFile>
			            <MediaFile delivery="progressive" bitrate="400" width="200" height="200" type="video/x-ra">
			                <URL><![CDATA[http://progressive.hostlocation.com//high/filename.ra]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="200" width="200" height="200" type="video/x-ra">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/medium/filename.ra]]></URL>
								</MediaFile>
								<MediaFile delivery="progressive" bitrate="75" width="200" height="200" type="video/x-ra">
									<URL><![CDATA[http://progressive.hostlocation.com/progressivepath/low/filename.ra]]></URL>
								</MediaFile>
							</MediaFiles>
						</Video>
						<CompanionAds>
							<Companion id="rich media banner" width="468" height="60" resourceType="iframe" creativeType="any">
								<URL><![CDATA[http://ad.server.com/adi/etc.html]]></URL>
							</Companion>
							<Companion id="banner" width="728" height="90" resourceType="script" creativeType="any">
								<URL><![CDATA[http://ad.server.com/adj/etc.js]]></URL>
							</Companion>
							<Companion id="banner" width="468" height="60" resourceType="static" creativeType="JPEG">
								<URL><![CDATA[http://media.doubleclick.net/foo.jpg]]></URL>
								<CompanionClickThrough>
									<URL><![CDATA[http://www.primarysite.com/tracker?click]]></URL>
								</CompanionClickThrough>
							</Companion>
						</CompanionAds>
						<NonLinearAds>
							<NonLinear id="overlay" width="150" height="60" resourceType="static" creativeType="SWF" apiFramework="IAB">
								<URL><![CDATA[http://ad.server.com/adx/etc.xml]]></URL>
								<NonLinearClickThrough>
									<URL><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
								</NonLinearClickThrough>
							</NonLinear>
							<NonLinear id="bumper" width="250" height="300" resourceType="static" creativeType="JPEG">
								<URL><![CDATA[http://ad.doubleclick.net/adx/etc.jpg]]></URL>
								<NonLinearClickThrough>
									<URL><![CDATA[http://www.thirdparty.com/tracker?click]]></URL>
								</NonLinearClickThrough>
							</NonLinear>
						</NonLinearAds>
						<Extensions>
							<Extension type="adServer">
								<TemplateVersion>3.002</TemplateVersion>
								<AdServingData>
									<DeliveryData>
										<GeoData><![CDATA[ct=US&st=VA&ac=703&zp=20151&bw=4&dma=13&city=15719]]></GeoData>
										<MyAdId>43534850</MyAdId>
									</DeliveryData>
								</AdServingData>
							</Extension>
						</Extensions>
					</InLine>
				</Ad>
			</VideoAdServingTemplate>;
			
		public static const WRAPPER_VAST_DOCUMENT:XML =
			<VideoAdServingTemplate xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="vast.xsd">
			  <Ad id="mywrapperad">
			   <Wrapper>
			    <AdSystem>MyAdSystem</AdSystem>
			    <VASTAdTagURL>
			        <URL><![CDATA[http://www.secondaryadserver.com/ad/tag/parameters?time=1234567]]></URL>
			    </VASTAdTagURL>
			    <Error>
			        <URL><![CDATA[http://www.primarysite.com/tracker?noPlay=true&impressionTracked=false]]></URL>
			    </Error>
			    <Impression>
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?imp]]></URL>
			    </Impression>
			    <TrackingEvents>
			        <Tracking event="midpoint">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?mid]]></URL>
			        </Tracking>
			        <Tracking event="firstQuartile">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?fqtl]]></URL>
			        </Tracking>
			        <Tracking event="thirdQuartile">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?tqtl]]></URL>
			        </Tracking>
			        <Tracking event="complete">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?comp]]></URL>
			        </Tracking>
			        <Tracking event="mute">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?mute]]></URL>
			        </Tracking>
			        <Tracking event="pause">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?pause]]></URL>
			        </Tracking>
			        <Tracking event="replay">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?replay]]></URL>
			        </Tracking>
			        <Tracking event="fullscreen">
			            <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?full]]></URL>
			        </Tracking>
			     </TrackingEvents>
			        <VideoClicks>
			            <ClickTracking>
							 <URL id="myadsever"><![CDATA[http://www.primarysite.com/tracker?click]]></URL>
			            </ClickTracking>
			        </VideoClicks>
			   </Wrapper>
			  </Ad>
			</VideoAdServingTemplate>;
	}
}