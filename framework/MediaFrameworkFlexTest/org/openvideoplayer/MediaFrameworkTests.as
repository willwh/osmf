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
	
	import org.openvideoplayer.audio.TestAudioAudibleTrait;
	import org.openvideoplayer.audio.TestAudioElement;
	import org.openvideoplayer.audio.TestAudioPausibleTrait;
	import org.openvideoplayer.audio.TestAudioPlayableTrait;
	import org.openvideoplayer.audio.TestAudioSeekableTrait;
	import org.openvideoplayer.composition.*;
	import org.openvideoplayer.display.TestMediaElementSprite;
	import org.openvideoplayer.display.TestMediaPlayerSprite;
	import org.openvideoplayer.display.TestScalableSprite;
	import org.openvideoplayer.events.TestMediaError;
	import org.openvideoplayer.events.TestMediaErrorAsSubclass;
	import org.openvideoplayer.image.TestImageElement;
	import org.openvideoplayer.image.TestImageLoadedContext;
	import org.openvideoplayer.image.TestImageLoader;
	import org.openvideoplayer.net.TestNetConnectionFactory;
	import org.openvideoplayer.loaders.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.metadata.TestKeyValueMetadata;
	import org.openvideoplayer.metadata.TestMediaType;
	import org.openvideoplayer.metadata.TestMetadataCollection;
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.plugin.TestPluginElement;
	import org.openvideoplayer.plugin.TestPluginFactory;
	import org.openvideoplayer.plugin.TestPluginLoader;
	import org.openvideoplayer.proxies.TestProxyElement;
	import org.openvideoplayer.proxies.TestTemporalProxyElement;
	import org.openvideoplayer.traits.*;
	import org.openvideoplayer.utils.TestURL;
	import org.openvideoplayer.utils.TestFMSURL;
	import org.openvideoplayer.version.TestVersion;
	import org.openvideoplayer.video.*;

	public class MediaFrameworkTests extends TestSuite
	{
		public function MediaFrameworkTests(param:Object=null)
		{
			super(param);
			
			// Uncomment this line to run all tests against the network.
			//NetFactory.neverUseMockObjects = true;
			
			this.addTestSuite(TestPluginElement);
			this.addTestSuite(TestPluginFactory);
			this.addTestSuite(TestPluginLoader);

			this.addTestSuite(TestCompositeElement);
			this.addTestSuite(TestParallelElement);
			this.addTestSuite(TestSerialElement);
			this.addTestSuite(TestTraitAggregator);
			this.addTestSuite(TestTraitLoader);

			this.addTestSuite(TestCompositeAudibleTrait);
			
			this.addTestSuite(TestMediaError);
			this.addTestSuite(TestMediaErrorAsSubclass);
		
			this.addTestSuite(TestMediaElement);
			this.addTestSuite(TestMediaElementAsSubclass);
			this.addTestSuite(TestLoadableMediaElement);
			this.addTestSuite(TestMediaFactory);
			this.addTestSuite(TestMediaInfo);
			this.addTestSuite(TestURLResource);
			
			this.addTestSuite(TestProxyElement);
			this.addTestSuite(TestTemporalProxyElement);
			
			this.addTestSuite(TestPlayableTrait);
			this.addTestSuite(TestPausibleTrait);
			this.addTestSuite(TestTemporalTrait);
			this.addTestSuite(TestSeekableTrait);
			this.addTestSuite(TestAudibleTrait);
			this.addTestSuite(TestViewableTrait);
			this.addTestSuite(TestBufferableTrait);
			
			this.addTestSuite(TestNetLoader);
			this.addTestSuite(TestNetLoadedContext);
			this.addTestSuite(TestNetConnectionFactory);
			this.addTestSuite(TestNetNegotiator);
			
 			this.addTestSuite(TestVideoElement);
			this.addTestSuite(TestNetClient);
			
			this.addTestSuite(TestNetStreamAudibleTrait);
			this.addTestSuite(TestNetStreamBufferableTrait);
			this.addTestSuite(TestNetStreamPlayableTrait);
			this.addTestSuite(TestNetStreamPausibleTrait);
			this.addTestSuite(TestNetStreamSeekableTrait);
			this.addTestSuite(TestNetStreamTemporalTrait);
			
			this.addTestSuite(TestImageLoadedContext);
			this.addTestSuite(TestImageLoader);
			this.addTestSuite(TestImageElement);
	
			this.addTestSuite(TestAudioAudibleTrait);
			this.addTestSuite(TestAudioPausibleTrait);
			this.addTestSuite(TestAudioElement);
			this.addTestSuite(TestAudioSeekableTrait); 
			//These tests fail intermittently on the build machine.  Awaiting new machine to reenable.
			//this.addTestSuite(TestAudioTemporalTrait);
			//this.addTestSuite(TestAudioPlayableTrait);
						
			this.addTestSuite(TestMediaPlayer);
			
		 	this.addTestSuite(TestMediaElementSprite);
			this.addTestSuite(TestScalableSprite);
			this.addTestSuite(TestMediaPlayerSprite);

			this.addTestSuite(TestVersion);		
			
			this.addTestSuite(TestURL);
			this.addTestSuite(TestFMSURL);
			
			this.addTestSuite(TestMetadataCollection);
			this.addTestSuite(TestMediaType);
			this.addTestSuite(TestKeyValueMetadata); 
			
		}
	}
}
