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
package org.osmf
{
	import flexunit.framework.TestSuite;
	
	import org.osmf.audio.*;
	import org.osmf.composition.*;
	import org.osmf.containers.*;
	import org.osmf.display.*;
	import org.osmf.events.*;
	import org.osmf.external.*;
	import org.osmf.image.*;
	import org.osmf.layout.*;
	import org.osmf.logging.*;
	import org.osmf.manifest.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.net.*;
	import org.osmf.net.dynamicstreaming.*;
	import org.osmf.net.httpstreaming.f4f.*;
	import org.osmf.net.httpstreaming.flv.*;
	import org.osmf.plugin.*;
	import org.osmf.proxies.*;
	import org.osmf.swf.*;
	import org.osmf.tracking.*;
	import org.osmf.traits.*;
	import org.osmf.utils.*;
	import org.osmf.vast.*;
	import org.osmf.vast.loader.*;
	import org.osmf.vast.media.*;
	import org.osmf.vast.parser.*;
	import org.osmf.video.*;

	public class OSMFTests extends TestSuite
	{
		public function OSMFTests(param:Object=null)
		{
			super(param);
			
			// change to true to run all tests against the network.
			NetFactory.neverUseMockObjects = false;
			
			// Layout
			//
			
			addTestSuite(TestTraitEventDispatcher);
			
			/*
				
			addTestSuite(TestAbsoluteLayoutFacet);
			addTestSuite(TestAnchorLayoutFacet);
			addTestSuite(TestLayoutRenderer);
			addTestSuite(TestDefaultLayoutRenderer);
			addTestSuite(TestLayoutAttributesFacet);
			addTestSuite(TestMediaElementLayoutTarget);
			addTestSuite(TestPaddingLayoutFacet);
			addTestSuite(TestRegistrationPoint);
			addTestSuite(TestRelativeLayoutFacet);
			addTestSuite(TestLayoutProperties);
			
			// Containers
			//
			
			addTestSuite(TestMediaContainer);
			addTestSuite(TestMediaContainerGroup);
			addTestSuite(TestHTMLMediaContainer);
			addTestSuite(TestMediaPlayerSprite);
			
			// Composition
			//
			
			addTestSuite(TestTraitAggregator);
			addTestSuite(TestTraitLoader);

			addTestSuite(TestCompositeElement);
			addTestSuite(TestParallelElement);
			addTestSuite(TestSerialElement);

			addTestSuite(TestParallelElementWithAudioTrait);
			addTestSuite(TestParallelElementWithBufferTrait);
			addTestSuite(TestParallelElementDRMTrait); 
			addTestSuite(TestParallelElementWithDynamicStreamTrait);
			addTestSuite(TestParallelElementWithLoadTrait);
			addTestSuite(TestParallelElementWithPlayTrait);
			addTestSuite(TestParallelElementWithSeekTrait);
			addTestSuite(TestParallelElementWithTimeTrait);
			addTestSuite(TestParallelElementWithDisplayObjectTrait);
			
			addTestSuite(TestSerialElementWithAudioTrait);
			addTestSuite(TestSerialElementWithBufferTrait);
			addTestSuite(TestSerialElementDRMTrait);
			addTestSuite(TestSerialElementWithDynamicStreamTrait);
			addTestSuite(TestSerialElementWithLoadTrait);
			addTestSuite(TestSerialElementWithPlayTrait);
			addTestSuite(TestSerialElementWithSeekTrait);
			addTestSuite(TestSerialElementWithTimeTrait);
			addTestSuite(TestSerialElementWithDisplayObjectTrait);
			
			addTestSuite(TestCompositeAudioTrait);
			
			// Utils
			//
			addTestSuite(TestBinarySearch);
			addTestSuite(TestOSMFStrings);
			addTestSuite(TestVersion);		
			addTestSuite(TestURL);
			addTestSuite(TestFMSURL);
			addTestSuite(TestHTTPLoader);
			addTestSuite(TestTimeUtil);

			// Logging
			//
			
			addTestSuite(TestLog);
			addTestSuite(TestTraceLogger);
			addTestSuite(TestTraceLoggerFactory);

			// Traits
			//
			
			addTestSuite(TestAudioTrait);
			addTestSuite(TestBufferTrait);
			addTestSuite(TestBufferTraitAsSubclass);
			addTestSuite(TestDRMTrait);
			addTestSuite(TestDynamicStreamTrait);
			addTestSuite(TestLoadTrait);
			addTestSuite(TestLoaderBaseAsSubclass);
			addTestSuite(TestLoadTraitAsSubclass);
			addTestSuite(TestPlayTrait);
			addTestSuite(TestPlayTraitAsSubclass);
			addTestSuite(TestSeekTrait);
			addTestSuite(TestSeekTraitAsSubclass);
			addTestSuite(TestTimeTrait);
			addTestSuite(TestTimeTraitAsSubclass);
			addTestSuite(TestDisplayObjectTrait);
			addTestSuite(TestDisplayObjectTraitAsSubclass);

			// Events
			//
			
			addTestSuite(TestMediaError);
			addTestSuite(TestMediaErrorAsSubclass);
			
			// Core Media
			//
			
			addTestSuite(TestURLResource);
			addTestSuite(TestMediaElement);
			addTestSuite(TestMediaElementAsSubclass);
			addTestSuite(TestLoadableElementBase);
			addTestSuite(TestMediaTraitResolver);
			addTestSuite(TestDefaultTraitResolver);
			addTestSuite(TestMediaFactoryItem);
			addTestSuite(TestMediaFactory);
			
			// Video
			//
			
			addTestSuite(TestVideoElement);
			addTestSuite(TestCuePoint);
			
			// Audio
			//
			
			addTestSuite(TestAudioElement);
			addTestSuite(TestAudioElementWithSoundLoader);
			addTestSuite(TestSoundLoader);
			
			addTestSuite(TestAudioAudioTrait);
			addTestSuite(TestAudioSeekTrait); 
			addTestSuite(TestSoundLoadTrait);

			// These tests fail intermittently on the build machine.
			//addTestSuite(TestAudioPlayTrait);
			//addTestSuite(TestAudioTimeTrait);
			
			// External
			//
			
			addTestSuite(TestHTMLElement);
			addTestSuite(TestHTMLPlayTrait);
			addTestSuite(TestHTMLLoadTrait);
			addTestSuite(TestHTMLTimeTrait);
			addTestSuite(TestHTMLAudioTrait);
			
			// MediaPlayer
			//
			
			addTestSuite(TestMediaPlayer);
			
			// This test fails intermittently on the build machine.
			//addTestSuite(TestMediaPlayerWithAudioElementWithSoundLoader);

			// Metadata
			//

			addTestSuite(TestMetadata);
			addTestSuite(TestObjectIdentifier);
			addTestSuite(TestMediaType);
			addTestSuite(TestKeyValueFacet);
			addTestSuite(TestFacetGroup);
			addTestSuite(TestMetadataUtils);
			addTestSuite(TestCompositeMetadata);
			addTestSuite(TestTemporalFacet);

			// NetStream
			//
			
			addTestSuite(TestNetLoadedContext);
			addTestSuite(TestNetNegotiator);
			addTestSuite(TestNetConnectionFactory);
			addTestSuite(TestNetLoader);
 			addTestSuite(TestNetClient);
			addTestSuite(TestNetStreamUtils);
			addTestSuite(TestStreamingURLResource);

			addTestSuite(TestNetStreamAudioTrait);
			addTestSuite(TestNetStreamBufferTrait);
			addTestSuite(TestNetStreamLoadTrait);
			addTestSuite(TestNetStreamPlayTrait);
			addTestSuite(TestNetStreamSeekTrait);
			addTestSuite(TestNetStreamTimeTrait);
			addTestSuite(TestNetStreamDisplayObjectTrait);
			
			addTestSuite(TestManifestParser);
			addTestSuite(TestF4MLoader);		

			// Dynamic Streaming
			//
			
			addTestSuite(TestBandwidthRule);
			addTestSuite(TestBufferRule);
			addTestSuite(TestFrameDropRule);
			addTestSuite(TestSwitchUpRule);
			addTestSuite(TestDynamicStreamingItem);
			addTestSuite(TestDynamicStreamingResource);
			
			addTestSuite(TestDynamicStreamingNetLoader);
			addTestSuite(TestDynamicNetStream);
			addTestSuite(TestNetStreamDynamicStreamTrait);
			
			// HTTP Streaming
			//
			
			addTestSuite(TestBoxParser);
			addTestSuite(TestAdobeBootstrapBox);
			addTestSuite(TestAdobeFragmentRunTable);
			addTestSuite(TestAdobeSegmentRunTable);
			addTestSuite(TestFLVHeader);

			// Images & SWFs
			//
			
			addTestSuite(TestImageLoader);
			addTestSuite(TestImageElement);

			addTestSuite(TestSWFLoader);
			addTestSuite(TestSWFElement);
			
			// Plugins
			//
			
			addTestSuite(TestPluginElement);
			addTestSuite(TestStaticPluginLoader);
			addTestSuite(TestDynamicPluginLoader);
			addTestSuite(TestPluginManager);
			addTestSuite(TestPluginLoadingState);
			addTestSuite(TestPluginLoadedContext);

			// Proxies
			//
			
			addTestSuite(TestProxyElement);
			addTestSuite(TestProxyElementAsDynamicProxy);
			addTestSuite(TestTemporalProxyElement);
			addTestSuite(TestListenerProxyElement);
			addTestSuite(TestListenerProxyElementAsSubclass);
			addTestSuite(TestFactoryElement);
			addTestSuite(TestFactoryLoadTrait);
			
			// Tracking
			//
			
			addTestSuite(TestBeacon);
			addTestSuite(TestBeaconElement);
									
			// VAST
			//
			
			addTestSuite(TestVASTLoader);
			addTestSuite(TestVASTParser);
			addTestSuite(TestDefaultVASTMediaFileResolver);
			addTestSuite(TestVASTImpressionProxyElement);
			addTestSuite(TestVASTMediaGenerator);
			addTestSuite(TestVASTTrackingProxyElement);
			
			// Additional MediaPlayer tests
			//
			
			addTestSuite(TestMediaPlayerWithAudioElement);
			addTestSuite(TestMediaPlayerWithVideoElement);
			addTestSuite(TestMediaPlayerWithVideoElementSubclip);
			addTestSuite(TestMediaPlayerWithDynamicStreamingVideoElement);
			addTestSuite(TestMediaPlayerWithDynamicStreamingVideoElementSubclip);
			addTestSuite(TestMediaPlayerWithProxyElement);
			addTestSuite(TestMediaPlayerWithTemporalProxyElement);
			addTestSuite(TestMediaPlayerWithBeaconElement);*/
		}
	}
}
