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
	
	import org.osmf.image.TestImageElementIntegration;
	import org.osmf.image.TestImageLoaderIntegration;
	import org.osmf.media.TestMediaPlayer;
	import org.osmf.net.TestNetLoader;
	import org.osmf.plugin.TestDynamicPluginLoaderIntegration;
	import org.osmf.plugin.TestPluginManagerIntegration;
	import org.osmf.swf.TestSWFElementIntegration;
	import org.osmf.swf.TestSWFLoaderIntegration;
	import org.osmf.utils.NetFactory;
	import org.osmf.utils.TestHTTPLoader;
	import org.osmf.video.TestVideoElement;

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

			this.addTestSuite(TestHTTPLoader);
			
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