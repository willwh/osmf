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
		
		public static const DEFAULT_PORT_PROTOCOL_RESULT:String = "1935rtmp443rtmp80rtmp1935rtmps443rtmps80rtmps1935rtmpt443rtmpt80rtmpt";
		
		public static const RESULT_FOR_RTMPTE_443:String = "443rtmpte";
		
		public static const REMOTE_STREAMING_VIDEO_WITH_PORT_PROTOCOL:String
			= "rtmpte://cp67126.edgefcs.net:443/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short.flv";
		
		public static const CONNECT_ADDRESS_REMOTE_WITH_RTMPTE_443:String = "rtmpte://cp67126.edgefcs.net:443/ondemand";
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