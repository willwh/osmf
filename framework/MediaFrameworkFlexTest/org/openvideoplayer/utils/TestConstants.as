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
package org.openvideoplayer.utils
{
	/**
	 * Centralized test class for constants, such as URLs to resources.
	 * 
	 * If your test is the only one that needs a constant, then the
	 * constant should be scoped to the test class.  Only place it here
	 * if it makes sense for multiple test classes to use it.
	 **/
	public class TestConstants
	{
		
		// Root assets folder (currently only being used for SWFs)
		public static const INTEGRATION_TEST_ASSET_ROOT:String = "http://flipside.corp.adobe.com/strobe/integration_test_assets/";
		
		
		// Videos
		//
		
		public static const REMOTE_PROGRESSIVE_VIDEO:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		public static const REMOTE_PROGRESSIVE_VIDEO_EXPECTED_DURATION:Number = 30;
		public static const REMOTE_PROGRESSIVE_VIDEO_EXPECTED_WIDTH:Number = 640;
		public static const REMOTE_PROGRESSIVE_VIDEO_EXPECTED_HEIGHT:Number = 352;
		
		public static const REMOTE_STREAMING_VIDEO:String
			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short.flv";
			
		public static const INVALID_STREAMING_VIDEO:String
			= "rtmp://cp67126.edgefcsfail.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short.flv"
		
		// Images
		//
		
		public static const REMOTE_IMAGE_FILE:String = "http://www.adobe.com/ubi/globalnav/include/adobe-lq.png";
		public static const REMOTE_INVALID_IMAGE_FILE:String = "http://www.adobe.com/ubi/fail/globalnav/include/adobe-lq.png";
		
		public static const LOCAL_IMAGE_FILE:String = "assets/image.gif";
		
		// Audio
		//
		
		public static const LOCAL_SOUND_FILE:String = "assets/sound.mp3";
		
		public static const STREAMING_AUDIO_FILE:String
			= "rtmp://cp67126.edgefcs.net/ondemand/mp3:mediapm/ovp/content/test/video/nocc_small.mp3";
		
		// SWFS
		//
		
		public static const REMOTE_VALID_PLUGIN_SWF_URL:String = INTEGRATION_TEST_ASSET_ROOT + "ASPlugin_valid.swf";
		public static const REMOTE_INVALID_PLUGIN_SWF_URL:String = INTEGRATION_TEST_ASSET_ROOT + "ASPlugin_invalid.swf";
		public static const REMOTE_UNHANDLED_PLUGIN_RESOURCE_URL:String = INTEGRATION_TEST_ASSET_ROOT + "ASPlugin_unhandled.foo";
	}
}