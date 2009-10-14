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
package org.osmf.media
{
	import org.osmf.tracking.Beacon;
	import org.osmf.tracking.BeaconElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.HTTPLoader;
	import org.osmf.utils.MockHTTPLoader;
	import org.osmf.utils.URL;
	
	public class TestMediaPlayerWithBeaconElement extends TestMediaPlayer
	{
		// Overrides
		//
		
		override public function setUp():void
		{
			// Change this to HTTPLoader to run against the network.
			httpLoader = new MockHTTPLoader();
			
			super.setUp();
		}
		
		override public function tearDown():void
		{
			super.tearDown();
			
			httpLoader = null;
		}
				
		override protected function createMediaElement(resource:IMediaResource):MediaElement
		{
			if (httpLoader is MockHTTPLoader)
			{
				MockHTTPLoader(httpLoader).setExpectationForURL(PING_URL.rawUrl, true, null);
				MockHTTPLoader(httpLoader).setExpectationForURL(INVALID_URL.rawUrl, false, null);
			}
			
			return new BeaconElement(new Beacon(PING_URL, httpLoader));
		}
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(PING_URL)
		}

		override protected function get invalidResourceForMediaElement():IMediaResource
		{
			return new URLResource(INVALID_URL);
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [MediaTraitType.PLAYABLE];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [MediaTraitType.PLAYABLE];
		}
		
		private static const PING_URL:URL = new URL("http://example.com");
		private static const INVALID_URL:URL = new URL("http://www.adobe.com/invalidURL");
		
		private var httpLoader:HTTPLoader;
	}
}
