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
package org.osmf.audio
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.URLResource;
	import org.osmf.traits.ILoader;
	import org.osmf.traits.TestLoadTrait;
	import org.osmf.utils.NullResource;
	import org.osmf.utils.URL;
	import org.osmf.utils.TestConstants;

	public class TestSoundLoadTrait extends TestLoadTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			var loader:ILoader = args.length > 0 ? args[0] : null;
			var resource:IMediaResource = args.length > 1 ? args[1] : null;

			var sound:Sound = new Sound(new URLRequest(TestConstants.LOCAL_SOUND_FILE));

			return new SoundLoadTrait(loader, resource);
		}
		
		override protected function createLoader():ILoader
		{
			return new SoundLoader();
		}

		override protected function get successfulResource():IMediaResource
		{
			return SUCCESSFUL_RESOURCE;
		}

		override protected function get failedResource():IMediaResource
		{
			return FAILED_RESOURCE;
		}

		override protected function get unhandledResource():IMediaResource
		{
			return UNHANDLED_RESOURCE;
		}

		override protected function get expectedBytesTotal():Number
		{
			return TestConstants.LOCAL_SOUND_FILE_EXPECTED_BYTES;
		}
		
		override protected function get bytesTotalSetWhenReady():Boolean
		{
			return true;
		}
		
		private static const SUCCESSFUL_RESOURCE:URLResource = new URLResource(new URL(TestConstants.LOCAL_SOUND_FILE));
		private static const FAILED_RESOURCE:URLResource = new URLResource(new URL(TestConstants.LOCAL_INVALID_SOUND_FILE));
		private static const UNHANDLED_RESOURCE:IMediaResource = new NullResource();
	}
}