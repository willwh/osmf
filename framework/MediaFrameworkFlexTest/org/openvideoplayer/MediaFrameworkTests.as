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
package org.openvideoplayer
{
	import flexunit.framework.TestSuite;
	
	import org.openvideoplayer.audio.*;
	import org.openvideoplayer.composition.*;
	import org.openvideoplayer.content.*;
	import org.openvideoplayer.display.*;
	import org.openvideoplayer.events.*;
	import org.openvideoplayer.image.*;
	import org.openvideoplayer.layout.*;
	import org.openvideoplayer.loaders.*;
	import org.openvideoplayer.logging.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.metadata.*;
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.net.dynamicstreaming.*;
	import org.openvideoplayer.plugin.*;
	import org.openvideoplayer.proxies.*;
	import org.openvideoplayer.regions.*;
	import org.openvideoplayer.swf.*;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.*;
	import org.openvideoplayer.version.*;
	import org.openvideoplayer.video.*;

	public class MediaFrameworkTests extends TestSuite
	{
		public function MediaFrameworkTests(param:Object=null)
		{
			super(param);
			
			// Uncomment this line to run all tests against the network.
			//NetFactory.neverUseMockObjects = true;
		
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
			
			addTestSuite(TestRegionSprite);
			addTestSuite(TestRegionTargetFacet);
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
			addTestSuite(TestTemporalProxyElement);
			
			addTestSuite(TestPlayableTrait);
			addTestSuite(TestPausableTrait);
			addTestSuite(TestTemporalTrait);
			addTestSuite(TestSeekableTrait);
			addTestSuite(TestAudibleTrait);
			addTestSuite(TestViewableTrait);
			addTestSuite(TestBufferableTrait);
			
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
			
			addTestSuite(TestContentLoader);
			addTestSuite(TestContentElement);
			
			addTestSuite(TestImageLoader);
			addTestSuite(TestImageElement);

			addTestSuite(TestSWFLoader);
			addTestSuite(TestSWFElement);
	
			addTestSuite(TestAudioElement);
			addTestSuite(TestAudioElementWithSoundLoader);
			addTestSuite(TestSoundLoader);

			addTestSuite(TestAudioAudibleTrait);
			addTestSuite(TestAudioSeekableTrait); 
			addTestSuite(TestAudioTemporalTrait);
			
			// These two tests fail intermittently on the build machine.
			//addTestSuite(TestAudioPlayableTrait);
			//addTestSuite(TestAudioPausableTrait);
						
			addTestSuite(TestMediaPlayer);
			
		 	addTestSuite(TestMediaElementSprite);
			addTestSuite(TestScalableSprite);
			addTestSuite(TestMediaPlayerSprite);

			addTestSuite(TestVersion);		
			
			addTestSuite(TestURL);
			addTestSuite(TestFMSURL);
				
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
		}
	}
}
