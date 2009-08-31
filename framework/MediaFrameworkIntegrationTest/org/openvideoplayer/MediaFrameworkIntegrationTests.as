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
	
	import org.openvideoplayer.image.TestImageElementIntegration;
	import org.openvideoplayer.image.TestImageLoaderIntegration;
	import org.openvideoplayer.media.TestMediaPlayer;
	import org.openvideoplayer.net.TestNetLoader;
	import org.openvideoplayer.plugin.TestDynamicPluginLoaderIntegration;
	import org.openvideoplayer.plugin.TestPluginManagerIntegration;
	import org.openvideoplayer.swf.TestSWFElementIntegration;
	import org.openvideoplayer.swf.TestSWFLoaderIntegration;
	import org.openvideoplayer.utils.NetFactory;
	import org.openvideoplayer.video.TestVideoElement;

	public class MediaFrameworkIntegrationTests extends TestSuite
	{
		public function MediaFrameworkIntegrationTests(param:Object=null)
		{
			super(param);
			
			
			NetFactory.neverUseMockObjects = true;
			
			// Tests that use mock objects, now to be run a second time without
			// using mock objects:
			
			this.addTestSuite(TestMediaPlayer);

			this.addTestSuite(TestNetLoader);
			
			this.addTestSuite(TestVideoElement);
			
			// Tests that can't use mock objects, and are therefore only in the
			// integration test suite:

			this.addTestSuite(TestImageLoaderIntegration);
			this.addTestSuite(TestImageElementIntegration);
			
			this.addTestSuite(TestSWFLoaderIntegration);
			this.addTestSuite(TestSWFElementIntegration)
			
			this.addTestSuite(TestDynamicPluginLoaderIntegration);
			
			this.addTestSuite(TestPluginManagerIntegration);
		}
	}
}