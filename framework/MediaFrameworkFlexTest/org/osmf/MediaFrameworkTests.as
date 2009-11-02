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
	import org.osmf.content.*;
	import org.osmf.display.*;
	import org.osmf.events.*;
	import org.osmf.gateways.*;
	import org.osmf.html.*;
	import org.osmf.image.*;
	import org.osmf.layout.*;
	import org.osmf.logging.*;
	import org.osmf.media.*;
	import org.osmf.metadata.*;
	import org.osmf.net.*;
	import org.osmf.net.dynamicstreaming.*;
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

	public class MediaFrameworkTests extends TestSuite
	{
		public function MediaFrameworkTests(param:Object=null)
		{
			super(param);
						
			// Uncomment this line to run all tests against the network.
			//NetFactory.neverUseMockObjects = true;
			
			CONFIG::FLASH_10_1
			{
				addTestSuite(TestContentProtectable);
			}
			addTestSuite(TestAbsoluteLayoutFacet);
			addTestSuite(TestAnchorLayoutFacet);
			addTestSuite(TestLayoutRendererBase);
			addTestSuite(TestDefaultLayoutRenderer);
			addTestSuite(TestLayoutAttributesFacet);
			addTestSuite(TestLayoutRendererFacet);
			addTestSuite(TestLayoutContextSprite);
			addTestSuite(TestMediaElementLayoutTarget);
			addTestSuite(TestPaddingLayoutFacet);
			addTestSuite(TestRegistrationPoint);
			addTestSuite(TestRelativeLayoutFacet);
			addTestSuite(TestLayoutUtils);
			
			addTestSuite(TestRegionGateway);
			addTestSuite(TestHTMLGateway);
			addTestSuite(TestSerialViewableTrait);
			addTestSuite(TestParallelViewableTrait);
						
			addTestSuite(TestMetadata);
			addTestSuite(TestMediaType);
			addTestSuite(TestKeyValueFacet);
			addTestSuite(TestObjectIdentifier);
			addTestSuite(TestMetadataUtils);
			addTestSuite(TestCompositeMetadata);
			
			addTestSuite(TestLoaderBase);
			
			addTestSuite(TestPluginElement);
			addTestSuite(TestStaticPluginLoader);
			addTestSuite(TestDynamicPluginLoader);

			addTestSuite(TestCompositeElement);
			addTestSuite(TestParallelElement);
			addTestSuite(TestSerialElement);
			addTestSuite(TestTraitAggregator);
			addTestSuite(TestTraitLoader);
			
			addTestSuite(TestCompositeViewableTrait);
			addTestSuite(TestCompositeAudibleTrait);
			
			addTestSuite(TestMediaError);
			addTestSuite(TestMediaErrorAsSubclass);
		
			addTestSuite(TestMediaElement);
			addTestSuite(TestMediaElementAsSubclass);
			addTestSuite(TestLoadableMediaElement);
			addTestSuite(TestMediaFactory);
			addTestSuite(TestMediaInfo);
			addTestSuite(TestURLResource);
			
			addTestSuite(TestProxyElement);
			addTestSuite(TestProxyElementAsDynamicProxy);
			addTestSuite(TestTemporalProxyElement);
			addTestSuite(TestListenerProxyElement);
			addTestSuite(TestListenerProxyElementAsSubclass);
			
			addTestSuite(TestBeacon);
			addTestSuite(TestBeaconElement);
			
			addTestSuite(TestPlayableTrait);
			addTestSuite(TestPausableTrait);
			addTestSuite(TestTemporalTrait);
			addTestSuite(TestSeekableTrait);
			addTestSuite(TestAudibleTrait);
			addTestSuite(TestViewableTrait);
			addTestSuite(TestBufferableTrait);
			addTestSuite(TestDownloadableTrait);
			
			addTestSuite(TestSwitchableTrait);
			
			addTestSuite(TestNetLoader);
			addTestSuite(TestNetLoadedContext);
			addTestSuite(TestNetConnectionFactory);
			addTestSuite(TestNetNegotiator);
			
 			addTestSuite(TestVideoElement);
			addTestSuite(TestNetClient);

			addTestSuite(TestNetStreamAudibleTrait);
			addTestSuite(TestNetStreamBufferableTrait);
			addTestSuite(TestNetStreamPlayableTrait);
			addTestSuite(TestNetStreamPausableTrait);
			addTestSuite(TestNetStreamSeekableTrait);
			addTestSuite(TestNetStreamTemporalTrait);
			addTestSuite(TestNetStreamSwitchableTrait);
			addTestSuite(TestNetStreamDownloadableTrait);
			
			addTestSuite(TestContentDownloadableTrait);
			addTestSuite(TestContentLoader);
			addTestSuite(TestContentElement);
			
			addTestSuite(TestImageLoader);
			addTestSuite(TestImageElement);

			addTestSuite(TestSWFLoader);
			addTestSuite(TestSWFElement);
	
			addTestSuite(TestAudioElement);
			addTestSuite(TestAudioElementWithSoundLoader);
			addTestSuite(TestSoundLoader);
			addTestSuite(TestSoundDownloadableTrait);

			addTestSuite(TestAudioAudibleTrait);
			addTestSuite(TestAudioSeekableTrait); 
			addTestSuite(TestAudioTemporalTrait);
			
			// These two tests fail intermittently on the build machine.
			//addTestSuite(TestAudioPlayableTrait);
			//addTestSuite(TestAudioPausableTrait);

			addTestSuite(TestMediaPlayer);
			addTestSuite(TestMediaPlayerWithAudioElement);
			//addTestSuite(TestMediaPlayerWithAudioElementWithSoundLoader);
			addTestSuite(TestMediaPlayerWithVideoElement);
			addTestSuite(TestMediaPlayerWithDynamicStreamingVideoElement);
			addTestSuite(TestMediaPlayerWithProxyElement);
			addTestSuite(TestMediaPlayerWithTemporalProxyElement);
			addTestSuite(TestMediaPlayerWithBeaconElement);
			
		 	addTestSuite(TestMediaElementSprite);
			addTestSuite(TestScalableSprite);
			addTestSuite(TestMediaPlayerSprite);

			addTestSuite(TestVersion);		
			
			addTestSuite(TestURL);
			addTestSuite(TestFMSURL);
			addTestSuite(TestBinarySearch);
			
			addTestSuite(TestPluginManager);
			addTestSuite(TestPluginLoadingState);
			addTestSuite(TestPluginLoadedContext);
			
			addTestSuite(TestBandwidthRule);
			addTestSuite(TestBufferRule);
			addTestSuite(TestFrameDropRule);
			addTestSuite(TestSwitchUpRule);
			addTestSuite(TestDynamicStreamingItem);
			addTestSuite(TestDynamicStreamingResource);
			
			addTestSuite(TestDynamicStreamingNetLoader);
			addTestSuite(TestDynamicNetStream);
			addTestSuite(TestParallelSwitchableTrait);
			addTestSuite(TestSerialSwitchableTrait);

			addTestSuite(TestLog);
			addTestSuite(TestTraceLogger);
			addTestSuite(TestTraceLoggerFactory);
			
			addTestSuite(TestHTTPLoader);

			addTestSuite(TestVASTLoader);
		
			addTestSuite(TestVASTParser);
			addTestSuite(TestDefaultVASTMediaFileResolver);
			addTestSuite(TestVASTImpressionProxyElement);
			addTestSuite(TestVASTMediaGenerator);
			addTestSuite(TestVASTTrackingProxyElement);		

			addTestSuite(TestCuePoint);
			addTestSuite(TestTemporalFacet);			

		}
	}
}
