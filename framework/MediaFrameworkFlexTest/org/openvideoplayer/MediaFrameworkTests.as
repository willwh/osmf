/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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
	import org.openvideoplayer.image.TestImageElement;
	import org.openvideoplayer.image.TestImageLoadedContext;
	import org.openvideoplayer.image.TestImageLoader;
	import org.openvideoplayer.loaders.*;
	import org.openvideoplayer.media.*;
	import org.openvideoplayer.net.*;
	import org.openvideoplayer.plugin.TestPluginElement;
	import org.openvideoplayer.plugin.TestPluginFactory;
	import org.openvideoplayer.plugin.TestPluginLoader;
	import org.openvideoplayer.proxies.TestProxyElement;
	import org.openvideoplayer.proxies.TestTemporalProxyElement;
	import org.openvideoplayer.traits.*;
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
			this.addTestSuite(TestAudioPlayableTrait);
			this.addTestSuite(TestAudioElement);
			this.addTestSuite(TestAudioSeekableTrait); 
			//This test fails intermittently on the build machine.  Awaiting new machine to reenable.
			//this.addTestSuite(TestAudioTemporalTrait);
			
			this.addTestSuite(TestMediaPlayer);
			
			this.addTestSuite(TestMediaElementSprite);
			this.addTestSuite(TestScalableSprite);
			this.addTestSuite(TestMediaPlayerSprite);

			this.addTestSuite(TestVersion);		
			
		}
	}
}
